import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_filter_options.g.dart';

@CopyWith()
@JsonSerializable(includeIfNull: false, createFactory: true, createToJson: true)
class DocumentFilterOptions with EquatableMixin {
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
  @JsonKey(defaultValue: true)
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
  final List<int>? tagsIdAll;
  @JsonKey(name: 'tags__id__in')
  final List<int>? tagsIdIn;
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
  final String? query;
  DocumentFilterOptions({
    this.addedDateGt,
    this.addedDateGte,
    this.addedDateLt,
    this.addedDateLte,
    this.addedDay,
    this.addedGt,
    this.addedGte,
    this.addedLt,
    this.addedLte,
    this.addedMonth,
    this.addedYear,
    this.archiveSerialNumber,
    this.archiveSerialNumberGt,
    this.archiveSerialNumberGte,
    this.archiveSerialNumberIsnull,
    this.archiveSerialNumberLt,
    this.archiveSerialNumberLte,
    this.checksumIcontains,
    this.checksumIendswith,
    this.checksumIexact,
    this.checksumIstartswith,
    this.contentIcontains,
    this.contentIendswith,
    this.contentIexact,
    this.contentIstartswith,
    this.correspondentId,
    this.correspondentIdIn,
    this.correspondentIdNone,
    this.correspondentIsnull,
    this.correspondentNameIcontains,
    this.correspondentNameIendswith,
    this.correspondentNameIexact,
    this.correspondentNameIstartswith,
    this.createdDateGt,
    this.createdDateGte,
    this.createdDateLt,
    this.createdDateLte,
    this.createdDay,
    this.createdGt,
    this.createdGte,
    this.createdLt,
    this.createdLte,
    this.createdMonth,
    this.createdYear,
    this.customFieldQuery,
    this.customFieldsIcontains,
    this.customFieldsIdAll,
    this.customFieldsIdIn,
    this.customFieldsIdNone,
    this.documentTypeId,
    this.documentTypeIdIn,
    this.documentTypeIdNone,
    this.documentTypeIsnull,
    this.documentTypeNameIcontains,
    this.documentTypeNameIendswith,
    this.documentTypeNameIexact,
    this.documentTypeNameIstartswith,
    this.fields,
    this.fullPerms = true,
    this.hasCustomFields,
    this.id,
    this.idIn,
    this.isInInbox,
    this.isTagged,
    this.mimeType,
    this.modifiedDateGt,
    this.modifiedDateGte,
    this.modifiedDateLt,
    this.modifiedDateLte,
    this.modifiedDay,
    this.modifiedGt,
    this.modifiedGte,
    this.modifiedLt,
    this.modifiedLte,
    this.modifiedMonth,
    this.modifiedYear,
    this.ordering,
    this.originalFilenameIcontains,
    this.originalFilenameIendswith,
    this.originalFilenameIexact,
    this.originalFilenameIstartswith,
    this.ownerId,
    this.ownerIdIn,
    this.ownerIdNone,
    this.ownerIsnull,
    this.page,
    this.pageSize,
    this.search,
    this.sharedById,
    this.storagePathId,
    this.storagePathIdIn,
    this.storagePathIdNone,
    this.storagePathIsnull,
    this.storagePathNameIcontains,
    this.storagePathNameIendswith,
    this.storagePathNameIexact,
    this.storagePathNameIstartswith,
    this.tagsId,
    this.tagsIdAll,
    this.tagsIdIn,
    this.tagsIdNone,
    this.tagsNameIcontains,
    this.tagsNameIendswith,
    this.tagsNameIexact,
    this.tagsNameIstartswith,
    this.titleIcontains,
    this.titleIendswith,
    this.titleIexact,
    this.titleIstartswith,
    this.titleContent,
    this.query,
  });

  Map<String, dynamic> toJson() => _$DocumentFilterOptionsToJson(this);
  factory DocumentFilterOptions.fromJson(Map<String, dynamic> json) =>
      _$DocumentFilterOptionsFromJson(json);

  @override
  List<Object?> get props => [
    addedDateGt,
    addedDateGte,
    addedDateLt,
    addedDateLte,
    addedDay,
    addedGt,
    addedGte,
    addedLt,
    addedLte,
    addedMonth,
    addedYear,
    archiveSerialNumber,
    archiveSerialNumberGt,
    archiveSerialNumberGte,
    archiveSerialNumberIsnull,
    archiveSerialNumberLt,
    archiveSerialNumberLte,
    checksumIcontains,
    checksumIendswith,
    checksumIexact,
    checksumIstartswith,
    contentIcontains,
    contentIendswith,
    contentIexact,
    contentIstartswith,
    correspondentId,
    correspondentIdIn,
    correspondentIdNone,
    correspondentIsnull,
    correspondentNameIcontains,
    correspondentNameIendswith,
    correspondentNameIexact,
    correspondentNameIstartswith,
    createdDateGt,
    createdDateGte,
    createdDateLt,
    createdDateLte,
    createdDay,
    createdGt,
    createdGte,
    createdLt,
    createdLte,
    createdMonth,
    createdYear,
    customFieldQuery,
    customFieldsIcontains,
    customFieldsIdAll,
    customFieldsIdIn,
    customFieldsIdNone,
    documentTypeId,
    documentTypeIdIn,
    documentTypeIdNone,
    documentTypeIsnull,
    documentTypeNameIcontains,
    documentTypeNameIendswith,
    documentTypeNameIexact,
    documentTypeNameIstartswith,
    fields,
    fullPerms,
    hasCustomFields,
    id,
    idIn,
    isInInbox,
    isTagged,
    mimeType,
    modifiedDateGt,
    modifiedDateGte,
    modifiedDateLt,
    modifiedDateLte,
    modifiedDay,
    modifiedGt,
    modifiedGte,
    modifiedLt,
    modifiedLte,
    modifiedMonth,
    modifiedYear,
    ordering,
    originalFilenameIcontains,
    originalFilenameIendswith,
    originalFilenameIexact,
    originalFilenameIstartswith,
    ownerId,
    ownerIdIn,
    ownerIdNone,
    ownerIsnull,
    page,
    pageSize,
    search,
    sharedById,
    storagePathId,
    storagePathIdIn,
    storagePathIdNone,
    storagePathIsnull,
    storagePathNameIcontains,
    storagePathNameIendswith,
    storagePathNameIexact,
    storagePathNameIstartswith,
    tagsId,
    tagsIdAll,
    tagsIdIn,
    tagsIdNone,
    tagsNameIcontains,
    tagsNameIendswith,
    tagsNameIexact,
    tagsNameIstartswith,
    titleIcontains,
    titleIendswith,
    titleIexact,
    titleIstartswith,
    titleContent,
  ];
}
