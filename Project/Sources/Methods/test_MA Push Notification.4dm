//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($response)


  // NOTIFICATION
  //________________________________________

C_TEXT:C284($title;$body)
C_OBJECT:C1216($Obj_notificationBuilder;$notificationOk;$alert;$notificationWithNoTitle)

$Obj_notificationBuilder:=buildNotification ("This is title";"Here is the body of this notification")
ASSERT:C1129($Obj_notificationBuilder.success;"error when building notification")
$notificationOk:=$Obj_notificationBuilder.notification

$title:=""
$body:="Here is the body of this notification"

$alert:=New object:C1471(\
"title";$title;\
"body";$body)

$notificationWithNoTitle:=New object:C1471

$notificationWithNoTitle.aps:=New object:C1471(\
"alert";$alert)


  // RECIPIENTS
  //________________________________________

C_COLLECTION:C1488($deviceTokens;$mails)
C_OBJECT:C1216($recipientsOk;$recipientsWithNoMail;$recipientsWithNoDeviceToken;$recipientsEmpty)

$deviceTokens:=New collection:C1472(\
"WRONGDEVICETOKEN")

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

C_TEXT:C284($bundleIdOk;$bundleIdDoesNotExist;$authKeyOk;$authKeyDoesNotExist;$authKeyId;$teamId)
C_OBJECT:C1216($authOk;$authWithWrongBundleId;$authWithWrongAuthKey;$authOkIncomplete;$authKeyFile)

$bundleIdOk:="com.sample.NotifSampleApp2"
$bundleIdDoesNotExist:="xxx"

$authKeyFile:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("AuthKey_4W2QJ2R2WS.p8")
ASSERT:C1129($authKeyFile.exists;"AuthKey file is required to run tests")
$authKeyOk:=$authKeyFile.platformPath
$authKeyDoesNotExist:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("AuthKey_XXXXX.p8").platformPath

$authKeyId:="4W2QJ2R2WS"
$teamId:="UTT7VDX8W5"

$authOk:=New object:C1471(\
"bundleId";$bundleIdOk;\
"authKey";$authKeyOk;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$authWithWrongBundleId:=New object:C1471(\
"bundleId";$bundleIdDoesNotExist;\
"authKey";$authKeyOk;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$authWithWrongAuthKey:=New object:C1471(\
"bundleId";$bundleIdOk;\
"authKey";$authKeyDoesNotExist;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$authOkIncomplete:=New object:C1471(\
"bundleId";$bundleIdOk;\
"authKey";$authKeyOk;\
"authKeyId";$authKeyId)


  // ASSERTS
  //________________________________________


  // SUCCESS TRUE : at least one push notification has been successfully sent


  //$response:=Mobile App Push Notification ($notificationOk;$recipientsOk;$authOk)

  //ASSERT($response.success;$response.errors)

  //ASSERT($response.errors.count()=0;"Unexpected error")

  //ASSERT($response.warnings.count()=4;"Missing warning")  // 2 wrong deviceTokens + 1 missing session + 1 missing deviceToken


  //$response:=Mobile App Push Notification ($notificationOk;$recipientsWithNoDeviceToken;$authOk)

  //ASSERT($response.success;$response.errors)

  //ASSERT($response.errors.count()=0;"Unexpected error")

  //ASSERT($response.warnings.count()=3;"Missing warning")  // 1 wrong deviceToken + 1 missing session + 1 missing deviceToken


  // SUCCESS FALSE : no push notification could be sent


$response:=Mobile App Push Notification ($notificationOk;$recipientsWithNoMail;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=1;"Missing warning")  // 1 wrong deviceToken


$response:=Mobile App Push Notification ($notificationWithNoTitle;$recipientsOk;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Missing notification title

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notificationOk;$recipientsEmpty;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Empty recipients collections

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notificationOk;$recipientsOk;$authOkIncomplete)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Incomplete auth object

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notificationWithNoTitle;$recipientsEmpty;$authOkIncomplete)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=3;"Missing error")  // Missing notification title + Empty recipients collections + Incomplete auth object

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notificationOk;$recipientsOk;$authWithWrongAuthKey)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Auth script fails because missing file

ASSERT:C1129($response.warnings.count()=2;"Unexpected warning")  // 1 missing session + 1 missing deviceToken


$response:=Mobile App Push Notification ($notificationOk;$recipientsOk;$authWithWrongBundleId)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=5;"Missing warning")  // 1 wrong deviceToken / bundle Id : Can't get any deviceToken from session, and notification sending will fail for given deviceToken
