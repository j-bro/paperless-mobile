# paperless_api/generated/lib.model.Document

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**correspondent** | **int** |  | 
**documentType** | **int** |  | 
**storagePath** | **int** |  | 
**title** | **String** |  | [optional] 
**content** | **String** | The raw, text-only data of the document. This field is primarily used for searching. | [optional] 
**tags** | **List&lt;int&gt;** |  | 
**created** | [**DateTime**](DateTime.md) |  | [optional] 
**createdDate** | [**DateTime**](DateTime.md) |  | [optional] 
**modified** | [**DateTime**](DateTime.md) |  | 
**added** | [**DateTime**](DateTime.md) |  | 
**deletedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**archiveSerialNumber** | **int** | The position of this document in your physical document archive. | [optional] 
**originalFileName** | **String** |  | 
**archivedFileName** | **String** |  | 
**owner** | **int** |  | [optional] 
**permissions** | [**CorrespondentPermissions**](CorrespondentPermissions.md) |  | 
**userCanChange** | **bool** |  | 
**isSharedByRequester** | **bool** |  | 
**notes** | [**List&lt;Notes&gt;**](Notes.md) |  | 
**customFields** | [**List&lt;CustomFieldInstance&gt;**](CustomFieldInstance.md) |  | [optional] 
**pageCount** | **int** |  | 
**mimeType** | **String** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


