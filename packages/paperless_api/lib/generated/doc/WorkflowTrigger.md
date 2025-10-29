# paperless_api/generated/lib.model.WorkflowTrigger

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | [optional] 
**sources** | [**List&lt;SourcesEnum&gt;**](SourcesEnum.md) |  | [optional] 
**type** | [**WorkflowTriggerTypeEnum**](WorkflowTriggerTypeEnum.md) |  | 
**filterPath** | **String** | Only consume documents with a path that matches this if specified. Wildcards specified as * are allowed. Case insensitive. | [optional] 
**filterFilename** | **String** | Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive. | [optional] 
**filterMailrule** | **int** |  | [optional] 
**matchingAlgorithm** | [**WorkflowTriggerMatchingAlgorithmEnum**](WorkflowTriggerMatchingAlgorithmEnum.md) |  | [optional] 
**match** | **String** |  | [optional] 
**isInsensitive** | **bool** |  | [optional] 
**filterHasTags** | **List&lt;int&gt;** |  | [optional] 
**filterHasCorrespondent** | **int** |  | [optional] 
**filterHasDocumentType** | **int** |  | [optional] 
**scheduleOffsetDays** | **int** | The number of days to offset the schedule trigger by. | [optional] 
**scheduleIsRecurring** | **bool** | If the schedule should be recurring. | [optional] 
**scheduleRecurringIntervalDays** | **int** | The number of days between recurring schedule triggers. | [optional] 
**scheduleDateField** | [**ScheduleDateFieldEnum**](ScheduleDateFieldEnum.md) | The field to check for a schedule trigger.  * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field | [optional] 
**scheduleDateCustomField** | **int** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


