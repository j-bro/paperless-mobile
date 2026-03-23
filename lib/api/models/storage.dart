import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage.freezed.dart';
part 'storage.g.dart';

@Freezed(toJson: false, fromJson: true)
abstract class Storage with _$Storage {
  factory Storage({required int total, required int available}) = _Storage;

  factory Storage.fromJson(Map<String, dynamic> json) =>
      _$StorageFromJson(json);
}
