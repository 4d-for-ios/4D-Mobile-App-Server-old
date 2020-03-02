<!-- $auth:=MobileAppServer.Authentication.new($1) // $1 Informations provided by `On Mobile App Authentication` -->
# Authentication

Utility class to get and manipulate session. To use with `On Mobile App Authentication` database method.

## Usage

```4d
$auth:=MobileAppServer.Authentication.new($1) // $1 Informations provided by mobile application

$myAppId:=$auth.getAppId()

$mySessionFile:=$auth.getSessionFile()

$mySessionObject:=$auth.getSessionObject()
$mySessionObject.status:="pending"
$mySessionObject.save()
```
