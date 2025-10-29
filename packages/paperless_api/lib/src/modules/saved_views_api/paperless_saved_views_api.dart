import 'package:paperless_api/generated/lib/src/model/patched_saved_view_request.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view.dart';
import 'package:paperless_api/generated/lib/src/model/saved_view_request.dart';
import 'package:paperless_api/src/models/request/get_filter_options.dart';
import 'package:paperless_api/src/modules/crud_api.dart';

abstract class PaperlessSavedViewsApi
    extends
        CrudApi<
          SavedView,
          SavedViewRequest,
          PatchedSavedViewRequest,
          GetFilterOptions
        > {}
