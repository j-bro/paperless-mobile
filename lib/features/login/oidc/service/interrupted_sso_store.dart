import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paperless_mobile/api/modules/oidc_api.dart';
import 'package:paperless_mobile/features/logging/data/logger.dart';
import 'package:paperless_mobile/features/login/oidc/model/oidc_provider.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/auth_route.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An SSO attempt that left the app for the system browser and may never
/// have come back (e.g. Android killed the app while the browser was in
/// front — AppAuth keeps its state in memory, so a cold start drops the
/// response and strands the user on an empty connect screen).
///
/// Only non-secret data is persisted (server URL + provider id/name).
/// The resume path deliberately uses the in-process WebView fallback flow:
/// it needs no discovery round-trip and cannot be orphaned by a browser
/// round-trip again.
class InterruptedSsoAttempt {
  final String serverUrl;
  final OidcProvider provider;
  final DateTime startedAt;

  const InterruptedSsoAttempt({
    required this.serverUrl,
    required this.provider,
    required this.startedAt,
  });

  Map<String, dynamic> toJson() => {
    'serverUrl': serverUrl,
    'providerId': provider.id,
    'providerName': provider.name,
    'startedAt': startedAt.toIso8601String(),
  };

  static InterruptedSsoAttempt? fromJson(Map<String, dynamic> json) {
    try {
      final serverUrl = json['serverUrl'] as String?;
      final providerId = json['providerId'] as String?;
      final startedAt = DateTime.tryParse(json['startedAt'] as String? ?? '');
      if (serverUrl == null ||
          serverUrl.isEmpty ||
          providerId == null ||
          providerId.isEmpty ||
          startedAt == null) {
        return null;
      }
      return InterruptedSsoAttempt(
        serverUrl: serverUrl,
        provider: OidcProvider(
          id: providerId,
          name: (json['providerName'] as String?)?.trim().isNotEmpty == true
              ? (json['providerName'] as String).trim()
              : providerId,
        ),
        startedAt: startedAt,
      );
    } catch (_) {
      return null;
    }
  }
}

class InterruptedSsoStore {
  static const storageKey = 'interrupted_sso_attempt';

  /// Attempts older than this are treated as abandoned and cleared silently.
  static const freshnessWindow = Duration(minutes: 30);

  final SharedPreferences _prefs;
  InterruptedSsoStore(this._prefs);

  static Future<InterruptedSsoStore> load() async =>
      InterruptedSsoStore(await SharedPreferences.getInstance());

  Future<void> save(InterruptedSsoAttempt attempt) async {
    try {
      final json = attempt.toJson();
      // SharedPreferences has no Map API; store the fields flat.
      await _prefs.setString('$storageKey.serverUrl', json['serverUrl'] as String);
      await _prefs.setString('$storageKey.providerId', json['providerId'] as String);
      await _prefs.setString('$storageKey.providerName', json['providerName'] as String);
      await _prefs.setString('$storageKey.startedAt', json['startedAt'] as String);
    } catch (error, stackTrace) {
      // Best-effort: persistence must never break login itself.
      logger.fw(
        'Could not persist interrupted-SSO attempt.',
        className: runtimeType.toString(),
        methodName: 'save',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> clear() async {
    try {
      await _prefs.remove('$storageKey.serverUrl');
      await _prefs.remove('$storageKey.providerId');
      await _prefs.remove('$storageKey.providerName');
      await _prefs.remove('$storageKey.startedAt');
    } catch (error, stackTrace) {
      logger.fw(
        'Could not clear interrupted-SSO attempt.',
        className: runtimeType.toString(),
        methodName: 'clear',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Returns the pending attempt and consumes it, or null when there is
  /// none (or it is stale/corrupt, which is cleared silently).
  Future<InterruptedSsoAttempt?> takeIfFresh({DateTime? now}) async {
    final attempt = _read();
    if (attempt == null) return null;
    final age = (now ?? DateTime.now()).difference(attempt.startedAt);
    if (age.isNegative || age > freshnessWindow) {
      await clear();
      return null;
    }
    await clear();
    return attempt;
  }

  InterruptedSsoAttempt? _read() {
    try {
      final serverUrl = _prefs.getString('$storageKey.serverUrl');
      final providerId = _prefs.getString('$storageKey.providerId');
      final providerName = _prefs.getString('$storageKey.providerName');
      final startedAtRaw = _prefs.getString('$storageKey.startedAt');
      return InterruptedSsoAttempt.fromJson({
        'serverUrl': serverUrl,
        'providerId': providerId,
        'providerName': providerName,
        'startedAt': startedAtRaw,
      });
    } catch (_) {
      return null;
    }
  }
}

/// Metadata about an SSO redirect observed by the native relay, as
/// recorded in `sso_redirect_observation.json`. Presence flags only —
/// secret values never touch disk.
class RedirectObservation {
  final DateTime receivedAt;
  final bool hasCode;
  final bool hasState;
  final bool hasError;
  final String? error;

  /// True when the relay was the only activity in the task, i.e. the app
  /// process was dead and this redirect cold-started it.
  final bool coldStart;

  const RedirectObservation({
    required this.receivedAt,
    required this.hasCode,
    required this.hasState,
    required this.hasError,
    this.error,
    required this.coldStart,
  });
}

/// Pure parse of the relay's observation file. Null on any malformed input.
RedirectObservation? parseRedirectObservationJson(String raw) {
  try {
    final json = jsonDecode(raw);
    if (json is! Map) return null;
    final millis = json['receivedAtMillis'];
    if (millis is! int) return null;
    return RedirectObservation(
      receivedAt: DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true),
      hasCode: json['hasCode'] == true,
      hasState: json['hasState'] == true,
      hasError: json['hasError'] == true,
      error: json['error'] as String?,
      coldStart: json['coldStart'] == true,
    );
  } catch (_) {
    return null;
  }
}

/// Reads, logs and deletes the native relay's observation file, if present.
/// Null when there is none (or it is unreadable). Never throws.
Future<RedirectObservation?> drainRedirectObservation() async {
  try {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/sso_redirect_observation.json');
    if (!await file.exists()) return null;
    final observation = parseRedirectObservationJson(await file.readAsString());
    try {
      await file.delete();
    } catch (_) {
      // Best-effort cleanup.
    }
    if (observation == null) return null;
    logger.fi(
      'SSO redirect observed at ${observation.receivedAt.toIso8601String()} '
      '(code: ${observation.hasCode}, state: ${observation.hasState}, '
      'coldStart: ${observation.coldStart}, '
      'error: ${observation.hasError}'
      '${observation.error == null ? '' : ' (${observation.error})'}).',
      className: 'InterruptedSsoStore',
      methodName: 'drainRedirectObservation',
    );
    return observation;
  } catch (_) {
    return null;
  }
}

/// Startup recovery: if a previous SSO attempt never finished and there is
/// still no session, land directly on that server's login page in WebView
/// fallback mode (one tap resumes via the in-process flow) instead of a
/// dead, empty connect screen. Returns true when it navigated.
Future<bool> resumeInterruptedSso(BuildContext context) async {
  // Drain first: a redirect may have arrived just before the process died.
  await drainRedirectObservation();
  InterruptedSsoAttempt? attempt;
  try {
    attempt = await (await InterruptedSsoStore.load()).takeIfFresh();
  } catch (_) {
    return false;
  }
  if (attempt == null || !context.mounted) return false;
  logger.fi(
    'Resuming interrupted SSO for ${attempt.provider.id} in WebView fallback mode.',
    className: 'InterruptedSsoStore',
    methodName: 'resumeInterruptedSso',
  );
  AuthenticateRoute(
    serverUrl: attempt.serverUrl,
    $extra: AuthRouteExtra(
      oidcCapability: OidcCapability(
        flow: OidcFlow.webFallback,
        providers: [attempt.provider],
      ),
    ),
  ).go(context);
  if (context.mounted) {
    showSnackBar(context, S.of(context)!.ssoLoginInterrupted);
  }
  return true;
}
