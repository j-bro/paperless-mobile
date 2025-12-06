import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/extensions/context_extensions.dart';
import 'package:paperless_mobile/core/service/connectivity_status_service.dart';
import 'package:paperless_mobile/features/document_upload/view/document_upload_preparation_page.dart';
import 'package:paperless_mobile/features/notifications/services/local_notification_service.dart';
import 'package:paperless_mobile/features/sharing/cubit/receive_share_cubit.dart';
import 'package:paperless_mobile/features/sharing/view/dialog/discard_shared_file_dialog.dart';
import 'package:paperless_mobile/features/tasks/model/pending_tasks_notifier.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';
import 'package:paperless_mobile/helpers/message_helpers.dart';
import 'package:paperless_mobile/routing/routes/scanner_route.dart';
import 'package:path/path.dart' as p;
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class EventListenerShell extends StatefulWidget {
  final Widget child;
  const EventListenerShell({super.key, required this.child});

  @override
  State<EventListenerShell> createState() => _EventListenerShellState();
}

class _EventListenerShellState extends State<EventListenerShell>
    with WidgetsBindingObserver {
  StreamSubscription? _subscription;
  StreamSubscription? _documentDeletedSubscription;
  Timer? _inboxTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // ReceiveSharingIntent.instance.getInitialMedia().then(_onReceiveSharedFiles);
    // _subscription = ReceiveSharingIntent.instance.getMediaStream().listen(
    //   _onReceiveSharedFiles,
    // );
    // context.read<PendingTasksNotifier>().addListener(_onTasksChanged);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   final notifier = context.read<ConsumptionChangeNotifier>();
    //   await notifier.isInitialized;
    //   final pendingFiles = notifier.pendingFiles;
    //   if (pendingFiles.isEmpty) {
    //     return;
    //   }

    //   final shouldProcess = await showDialog<bool>(
    //         context: context,
    //         builder: (context) =>
    //             PendingFilesInfoDialog(pendingFiles: pendingFiles),
    //       ) ??
    //       false;
    //   if (shouldProcess) {
    //     final userId = context.read<LocalUserAccount>().id;
    //     await consumeLocalFiles(
    //       context,
    //       files: pendingFiles,
    //       userId: userId,
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _documentDeletedSubscription?.cancel();
    _inboxTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // debugPrint('AppLifecycleState changed to $state');
    // switch (state) {
    //   case AppLifecycleState.resumed:
    //     debugPrint(
    //       "App resumed, reloading connectivity and "
    //       "restarting periodic query for inbox changes...",
    //     );
    //     // context.read<ConnectivityCubit>().reload();
    //     break;
    //   case AppLifecycleState.inactive:
    //   case AppLifecycleState.paused:
    //   case AppLifecycleState.detached:
    //   default:
    //     _inboxTimer?.cancel();
    //     _inboxTimer = null;
    //     debugPrint(
    //       "App either paused or hidden, stopping "
    //       "periodic query for inbox changes.",
    //     );
    //     break;
    // }
  }

  void _onTasksChanged() {
    final taskNotifier = context.read<PendingTasksNotifier>();
    for (var task in taskNotifier.value.values) {
      context.read<LocalNotificationService>().notifyTaskChanged(
        task,
        userId: context.loggedInAppUserId!,
      );
    }
  }

  void _onReceiveSharedFiles(List<SharedMediaFile> sharedFiles) async {
    final files = sharedFiles.map((file) => File(file.path)).toList();
    final userId = context.loggedInAppUserId!;
    if (files.isNotEmpty) {
      final notifier = context.read<ConsumptionChangeNotifier>();
      final addedLocalFiles = await notifier.addFiles(
        files: files,
        userId: userId,
      );
      if (!mounted) return;
      consumeLocalFiles(
        context,
        files: addedLocalFiles,
        userId: userId,
        exitAppAfterConsumed: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Future<void> consumeLocalFile(
  BuildContext context, {
  required File file,
  required String userId,
  bool exitAppAfterConsumed = false,
}) async {
  final shouldDirectlyUpload =
      context.localStore.state.globalSettings.skipDocumentPreprarationOnUpload;
  final consumptionNotifier = context.read<ConsumptionChangeNotifier>();
  final taskNotifier = context.read<PendingTasksNotifier>();
  final filename = p.basename(file.path);
  final documentsApi = context.read<PaperlessDocumentsApi>();
  final hasInternetConnection = await context
      .read<ConnectivityStatusService>()
      .isConnectedToInternet();
  if (!hasInternetConnection) {
    if (context.mounted) {
      showSnackBar(
        context,
        "Could not consume $filename", //TODO: INTL
        details: S.of(context)!.youreOffline,
      );
    }
    return;
  }

  final bytes = file.readAsBytes();
  if (shouldDirectlyUpload) {
    try {
      final taskId = await documentsApi.create(
        await bytes,
        filename: filename,
        title: p.basenameWithoutExtension(file.path),
      );

      consumptionNotifier.discardFile(file, userId: userId);
      taskNotifier.listenToTaskChanges(taskId);
    } catch (error) {
      if (!context.mounted) return;
      await Fluttertoast.showToast(msg: S.of(context)!.couldNotUploadDocument);
      return;
    } finally {
      if (exitAppAfterConsumed) {
        SystemNavigator.pop();
      }
    }
  } else {
    final result =
        await DocumentUploadRoute(
          $extra: bytes,
          filename: p.basenameWithoutExtension(file.path),
          title: p.basenameWithoutExtension(file.path),
          fileExtension: p.extension(file.path),
        ).push<DocumentUploadResult>(context) ??
        DocumentUploadResult(false, null);

    if (result.success) {
      if (context.mounted) {
        await Fluttertoast.showToast(
          msg: S.of(context)!.documentSuccessfullyUploadedProcessing,
        );
      }
      await consumptionNotifier.discardFile(file, userId: userId);

      // if (result.taskId != null) {
      //   taskNotifier.listenToTaskChanges(result.taskId!);
      // }
      if (exitAppAfterConsumed) {
        SystemNavigator.pop();
      }
    } else {
      if (!context.mounted) return;
      final shouldDiscard =
          await showDialog<bool>(
            context: context,
            builder: (context) => DiscardSharedFileDialog(bytes: bytes),
          ) ??
          false;
      if (shouldDiscard && context.mounted) {
        await context.read<ConsumptionChangeNotifier>().discardFile(
          file,
          userId: userId,
        );
      }
    }
  }
}

Future<void> consumeLocalFiles(
  BuildContext context, {
  required List<File> files,
  required String userId,
  bool exitAppAfterConsumed = false,
}) async {
  for (int i = 0; i < files.length; i++) {
    final file = files[i];
    await consumeLocalFile(
      context,
      file: file,
      userId: userId,
      exitAppAfterConsumed: exitAppAfterConsumed && (i == files.length - 1),
    );
  }
}
