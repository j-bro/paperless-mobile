Map<String, dynamic>? unsafeToJson(dynamic item) {
  if (item == null) {
    return null;
  }
  final toJson = (item as dynamic).toJson;
  try {
    return toJson();
  } catch (e) {
    throw ArgumentError(
      'The provided type ${item.runtimeType} does not have a toJson() method.',
    );
  }
}
