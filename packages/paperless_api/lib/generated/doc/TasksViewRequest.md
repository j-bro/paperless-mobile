# paperless_api/generated/lib.model.TasksViewRequest

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**taskId** | **String** | Celery ID for the Task that was run | 
**taskName** | [**TaskNameEnum**](TaskNameEnum.md) |  | [optional] 
**taskFileName** | **String** | Name of the file which the Task was run for | [optional] 
**dateCreated** | [**DateTime**](DateTime.md) | Datetime field when the task result was created in UTC | [optional] 
**dateDone** | [**DateTime**](DateTime.md) | Datetime field when the task was completed in UTC | [optional] 
**type** | [**TasksViewTypeEnum**](TasksViewTypeEnum.md) | The type of task that was run  * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task | [optional] 
**status** | [**StatusEnum**](StatusEnum.md) | Current state of the task being run  * `FAILURE` - FAILURE * `PENDING` - PENDING * `RECEIVED` - RECEIVED * `RETRY` - RETRY * `REVOKED` - REVOKED * `STARTED` - STARTED * `SUCCESS` - SUCCESS | [optional] 
**result** | **String** | The data returned by the task | [optional] 
**acknowledged** | **bool** | If the task is acknowledged via the frontend or API | [optional] 
**owner** | **int** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


