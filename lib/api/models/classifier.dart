import 'package:freezed_annotation/freezed_annotation.dart';

part 'classifier.freezed.dart';
part 'classifier.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class Classifier with _$Classifier {
  factory Classifier({
    required String status,
    required String error,
    required DateTime lastTrained,
  }) = _Classifier;

  factory Classifier.fromJson(Map<String, dynamic> json) =>
      _$ClassifierFromJson(json);
}
