# paperless_api/generated/lib.model.WorkflowActionWebhookRequest

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | [optional] 
**url** | **String** | The destination URL for the notification. | 
**useParams** | **bool** |  | [optional] 
**asJson** | **bool** |  | [optional] 
**params** | **Object** | The parameters to send with the webhook URL if body not used. | [optional] 
**body** | **String** | The body to send with the webhook URL if parameters not used. | [optional] 
**headers** | **Object** | The headers to send with the webhook URL. | [optional] 
**includeDocument** | **bool** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


