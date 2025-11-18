import 'package:flutter/material.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/correspondent_repository.dart';
import 'package:paperless_mobile/core/repository/custom_field_repository.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/core/repository/document_type_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/repository/storage_path_repository.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/core/store/slices/global_settings.dart';
import 'package:paperless_mobile/core/store/slices/local_user_account.dart';
import 'package:paperless_mobile/core/store/slices/local_user_data.dart';
import 'package:provider/provider.dart';

extension ContextExtensions on BuildContext {
  LocalStore get localStore => read<LocalStore>();
  LocalStore get localStore$ => watch<LocalStore>();

  String? get loggedInUserId$ =>
      select<LocalStore, String?>((state) => state.state.loggedInUserId);
  String? get loggedInUserId => localStore.state.loggedInUserId;

  GlobalSettings get globalSettings$ =>
      select<LocalStore, GlobalSettings>((state) => state.state.globalSettings);

  Map<String, LocalUserData> get localUserData$ =>
      select<LocalStore, Map<String, LocalUserData>>(
        (state) => state.state.localUserData,
      );

  void updateGlobalSettings(GlobalSettings newSettings) =>
      localStore.updateGlobalSettings(newSettings);

  LocalUserData get loggedInUserData$ => localUserData$[loggedInUserId$]!;
  LocalUserAccount get loggedInUser$ =>
      localUserData$[loggedInUserId$]!.remoteUser;

  DocumentRepository get documentRepository => read<DocumentRepository>();
  SavedViewRepository get savedViewRepository => read<SavedViewRepository>();
  CorrespondentRepository get correspondentRepository =>
      read<CorrespondentRepository>();
  DocumentTypeRepository get documentTypeRepository =>
      read<DocumentTypeRepository>();
  TagRepository get tagRepository => read<TagRepository>();
  StoragePathRepository get storagePathRepository =>
      read<StoragePathRepository>();
  CustomFieldsRepository get customFieldRepository =>
      read<CustomFieldsRepository>();
  InboxRepository get inboxRepository => read<InboxRepository>();

  DocumentFilter get currentDocumentFilter$ =>
      loggedInUserData$.appState!.currentDocumentFilter;
  DocumentFilter get currentDocumentFilter => localStore
      .state
      .localUserData[loggedInUserId$]!
      .appState!
      .currentDocumentFilter;
}
