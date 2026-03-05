import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'queryParam')
enum QueryType {
  title('title__icontains'),
  titleAndContent('title_content'),
  extended('query'),
  asn('asn');

  final String queryParam;
  const QueryType(this.queryParam);
}
