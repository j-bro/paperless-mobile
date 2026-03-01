//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `table` - Table * `smallCards` - Small Cards * `largeCards` - Large Cards
enum DisplayModeEnum {
  /// * `table` - Table * `smallCards` - Small Cards * `largeCards` - Large Cards
  @JsonValue(r'table')
  table(r'table'),

  /// * `table` - Table * `smallCards` - Small Cards * `largeCards` - Large Cards
  @JsonValue(r'smallCards')
  smallCards(r'smallCards'),

  /// * `table` - Table * `smallCards` - Small Cards * `largeCards` - Large Cards
  @JsonValue(r'largeCards')
  largeCards(r'largeCards');

  const DisplayModeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
