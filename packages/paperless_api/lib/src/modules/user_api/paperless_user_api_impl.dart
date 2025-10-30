import 'package:dio/dio.dart';
import 'package:paperless_api/generated/lib/src/model/patched_user_request.dart';
import 'package:paperless_api/generated/lib/src/model/ui_settings_view.dart';
import 'package:paperless_api/generated/lib/src/model/user.dart';
import 'package:paperless_api/generated/lib/src/model/user_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_api/src/models/request/user_filter_options.dart';
import 'package:paperless_api/src/modules/base_crud_api_impl_mixin.dart';

class PaperlessUserApiImpl extends PaperlessUserApi
    with
        BaseCrudApiImplMixin<
          User,
          UserRequest,
          PatchedUserRequest,
          UserFilterOptions
        > {
  @override
  final Dio client;

  PaperlessUserApiImpl(this.client);

  @override
  String get path => "/api/users/";
  @override
  User parse(Map<String, dynamic> json) => User.fromJson(json);
  @override
  Map<String, dynamic> requestToJson(UserRequest request) => request.toJson();
  @override
  Map<String, dynamic> patchedRequestToJson(PatchedUserRequest request) =>
      request.toJson();
  @override
  Map<String, dynamic>? filterOptionsToJson(UserFilterOptions? options) =>
      options?.toJson();
  @override
  ErrorCode get createErrorCode => ErrorCode.userCreateError;
  @override
  ErrorCode get deleteErrorCode => ErrorCode.userDeleteError;
  @override
  ErrorCode get getErrorCode => ErrorCode.userGetError;
  @override
  ErrorCode get listErrorCode => ErrorCode.userListError;
  @override
  ErrorCode get patchErrorCode => ErrorCode.userUpdateError;
  @override
  ErrorCode get putErrorCode => ErrorCode.userUpdateError;

  @override
  Future<User?> getCurrentUser() async {
    final response = await client.get<Map<String, dynamic>>(
      '/api/ui_settings/',
    );
    final uiSettings = UiSettingsView.fromJson(response.data!);
    if (uiSettings.user?.id == null) {
      throw PaperlessApiException(
        ErrorCode.userGetError,
        details: "Could not retrieve current user from UI settings.",
      );
    }
    return get(uiSettings.user!.id!);
  }

  @override
  Future<String> deactivateTotp(int id) {
    try {
      return client
          .post<Map<String, dynamic>>('/api/users/$id/deactivate_totp/')
          .then((response) => response.data!['detail'] as String);
    } catch (e) {
      throw PaperlessApiException(
        ErrorCode.userUpdateError,
        details: "Could not deactivate TOTP for user with id $id: $e",
      );
    }
  }
}
