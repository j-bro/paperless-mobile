# paperless_api/generated/lib.model.PatchedUserRequest

## Load the model package
```dart
import 'package:paperless_api/generated/lib/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**username** | **String** | Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only. | [optional] 
**email** | **String** |  | [optional] 
**password** | **String** |  | [optional] 
**firstName** | **String** |  | [optional] 
**lastName** | **String** |  | [optional] 
**dateJoined** | [**DateTime**](DateTime.md) |  | [optional] 
**isStaff** | **bool** | Designates whether the user can log into this admin site. | [optional] 
**isActive** | **bool** | Designates whether this user should be treated as active. Unselect this instead of deleting accounts. | [optional] 
**isSuperuser** | **bool** | Designates that this user has all permissions without explicitly assigning them. | [optional] 
**groups** | **List&lt;int&gt;** | The groups this user belongs to. A user will get all permissions granted to each of their groups. | [optional] 
**userPermissions** | **List&lt;String&gt;** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


