enum DataTypeEnum {
  string,
  url,
  date,
  boolean,
  integer,
  float,
  monetary,
  documentlink,
  select;

  @override
  String toString() => name;
}
