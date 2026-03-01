import 'package:paperless_api/generated/lib/src/model/user.dart';

extension DisplayNameExtension on User {
  String get displayName {
    if ((firstName?.isNotEmpty ?? false) && (lastName?.isNotEmpty ?? false)) {
      return '$firstName $lastName';
    } else {
      return username;
    }
  }
}
