//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

/// * `consume_file` - Consume File * `train_classifier` - Train Classifier * `check_sanity` - Check Sanity * `index_optimize` - Index Optimize
enum TaskNameEnum {
  /// * `consume_file` - Consume File * `train_classifier` - Train Classifier * `check_sanity` - Check Sanity * `index_optimize` - Index Optimize
  @JsonValue(r'consume_file')
  consumeFile(r'consume_file'),

  /// * `consume_file` - Consume File * `train_classifier` - Train Classifier * `check_sanity` - Check Sanity * `index_optimize` - Index Optimize
  @JsonValue(r'train_classifier')
  trainClassifier(r'train_classifier'),

  /// * `consume_file` - Consume File * `train_classifier` - Train Classifier * `check_sanity` - Check Sanity * `index_optimize` - Index Optimize
  @JsonValue(r'check_sanity')
  checkSanity(r'check_sanity'),

  /// * `consume_file` - Consume File * `train_classifier` - Train Classifier * `check_sanity` - Check Sanity * `index_optimize` - Index Optimize
  @JsonValue(r'index_optimize')
  indexOptimize(r'index_optimize');

  const TaskNameEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
