import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum StatusEnum {
  failure(r'FAILURE'),
  pending(r'PENDING'),
  received(r'RECEIVED'),
  retry(r'RETRY'),
  revoked(r'REVOKED'),
  started(r'STARTED'),
  success(r'SUCCESS');

  const StatusEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
