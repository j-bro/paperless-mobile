import 'package:freezed_annotation/freezed_annotation.dart';

part 'index.freezed.dart';
part 'index.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class Index with _$Index {
  factory Index({
    required String status,
    required String error,
    required DateTime lastModified,
  }) = _Index;

  factory Index.fromJson(Map<String, dynamic> json) => _$IndexFromJson(json);
}
