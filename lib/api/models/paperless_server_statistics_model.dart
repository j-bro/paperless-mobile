import 'package:freezed_annotation/freezed_annotation.dart';

part 'paperless_server_statistics_model.freezed.dart';
part 'paperless_server_statistics_model.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class PaperlessServerStatisticsModel
    with _$PaperlessServerStatisticsModel {
  factory PaperlessServerStatisticsModel({
    @Default(0) int documentsTotal,
    @Default(0) int documentsInbox,
    int? inboxTag,
    @Default(<int>[]) List<int> inboxTags,
    @Default(0) int tagCount,
    @Default(0) int correspondentCount,
    @Default(0) int documentTypeCount,
    @Default(0) int storagePathCount,
    int? currentAsn,
    @Default(<DocumentFileTypeCount>[])
    List<DocumentFileTypeCount> documentFileTypeCounts,
    int? characterCount,
  }) = _PaperlessServerStatisticsModel;

  factory PaperlessServerStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$PaperlessServerStatisticsModelFromJson(json);
}

@Freezed(toJson: false, fromJson: true)
abstract class DocumentFileTypeCount with _$DocumentFileTypeCount {
  factory DocumentFileTypeCount({
    required String mimeType,
    required int mimeTypeCount,
  }) = _DocumentFileTypeCount;

  factory DocumentFileTypeCount.fromJson(Map<String, dynamic> json) =>
      _$DocumentFileTypeCountFromJson(json);
}
