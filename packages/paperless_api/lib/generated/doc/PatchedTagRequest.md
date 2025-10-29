# paperless_api/generated/lib.model.PatchedTagRequest

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** |  | [optional] 
**color** | **String** |  | [optional] 
**match** | **String** |  | [optional] 
**matchingAlgorithm** | [**MatchingAlgorithm**](MatchingAlgorithm.md) |  | [optional] 
**isInsensitive** | **bool** |  | [optional] 
**isInboxTag** | **bool** | Marks this tag as an inbox tag: All newly consumed documents will be tagged with inbox tags. | [optional] 
**owner** | **int** |  | [optional] 
**setPermissions** | [**CorrespondentRequestSetPermissions**](CorrespondentRequestSetPermissions.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


