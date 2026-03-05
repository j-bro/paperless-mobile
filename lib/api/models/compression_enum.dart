//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `none` - none * `deflated` - deflated * `bzip2` - bzip2 * `lzma` - lzma
enum CompressionEnum {
  /// * `none` - none * `deflated` - deflated * `bzip2` - bzip2 * `lzma` - lzma
  @JsonValue(r'none')
  none(r'none'),

  /// * `none` - none * `deflated` - deflated * `bzip2` - bzip2 * `lzma` - lzma
  @JsonValue(r'deflated')
  deflated(r'deflated'),

  /// * `none` - none * `deflated` - deflated * `bzip2` - bzip2 * `lzma` - lzma
  @JsonValue(r'bzip2')
  bzip2(r'bzip2'),

  /// * `none` - none * `deflated` - deflated * `bzip2` - bzip2 * `lzma` - lzma
  @JsonValue(r'lzma')
  lzma(r'lzma');

  const CompressionEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
