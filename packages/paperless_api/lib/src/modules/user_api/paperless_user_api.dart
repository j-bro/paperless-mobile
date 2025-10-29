import 'package:paperless_api/generated/lib/src/model/patched_user_request.dart';
import 'package:paperless_api/generated/lib/src/model/user.dart';
import 'package:paperless_api/generated/lib/src/model/user_request.dart';
import 'package:paperless_api/src/models/request/user_filter_options.dart';
import 'package:paperless_api/src/modules/crud_api.dart';

abstract class PaperlessUserApi
    extends CrudApi<User, UserRequest, PatchedUserRequest, UserFilterOptions> {
  Future<User> getCurrentUser();
}
