import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_filter_options.g.dart';

@CopyWith()
@JsonSerializable(
  includeIfNull: false,
  createFactory: false,
  createToJson: true,
)
class DocumentFilterOptions {
  @JsonKey(name: 'added_date__gt')
  final DateTime? addedDateGt;
  @JsonKey(name: 'added_date__gte')
  final DateTime? addedDateGte;
  @JsonKey(name: 'added_date__lt')
  final DateTime? addedDateLt;
  @JsonKey(name: 'added_date__lte')
  final DateTime? addedDateLte;
  @JsonKey(name: 'added__day')
  final num? addedDay;
  @JsonKey(name: 'added__gt')
  final DateTime? addedGt;
  @JsonKey(name: 'added__gte')
  final DateTime? addedGte;
  @JsonKey(name: 'added__lt')
  final DateTime? addedLt;
  @JsonKey(name: 'added__lte')
  final DateTime? addedLte;
  @JsonKey(name: 'added__month')
  final num? addedMonth;
  @JsonKey(name: 'added__year')
  final num? addedYear;
  final int? archiveSerialNumber;
  @JsonKey(name: 'archive_serial_number__gt')
  final int? archiveSerialNumberGt;
  @JsonKey(name: 'archive_serial_number__gte')
  final int? archiveSerialNumberGte;
  @JsonKey(name: 'archive_serial_number__isnull')
  final bool? archiveSerialNumberIsnull;
  @JsonKey(name: 'archive_serial_number__lt')
  final int? archiveSerialNumberLt;
  @JsonKey(name: 'archive_serial_number__lte')
  final int? archiveSerialNumberLte;
  @JsonKey(name: 'checksum__icontains')
  final String? checksumIcontains;
  @JsonKey(name: 'checksum__iendswith')
  final String? checksumIendswith;
  @JsonKey(name: 'checksum__iexact')
  final String? checksumIexact;
  @JsonKey(name: 'checksum__istartswith')
  final String? checksumIstartswith;
  @JsonKey(name: 'content__icontains')
  final String? contentIcontains;
  @JsonKey(name: 'content__iendswith')
  final String? contentIendswith;
  @JsonKey(name: 'content__iexact')
  final String? contentIexact;
  @JsonKey(name: 'content__istartswith')
  final String? contentIstartswith;
  @JsonKey(name: 'correspondent__id')
  final int? correspondentId;
  @JsonKey(name: 'correspondent__id__in')
  final List<int>? correspondentIdIn;
  @JsonKey(name: 'correspondent__id__none')
  final int? correspondentIdNone;
  @JsonKey(name: 'correspondent__isnull')
  final bool? correspondentIsnull;
  @JsonKey(name: 'correspondent__name__icontains')
  final String? correspondentNameIcontains;
  @JsonKey(name: 'correspondent__name__iendswith')
  final String? correspondentNameIendswith;
  @JsonKey(name: 'correspondent__name__iexact')
  final String? correspondentNameIexact;
  @JsonKey(name: 'correspondent__name__istartswith')
  final String? correspondentNameIstartswith;
  @JsonKey(name: 'created_date__gt')
  final DateTime? createdDateGt;
  @JsonKey(name: 'created_date__gte')
  final DateTime? createdDateGte;
  @JsonKey(name: 'created_date__lt')
  final DateTime? createdDateLt;
  @JsonKey(name: 'created_date__lte')
  final DateTime? createdDateLte;
  @JsonKey(name: 'created__day')
  final num? createdDay;
  @JsonKey(name: 'created__gt')
  final DateTime? createdGt;
  @JsonKey(name: 'created__gte')
  final DateTime? createdGte;
  @JsonKey(name: 'created__lt')
  final DateTime? createdLt;
  @JsonKey(name: 'created__lte')
  final DateTime? createdLte;
  @JsonKey(name: 'created__month')
  final num? createdMonth;
  @JsonKey(name: 'created__year')
  final num? createdYear;
  final String? customFieldQuery;
  @JsonKey(name: 'custom_fields__icontains')
  final String? customFieldsIcontains;
  @JsonKey(name: 'custom_fields__id__all')
  final int? customFieldsIdAll;
  @JsonKey(name: 'custom_fields__id__in')
  final int? customFieldsIdIn;
  @JsonKey(name: 'custom_fields__id__none')
  final int? customFieldsIdNone;
  @JsonKey(name: 'document_type__id')
  final int? documentTypeId;
  @JsonKey(name: 'document_type__id__in')
  final List<int>? documentTypeIdIn;
  @JsonKey(name: 'document_type__id__none')
  final int? documentTypeIdNone;
  @JsonKey(name: 'document_type__isnull')
  final bool? documentTypeIsnull;
  @JsonKey(name: 'document_type__name__icontains')
  final String? documentTypeNameIcontains;
  @JsonKey(name: 'document_type__name__iendswith')
  final String? documentTypeNameIendswith;
  @JsonKey(name: 'document_type__name__iexact')
  final String? documentTypeNameIexact;
  @JsonKey(name: 'document_type__name__istartswith')
  final String? documentTypeNameIstartswith;
  final List<String>? fields;
  final bool? fullPerms;
  final bool? hasCustomFields;
  final int? id;
  @JsonKey(name: 'id__in')
  final List<int>? idIn;
  final bool? isInInbox;
  final bool? isTagged;
  final String? mimeType;
  @JsonKey(name: 'modified_date__gt')
  final DateTime? modifiedDateGt;
  @JsonKey(name: 'modified_date__gte')
  final DateTime? modifiedDateGte;
  @JsonKey(name: 'modified_date__lt')
  final DateTime? modifiedDateLt;
  @JsonKey(name: 'modified_date__lte')
  final DateTime? modifiedDateLte;
  @JsonKey(name: 'modified__day')
  final num? modifiedDay;
  @JsonKey(name: 'modified__gt')
  final DateTime? modifiedGt;
  @JsonKey(name: 'modified__gte')
  final DateTime? modifiedGte;
  @JsonKey(name: 'modified__lt')
  final DateTime? modifiedLt;
  @JsonKey(name: 'modified__lte')
  final DateTime? modifiedLte;
  @JsonKey(name: 'modified__month')
  final num? modifiedMonth;
  @JsonKey(name: 'modified__year')
  final num? modifiedYear;
  final String? ordering;
  @JsonKey(name: 'original_filename__icontains')
  final String? originalFilenameIcontains;
  @JsonKey(name: 'original_filename__iendswith')
  final String? originalFilenameIendswith;
  @JsonKey(name: 'original_filename__iexact')
  final String? originalFilenameIexact;
  @JsonKey(name: 'original_filename__istartswith')
  final String? originalFilenameIstartswith;
  @JsonKey(name: 'owner__id')
  final int? ownerId;
  @JsonKey(name: 'owner__id__in')
  final List<int>? ownerIdIn;
  @JsonKey(name: 'owner__id__none')
  final int? ownerIdNone;
  @JsonKey(name: 'owner__isnull')
  final bool? ownerIsnull;
  final int? page;
  final int? pageSize;
  final String? search;
  @JsonKey(name: 'shared_by__id')
  final bool? sharedById;
  @JsonKey(name: 'storage_path__id')
  final int? storagePathId;
  @JsonKey(name: 'storage_path__id__in')
  final List<int>? storagePathIdIn;
  @JsonKey(name: 'storage_path__id__none')
  final int? storagePathIdNone;
  @JsonKey(name: 'storage_path__isnull')
  final bool? storagePathIsnull;
  @JsonKey(name: 'storage_path__name__icontains')
  final String? storagePathNameIcontains;
  @JsonKey(name: 'storage_path__name__iendswith')
  final String? storagePathNameIendswith;
  @JsonKey(name: 'storage_path__name__iexact')
  final String? storagePathNameIexact;
  @JsonKey(name: 'storage_path__name__istartswith')
  final String? storagePathNameIstartswith;
  @JsonKey(name: 'tags__id')
  final int? tagsId;
  @JsonKey(name: 'tags__id__all')
  final int? tagsIdAll;
  @JsonKey(name: 'tags__id__in')
  final int? tagsIdIn;
  @JsonKey(name: 'tags__id__none')
  final int? tagsIdNone;
  @JsonKey(name: 'tags__name__icontains')
  final String? tagsNameIcontains;
  @JsonKey(name: 'tags__name__iendswith')
  final String? tagsNameIendswith;
  @JsonKey(name: 'tags__name__iexact')
  final String? tagsNameIexact;
  @JsonKey(name: 'tags__name__istartswith')
  final String? tagsNameIstartswith;
  @JsonKey(name: 'title__icontains')
  final String? titleIcontains;
  @JsonKey(name: 'title__iendswith')
  final String? titleIendswith;
  @JsonKey(name: 'title__iexact')
  final String? titleIexact;
  @JsonKey(name: 'title__istartswith')
  final String? titleIstartswith;
  final String? titleContent;

  DocumentFilterOptions({
    required this.addedDateGt,
    required this.addedDateGte,
    required this.addedDateLt,
    required this.addedDateLte,
    required this.addedDay,
    required this.addedGt,
    required this.addedGte,
    required this.addedLt,
    required this.addedLte,
    required this.addedMonth,
    required this.addedYear,
    required this.archiveSerialNumber,
    required this.archiveSerialNumberGt,
    required this.archiveSerialNumberGte,
    required this.archiveSerialNumberIsnull,
    required this.archiveSerialNumberLt,
    required this.archiveSerialNumberLte,
    required this.checksumIcontains,
    required this.checksumIendswith,
    required this.checksumIexact,
    required this.checksumIstartswith,
    required this.contentIcontains,
    required this.contentIendswith,
    required this.contentIexact,
    required this.contentIstartswith,
    required this.correspondentId,
    required this.correspondentIdIn,
    required this.correspondentIdNone,
    required this.correspondentIsnull,
    required this.correspondentNameIcontains,
    required this.correspondentNameIendswith,
    required this.correspondentNameIexact,
    required this.correspondentNameIstartswith,
    required this.createdDateGt,
    required this.createdDateGte,
    required this.createdDateLt,
    required this.createdDateLte,
    required this.createdDay,
    required this.createdGt,
    required this.createdGte,
    required this.createdLt,
    required this.createdLte,
    required this.createdMonth,
    required this.createdYear,
    required this.customFieldQuery,
    required this.customFieldsIcontains,
    required this.customFieldsIdAll,
    required this.customFieldsIdIn,
    required this.customFieldsIdNone,
    required this.documentTypeId,
    required this.documentTypeIdIn,
    required this.documentTypeIdNone,
    required this.documentTypeIsnull,
    required this.documentTypeNameIcontains,
    required this.documentTypeNameIendswith,
    required this.documentTypeNameIexact,
    required this.documentTypeNameIstartswith,
    required this.fields,
    required this.fullPerms,
    required this.hasCustomFields,
    required this.id,
    required this.idIn,
    required this.isInInbox,
    required this.isTagged,
    required this.mimeType,
    required this.modifiedDateGt,
    required this.modifiedDateGte,
    required this.modifiedDateLt,
    required this.modifiedDateLte,
    required this.modifiedDay,
    required this.modifiedGt,
    required this.modifiedGte,
    required this.modifiedLt,
    required this.modifiedLte,
    required this.modifiedMonth,
    required this.modifiedYear,
    required this.ordering,
    required this.originalFilenameIcontains,
    required this.originalFilenameIendswith,
    required this.originalFilenameIexact,
    required this.originalFilenameIstartswith,
    required this.ownerId,
    required this.ownerIdIn,
    required this.ownerIdNone,
    required this.ownerIsnull,
    required this.page,
    required this.pageSize,
    required this.search,
    required this.sharedById,
    required this.storagePathId,
    required this.storagePathIdIn,
    required this.storagePathIdNone,
    required this.storagePathIsnull,
    required this.storagePathNameIcontains,
    required this.storagePathNameIendswith,
    required this.storagePathNameIexact,
    required this.storagePathNameIstartswith,
    required this.tagsId,
    required this.tagsIdAll,
    required this.tagsIdIn,
    required this.tagsIdNone,
    required this.tagsNameIcontains,
    required this.tagsNameIendswith,
    required this.tagsNameIexact,
    required this.tagsNameIstartswith,
    required this.titleIcontains,
    required this.titleIendswith,
    required this.titleIexact,
    required this.titleIstartswith,
    required this.titleContent,
  });

  Map<String, dynamic> toJson() => _$DocumentFilterOptionsToJson(this);
}
