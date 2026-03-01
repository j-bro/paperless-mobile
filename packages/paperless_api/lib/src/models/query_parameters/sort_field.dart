import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum SortField {
  archiveSerialNumber("archive_serial_number"),
  correspondentName("correspondent__name"),
  title("title"),
  documentType("document_type__name"),
  created("created"),
  added("added"),
  modified("modified"),
  score("score");

  final String value;

  const SortField(this.value);

  @override
  String toString() {
    return name.toLowerCase();
  }
}
