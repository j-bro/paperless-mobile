import 'package:json_annotation/json_annotation.dart';

part 'paperless_server_statistics_model.g.dart';

@JsonSerializable(createToJson: false)
class PaperlessServerStatisticsModel {
  final int documentsTotal;
  final int documentsInbox;
  final int? inboxTag;
  final List<int> inboxTags;
  final int tagCount;
  final int correspondentCount;
  final int documentTypeCount;
  final int storagePathCount;
  final int? currentAsn;
  final List<DocumentFileTypeCount> documentFileTypeCounts;
  final int? characterCount;

  PaperlessServerStatisticsModel({
    this.documentsTotal = 0,
    this.documentsInbox = 0,
    this.inboxTag,
    this.inboxTags = const [],
    this.tagCount = 0,
    this.correspondentCount = 0,
    this.documentTypeCount = 0,
    this.storagePathCount = 0,
    this.currentAsn,
    this.documentFileTypeCounts = const [],
    this.characterCount,
  });

  factory PaperlessServerStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$PaperlessServerStatisticsModelFromJson(json);
}

@JsonSerializable(createToJson: false)
class DocumentFileTypeCount {
  final String mimeType;
  final int mimeTypeCount;

  DocumentFileTypeCount({required this.mimeType, required this.mimeTypeCount});

  factory DocumentFileTypeCount.fromJson(Map<String, dynamic> json) =>
      _$DocumentFileTypeCountFromJson(json);
}
