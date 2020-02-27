<!-- $auth:=MobileAppServer.Authentication($1) // $1 Informations provided by  `On Mobile App Authentication` -->
# Authentication

## Description

Utility class to get manipulate session when inside `On Mobile App Authentication` database method.

```4d
    // Create an object with formula
$auth:=MobileAppServer.Authentication($1) // $1 Informations provided by mobile application

$myAppId:=$auth.getAppId()

$mySessionFile:=$auth.getSessionFile()

$mySessionObject:=$auth.getSessionObject()
$mySessionObject.status:="pending"
$mySessionObject.save()
```
