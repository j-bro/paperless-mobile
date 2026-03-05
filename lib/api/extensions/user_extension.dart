import 'package:paperless_mobile/api/models/user.dart';

extension DisplayNameExtension on User {
  String get displayName {
    if ((firstName?.isNotEmpty ?? false) && (lastName?.isNotEmpty ?? false)) {
      return '$firstName $lastName';
    } else {
      return username;
    }
  }
}
