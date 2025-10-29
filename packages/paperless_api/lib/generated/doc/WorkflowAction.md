# paperless_api/generated/lib.model.WorkflowAction

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | [optional] 
**type** | [**WorkflowActionTypeEnum**](WorkflowActionTypeEnum.md) |  | [optional] 
**assignTitle** | **String** | Assign a document title, can include some placeholders, see documentation. | [optional] 
**assignTags** | **List&lt;int&gt;** |  | [optional] 
**assignCorrespondent** | **int** |  | [optional] 
**assignDocumentType** | **int** |  | [optional] 
**assignStoragePath** | **int** |  | [optional] 
**assignOwner** | **int** |  | [optional] 
**assignViewUsers** | **List&lt;int&gt;** |  | [optional] 
**assignViewGroups** | **List&lt;int&gt;** |  | [optional] 
**assignChangeUsers** | **List&lt;int&gt;** |  | [optional] 
**assignChangeGroups** | **List&lt;int&gt;** |  | [optional] 
**assignCustomFields** | **List&lt;int&gt;** |  | [optional] 
**assignCustomFieldsValues** | **Object** | Optional values to assign to the custom fields. | [optional] 
**removeAllTags** | **bool** |  | [optional] 
**removeTags** | **List&lt;int&gt;** |  | [optional] 
**removeAllCorrespondents** | **bool** |  | [optional] 
**removeCorrespondents** | **List&lt;int&gt;** |  | [optional] 
**removeAllDocumentTypes** | **bool** |  | [optional] 
**removeDocumentTypes** | **List&lt;int&gt;** |  | [optional] 
**removeAllStoragePaths** | **bool** |  | [optional] 
**removeStoragePaths** | **List&lt;int&gt;** |  | [optional] 
**removeCustomFields** | **List&lt;int&gt;** |  | [optional] 
**removeAllCustomFields** | **bool** |  | [optional] 
**removeAllOwners** | **bool** |  | [optional] 
**removeOwners** | **List&lt;int&gt;** |  | [optional] 
**removeAllPermissions** | **bool** |  | [optional] 
**removeViewUsers** | **List&lt;int&gt;** |  | [optional] 
**removeViewGroups** | **List&lt;int&gt;** |  | [optional] 
**removeChangeUsers** | **List&lt;int&gt;** |  | [optional] 
**removeChangeGroups** | **List&lt;int&gt;** |  | [optional] 
**email** | [**WorkflowActionEmail**](WorkflowActionEmail.md) |  | [optional] 
**webhook** | [**WorkflowActionWebhook**](WorkflowActionWebhook.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


