import 'package:paperless_mobile/api/models/models.dart';

extension LabelRequestConverterExtension on Label {
  LabelRequest toRequest() {
    switch (this) {
      case Correspondent():
        return CorrespondentRequest.fromJson(toJson());
      case DocumentType():
        return DocumentTypeRequest.fromJson(toJson());
      case StoragePath():
        return StoragePathRequest.fromJson(toJson());
      case Tag():
        return TagRequest.fromJson(toJson());
    }
  }
}
