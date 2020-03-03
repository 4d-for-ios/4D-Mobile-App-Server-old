# Push

Utility methods to send push notifications.

## Usage

```4d
$response:=MobileAppServer.PushNotification.new($pushNotification)
```

```4d

  // BUILD NOTIFICATION
  //________________________________________

$notification:=New object
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
$notification.image:="https://media.giphy.com/media/eWW9O2a4IdpWU/giphy.gif"


  // SEND A NOTIFICATION
  //________________________________________

$recipients:=New object
$recipients.recipientMails:=New collection(\
    "abc@gmail.com";\
    "def@gmail.com";\
    "ghi@gmail.com")
$recipients.deviceTokens:=New collection(\
    "fe4efz52zf7ze5ffe4efz52zf7ze5ffe4efz52zf7ze5ffe4efz52zf7ze5f")

$bundleId:="com.sample.myappname"
$authKey:=File("/RESOURCES/scripts/AuthKey_XXXYYY.p8").platformPath
$authKeyId:="AuthKey_XXXYYY"
$teamId:="UTT7VDX8W5"

$auth:=New object(\
"bundleId";$bundleId;\
"authKey";$authKey;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$pushNotification:=New object(\
    "notification";$notification;\
    "recipients";$recipients;\
    "auth";$auth)

$response:=MobileAppServer.PushNotification.new($pushNotification)
// $response.success True or False
// $response.errors contains a collection of Text errors, Success is False
// $response.warnings contains a collection of Text warnings, Success is True or False
```