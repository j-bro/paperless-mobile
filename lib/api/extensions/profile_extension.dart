import 'package:paperless_mobile/api/paperless_api.dart';

extension DisplayNameExtension on Profile {
  String get displayName {
    if ((firstName?.isNotEmpty ?? false) || (lastName?.isNotEmpty ?? false)) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    } else {
      return email ?? 'Unknown User';
    }
  }
}
