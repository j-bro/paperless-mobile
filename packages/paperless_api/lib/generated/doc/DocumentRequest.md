# paperless_api/generated/lib.model.DocumentRequest

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**correspondent** | **int** |  | 
**documentType** | **int** |  | 
**storagePath** | **int** |  | 
**title** | **String** |  | [optional] 
**content** | **String** | The raw, text-only data of the document. This field is primarily used for searching. | [optional] 
**tags** | **List&lt;int&gt;** |  | 
**created** | [**DateTime**](DateTime.md) |  | [optional] 
**createdDate** | [**DateTime**](DateTime.md) |  | [optional] 
**deletedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**archiveSerialNumber** | **int** | The position of this document in your physical document archive. | [optional] 
**owner** | **int** |  | [optional] 
**setPermissions** | [**CorrespondentRequestSetPermissions**](CorrespondentRequestSetPermissions.md) |  | [optional] 
**customFields** | [**List&lt;CustomFieldInstanceRequest&gt;**](CustomFieldInstanceRequest.md) |  | [optional] 
**removeInboxTags** | **bool** |  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


