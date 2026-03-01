import 'package:paperless_api/paperless_api.dart';

extension LabelListExtension<T extends Label> on Iterable<T> {
  Map<int, T> toIdMap() {
    return {for (var label in this) label.id: label};
  }
}
