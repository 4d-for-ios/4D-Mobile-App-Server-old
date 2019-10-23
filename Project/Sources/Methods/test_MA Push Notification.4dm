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


$response:=Mobile App Push Notification ($notification;$recipientsOk;$authOk)

ASSERT:C1129($response.success;$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=4;"Missing warning")  // 2 wrong deviceTokens + 1 missing session + 1 missing deviceToken


  //$response:=Mobile App Push Notification ($notification;$recipientsWithNoDeviceToken;$authOk)

  //ASSERT($response.success;$response.errors)

  //ASSERT($response.errors.count()=0;"Unexpected error")

  //ASSERT($response.warnings.count()=3;"Missing warning")  // 1 wrong deviceToken + 1 missing session + 1 missing deviceToken


  // SUCCESS FALSE : no push notification could be sent


$response:=Mobile App Push Notification ($notification;$recipientsWithNoMail;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=1;"Missing warning")  // 1 wrong deviceToken


$response:=Mobile App Push Notification ($notification;$recipientsEmpty;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Empty recipients collections

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notification;$recipientsOk;$authOkIncomplete)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Incomplete auth object

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notification;$recipientsEmpty;$authOkIncomplete)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=2;"Missing error")  // Empty recipients collections + Incomplete auth object

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notification;$recipientsOk;$authWithWrongAuthKey)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // Auth script fails because missing file

ASSERT:C1129($response.warnings.count()=0;"Unexpected warning")


$response:=Mobile App Push Notification ($notification;$recipientsOk;$authWithWrongBundleId)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=0;"Unexpected error")

ASSERT:C1129($response.warnings.count()=5;"Missing warning")  // 1 wrong deviceToken / bundle Id : Can't get any deviceToken from session, and notification sending will fail for given deviceToken
