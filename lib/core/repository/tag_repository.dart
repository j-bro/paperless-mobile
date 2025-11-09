import 'package:paperless_api/generated/lib/src/model/patched_tag_request.dart';
import 'package:paperless_api/generated/lib/src/model/tag_request.dart';
import 'package:paperless_api/paperless_api.dart';
import 'package:paperless_mobile/core/repository/crud_repository.dart';

class TagRepository
    extends
        CrudRepository<Tag, TagRequest, PatchedTagRequest, GetFilterOptions> {
  @override
  final PaperlessTagsApi api;

  TagRepository(this.api);

  @override
  int extractId(Tag item) => item.id;

  @override
  String get queryKey => 'tags';
}
