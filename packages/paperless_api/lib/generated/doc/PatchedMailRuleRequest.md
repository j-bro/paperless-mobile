# paperless_api/generated/lib.model.PatchedMailRuleRequest

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** |  | [optional] 
**account** | **int** |  | [optional] 
**enabled** | **bool** |  | [optional] 
**folder** | **String** | Subfolders must be separated by a delimiter, often a dot ('.') or slash ('/'), but it varies by mail server. | [optional] 
**filterFrom** | **String** |  | [optional] 
**filterTo** | **String** |  | [optional] 
**filterSubject** | **String** |  | [optional] 
**filterBody** | **String** |  | [optional] 
**filterAttachmentFilenameInclude** | **String** | Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive. | [optional] 
**filterAttachmentFilenameExclude** | **String** | Do not consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive. | [optional] 
**maximumAge** | **int** | Specified in days. | [optional] 
**action** | [**MailRuleActionEnum**](MailRuleActionEnum.md) |  | [optional] 
**actionParameter** | **String** |  | [optional] [default to '']
**assignTitleFrom** | [**AssignTitleFromEnum**](AssignTitleFromEnum.md) |  | [optional] 
**assignTags** | **List&lt;int&gt;** |  | [optional] 
**assignCorrespondentFrom** | [**AssignCorrespondentFromEnum**](AssignCorrespondentFromEnum.md) |  | [optional] 
**assignCorrespondent** | **int** |  | [optional] 
**assignDocumentType** | **int** |  | [optional] 
**assignOwnerFromRule** | **bool** |  | [optional] 
**order** | **int** |  | [optional] 
**attachmentType** | [**AttachmentTypeEnum**](AttachmentTypeEnum.md) | Inline attachments include embedded images, so it's best to combine this option with a filename filter.  * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments. | [optional] 
**consumptionScope** | [**ConsumptionScopeEnum**](ConsumptionScopeEnum.md) |  | [optional] 
**pdfLayout** | [**PdfLayoutEnum**](PdfLayoutEnum.md) |  | [optional] 
**owner** | **int** |  | [optional] 
**setPermissions** | [**CorrespondentRequestSetPermissions**](CorrespondentRequestSetPermissions.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


