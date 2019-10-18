[![pipeline status](https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/badges/master/pipeline.svg)](https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/commits/master)

# 4D Mobile App Server

Utility methods to improve the 4D Mobile App backend coding.

##  Contents ##
- [Action](#Action)
- [Push](#Push)

# Action ##

Utility methods to get dataClass or entity to apply action when inside `On Mobile App Action` database method.

```swift
$request:=$1  // Informations provided by mobile application
$response:=New object("success";False)  // Informations returned to mobile application

Case of
      //________________________________________
    : ($request.action="rate") // Rate a book, action scope is entity

      $book:=Mobile App Action GetEntity ($request)
      // Insert here the code for the action "Rate and Review" the book

      //________________________________________
    : ($request.action="purgeAll") // Purge all, action scope is table/dataclass

      $dataClass:=Mobile App Action GetDataClass($request)
      // Insert here the code to purge all entities of this dataClass.

End case

$0:=response
```

# Push ##

Utility methods to send push notifications.

```swift

  // BUILD NOTIFICATION
  //________________________________________

$notification:=buildNotification("Hello, this is title";"And this is my body").notification


  // SEND A NOTIFICATION
  //________________________________________

$recipients:=New object
$recipients.recipientMails:=New collection(\
    "abc@gmail.com";\
    "def@gmail.com";\
    "ghi@gmail.com")
$recipients.deviceTokens:=New collection(\
    "fe4efz52zf7ze5f")

$bundleId:="com.sample.myappname"
$authKey:=Folder(fk resources folder).folder("scripts").file("AuthKey_XXX.p8").platformPath
$authKeyId:="XXX"
$teamId:="UTT7VDX8W5"

$auth:=New object(\
"bundleId";$bundleId;\
"authKey";$authKey;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$0:=Mobile App Push Notification ($notification;$recipients;$auth)
```

# Contributing #
See [CONTRIBUTING.md](CONTRIBUTING.md)