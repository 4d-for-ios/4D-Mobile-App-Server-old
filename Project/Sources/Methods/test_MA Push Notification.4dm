//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($response)


  // NOTIFICATION
  //________________________________________

C_OBJECT:C1216($notification)

$notification:=New object:C1471
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
$notification.imageUrl:="https://media.giphy.com/media/eWW9O2a4IdpWU/giphy.gif"


  // RECIPIENTS
  //________________________________________

C_COLLECTION:C1488($deviceTokens;$mails)
C_OBJECT:C1216($recipientsOk;$recipientsWithNoMail;$recipientsWithNoDeviceToken;$recipientsEmpty)

$deviceTokens:=New collection:C1472(\
"XXXXXf3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a";\
"YYYYYf3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a")

$mails:=New collection:C1472(\
"abc@gmail.com";\
"def@gmail.com";\
"ghi@gmail.com";\
"123@gmail.com")

$recipientsOk:=New object:C1471
$recipientsOk.recipientMails:=$mails
$recipientsOk.deviceTokens:=$deviceTokens

$recipientsWithNoMail:=New object:C1471
$recipientsWithNoMail.deviceTokens:=$deviceTokens

$recipientsWithNoDeviceToken:=New object:C1471
$recipientsWithNoDeviceToken.recipientMails:=$mails

$recipientsEmpty:=New object:C1471


  // AUTHENTICATION
  //________________________________________

C_TEXT:C284($bundleId;$authKeyOk;$authKeyDoesNotExist;$authKeyId;$teamId)
C_OBJECT:C1216($authOk;$authWithWrongBundleId;$authWithWrongAuthKey;$authOkIncomplete;$authKeyFile)

$bundleId:="com.sample.xxx"

$authKeyFile:=File:C1566("/RESOURCES/scripts/AuthKey_4W2QJ2R2WS.p8")
ASSERT:C1129($authKeyFile.exists;"AuthKey file is required to run tests")
$authKeyOk:=$authKeyFile.platformPath
$authKeyDoesNotExist:=File:C1566("/RESOURCES/scripts/AuthKey_XXXXX.p8").platformPath

$authKeyId:="4W2QJ2R2WS"
$teamId:="UTT7VDX8W5"

$authOk:=New object:C1471(\
"bundleId";$bundleId;\
"authKey";$authKeyOk;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$authWithWrongAuthKey:=New object:C1471(\
"bundleId";$bundleId;\
"authKey";$authKeyDoesNotExist;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$authOkIncomplete:=New object:C1471(\
"bundleId";$bundleId;\
"authKey";$authKeyOk;\
"authKeyId";$authKeyId)


  // ASSERTS
  //________________________________________

C_OBJECT:C1216($pnClass;$pushNotificationArgs)

$pushNotificationArgs:=New object:C1471(\
"notification";$notification;\
"recipients";$recipientsOk;\
"auth";$authOk)

$pnClass:=MobileAppServer .PushNotification.new($pushNotificationArgs)
$response:=$pnClass.pushNotification()
  //$response:=Mobile App Push Notification ($notification;$recipientsOk;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=6;"Problem with warnings count")  // 4x "No session file found" for mail addresses + 2x wrong deviceTokens


$pushNotificationArgs:=New object:C1471(\
"notification";$notification;\
"recipients";$recipientsWithNoDeviceToken;\
"auth";$authOk)

$pnClass:=MobileAppServer .PushNotification.new($pushNotificationArgs)
$response:=$pnClass.pushNotification()
  //$response:=Mobile App Push Notification ($notification;$recipientsWithNoDeviceToken;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=4;"Problem with warnings count")  // 4x "No session file found" for mail addresses


$pushNotificationArgs:=New object:C1471(\
"notification";$notification;\
"recipients";$recipientsWithNoMail;\
"auth";$authOk)

$pnClass:=MobileAppServer .PushNotification.new($pushNotificationArgs)
$response:=$pnClass.pushNotification()
  //$response:=Mobile App Push Notification ($notification;$recipientsWithNoMail;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=2;"Problem with warnings count")  // 2x wrong deviceTokens


$pushNotificationArgs:=New object:C1471(\
"notification";$notification;\
"recipients";$recipientsEmpty;\
"auth";$authOk)

$pnClass:=MobileAppServer .PushNotification.new($pushNotificationArgs)
$response:=$pnClass.pushNotification()
  //$response:=Mobile App Push Notification ($notification;$recipientsEmpty;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Empty recipients collections

ASSERT:C1129($response.warnings.count()=0;"Problem with warnings count")


$pushNotificationArgs:=New object:C1471(\
"notification";$notification;\
"recipients";$recipientsOk;\
"auth";$authOkIncomplete)

$pnClass:=MobileAppServer .PushNotification.new($pushNotificationArgs)
$response:=$pnClass.pushNotification()
  //$response:=Mobile App Push Notification ($notification;$recipientsOk;$authOkIncomplete)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Incomplete auth object

ASSERT:C1129($response.warnings.count()=0;"Problem with warnings count")


$pushNotificationArgs:=New object:C1471(\
"notification";$notification;\
"recipients";$recipientsEmpty;\
"auth";$authOkIncomplete)

$pnClass:=MobileAppServer .PushNotification.new($pushNotificationArgs)
$response:=$pnClass.pushNotification()
  //$response:=Mobile App Push Notification ($notification;$recipientsEmpty;$authOkIncomplete)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=2;"Missing error")  // Empty recipients collections + Incomplete auth object

ASSERT:C1129($response.warnings.count()=0;"Problem with warnings count")


$pushNotificationArgs:=New object:C1471(\
"notification";$notification;\
"recipients";$recipientsOk;\
"auth";$authWithWrongAuthKey)

$pnClass:=MobileAppServer .PushNotification.new($pushNotificationArgs)
$response:=$pnClass.pushNotification()
  //$response:=Mobile App Push Notification ($notification;$recipientsOk;$authWithWrongAuthKey)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Auth script fails because missing AuthKey file

ASSERT:C1129($response.warnings.count()=0;"Problem with warnings count")
