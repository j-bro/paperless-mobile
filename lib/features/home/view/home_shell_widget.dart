import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/correspondent_repository.dart';
import 'package:paperless_mobile/core/repository/custom_field_repository.dart';
import 'package:paperless_mobile/core/repository/document_repository.dart';
import 'package:paperless_mobile/core/repository/document_type_repository.dart';
import 'package:paperless_mobile/core/repository/saved_view_repository.dart';
import 'package:paperless_mobile/core/repository/search_repository.dart';
import 'package:paperless_mobile/core/repository/server_statistics_repository.dart';
import 'package:paperless_mobile/core/repository/storage_path_repository.dart';
import 'package:paperless_mobile/core/repository/tag_repository.dart';
import 'package:paperless_mobile/core/repository/user_repository.dart';
import 'package:paperless_mobile/core/security/session_manager.dart';
import 'package:paperless_mobile/core/service/dio_file_service.dart';
import 'package:paperless_mobile/core/store/local_store.dart';
import 'package:paperless_mobile/features/document_scan/cubit/document_scanner_cubit.dart';
import 'package:paperless_mobile/features/inbox/cubit/inbox_cubit.dart';
import 'package:paperless_mobile/features/tasks/model/pending_tasks_notifier.dart';
import 'package:provider/provider.dart';

class HomeShellWidget extends StatelessWidget {
  /// The id of the currently authenticated user (e.g. demo@paperless.example.com)
  final String localUserId;

  /// The Paperless API version of the currently connected instance
  final int paperlessApiVersion;

  final Widget child;

  const HomeShellWidget({
    super.key,
    required this.paperlessApiVersion,
    required this.localUserId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final localStoreState = context.watch<LocalStore>().state;
    final currentUserId = localStoreState.loggedInUserId;
    if (currentUserId == null) {
      //This only happens during logout...
      //FIXME: Find way so this does not occur anymore
      return const SizedBox.shrink();
    }
    return MultiProvider(
      key: ValueKey(currentUserId),
      providers: [
        Provider(
          create: (context) => CacheManager(
            Config(
              // Isolated cache per user.
              localUserId,
              fileService: DioFileService(
                context.read<SessionManager>().client,
              ),
            ),
          ),
        ),
        Provider<PaperlessDocumentsApi>(
          create: (context) =>
              PaperlessDocumentsApiImpl(context.read<SessionManager>().client),
        ),
        Provider<PaperlessSearchApi>(
          create: (context) =>
              PaperlessSearchApiImpl(context.read<SessionManager>().client),
        ),
        Provider<PaperlessCorrespondentsApi>(
          create: (context) => PaperlessCorrespondentsApiImpl(
            context.read<SessionManager>().client,
          ),
        ),
        Provider<PaperlessDocumentTypesApi>(
          create: (context) => PaperlessDocumentTypesApiImpl(
            context.read<SessionManager>().client,
          ),
        ),
        Provider<PaperlessTagsApi>(
          create: (context) =>
              PaperlessTagsApiImpl(context.read<SessionManager>().client),
        ),
        Provider<PaperlessStoragePathsApi>(
          create: (context) => PaperlessStoragePathsApiImpl(
            context.read<SessionManager>().client,
          ),
        ),
        Provider<PaperlessSavedViewsApi>(
          create: (context) =>
              PaperlessSavedViewsApiImpl(context.read<SessionManager>().client),
        ),
        Provider<PaperlessCustomFieldsApi>(
          create: (context) => PaperlessCustomFieldsApiImpl(
            context.read<SessionManager>().client,
          ),
        ),
        Provider<PaperlessServerStatsApi>(
          create: (context) => PaperlessServerStatsApiImpl(
            context.read<SessionManager>().client,
          ),
        ),
        Provider<PaperlessTasksApi>(
          create: (context) =>
              PaperlessTasksApiImpl(context.read<SessionManager>().client),
        ),
        Provider<PaperlessUserApi>(
          create: (context) =>
              PaperlessUserApiImpl(context.read<SessionManager>().client),
        ),
      ],
      builder: (context, _) {
        return MultiProvider(
          providers: [
            Provider(create: (context) => DocumentRepository(context.read())),
            Provider(create: (context) => SearchRepository(context.read())),
            // For correspondent, document type, tag, storage path labels
            Provider(
              create: (context) => CorrespondentRepository(context.read()),
            ),
            Provider(
              create: (context) => DocumentTypeRepository(context.read()),
            ),
            Provider(create: (context) => TagRepository(context.read())),
            Provider(
              create: (context) => StoragePathRepository(context.read()),
            ),
            Provider(
              create: (context) =>
                  DocumentScannerCubit(context.read())..initialize(),
            ),
            Provider(create: (context) => UserRepository(context.read())),
            Provider(create: (context) => SavedViewRepository(context.read())),
            Provider(
              create: (context) => ServerStatisticsRepository(context.read()),
            ),
            Provider(
              create: (context) => CustomFieldsRepository(context.read()),
            ),
            Provider(
              create: (context) => InboxCubit(
                context.read(),
                context.read(),
                context.read(),
                context.read(),
                context.read(),
              )..initialize(),
            ),
            ChangeNotifierProvider(
              create: (context) => PendingTasksNotifier(context.read()),
            ),
          ],
          child: child,
        );
      },
    );
  }
}
