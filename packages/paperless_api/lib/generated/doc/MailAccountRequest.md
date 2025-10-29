# paperless_api/generated/lib.model.MailAccountRequest

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** |  | 
**imapServer** | **String** |  | 
**imapPort** | **int** | This is usually 143 for unencrypted and STARTTLS connections, and 993 for SSL connections. | [optional] 
**imapSecurity** | [**ImapSecurityEnum**](ImapSecurityEnum.md) |  | [optional] 
**username** | **String** |  | 
**password** | **String** |  | 
**characterSet** | **String** | The character set to use when communicating with the mail server, such as 'UTF-8' or 'US-ASCII'. | [optional] 
**isToken** | **bool** |  | [optional] 
**owner** | **int** |  | [optional] 
**setPermissions** | [**CorrespondentRequestSetPermissions**](CorrespondentRequestSetPermissions.md) |  | [optional] 
**accountType** | [**AccountTypeEnum**](AccountTypeEnum.md) |  | [optional] 
**expiration** | [**DateTime**](DateTime.md) | The expiration date of the refresh token.  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


