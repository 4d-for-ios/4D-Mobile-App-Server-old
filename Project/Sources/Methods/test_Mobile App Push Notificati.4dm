//%attributes = {"invisible":true}
C_OBJECT:C1216($Obj_result;$response)
C_OBJECT:C1216($alert;$notificationOk;$notificationNotOk;$authOk;$authNotOk1;$authNotOk2)
C_COLLECTION:C1488($recipientsOk1;$recipientsOk2;$recipientsNotOk1;$recipientsNotOk2)
C_TEXT:C284($title;$body;$bundleIdOk;$bundleIdNotOk1;$bundleIdNotOk2;$error;$concatErrors;\
$authKeyOk;$authKeyNotOk;$authKeyIdOk;$authKeyIdNotOk;$teamId)

$notificationOk:=buildNotification ("This is title";"Here is the body of this notification").notification

$title:=""
$body:="Here is the body of this notification"

$alert:=New object:C1471(\
"title";$title;\
"body";$body)

$notificationNotOk:=New object:C1471

$notificationNotOk.aps:=New object:C1471(\
"alert";$alert)


  // BUNDLE ID
  //________________________________________

$bundleIdOk:="com.sample.NotifSampleApp2"
$bundleIdNotOk1:=""
$bundleIdNotOk2:="com.sample.xxxx"


  // RECIPIENTS
  //________________________________________

$recipientsOk1:=New collection:C1472(\
"abc@gmail.com")

$recipientsOk2:=New collection:C1472

$recipientsNotOk1:=New collection:C1472(\
"123@gmail.com")

$recipientsNotOk2:=New collection:C1472(\
"123@gmail.com";\
"def@gmail.com")


  // AUTHENTICATION
  //________________________________________

$authKeyOk:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("AuthKey_4W2QJ2R2WS.p8").platformPath
$authKeyNotOk:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("AuthKey_XXXXX.p8").platformPath
$authKeyIdOk:="4W2QJ2R2WS"
$authKeyIdNotOk:="XXXXX"
$teamId:="UTT7VDX8W5"

$authOk:=New object:C1471(\
"authKey";$authKeyOk;\
"authKeyId";$authKeyIdOk;\
"teamId";$teamId)

$authNotOk1:=New object:C1471(\
"authKey";$authKeyNotOk;\
"authKeyId";$authKeyIdOk;\
"teamId";$teamId)

$authNotOk2:=New object:C1471(\
"authKey";$authKeyOk;\
"authKeyId";$authKeyIdNotOk;\
"teamId";$teamId)


  // ASSERTS
  //________________________________________

  // Correct push notifications

  //$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsOk1;$authOk)

  //ASSERT($response.success;$response.errors)

$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsOk2;$authOk)

ASSERT:C1129($response.success;$response.errors)


  // Failing push notifications

$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsOk1)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // missing parameter


$response:=Mobile App Push Notification ($notificationNotOk;$bundleIdOk;$recipientsOk1;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // missing notification title


$response:=Mobile App Push Notification ($notificationOk;$bundleIdNotOk1;$recipientsOk1;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // missing bundle Id


$response:=Mobile App Push Notification ($notificationOk;$bundleIdNotOk2;$recipientsOk1;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // wrong bundle Id


$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsNotOk1;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // couldn't fetch deviceToken from email


$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsOk1;$authNotOk1)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // unable to load AuthKey file


$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsOk1;$authNotOk2)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=1;"Missing error")  // fails to send notification because of faulty AuthKeyId


$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsNotOk2;$authOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=2;"Missing error")  // couldn't fetch deviceToken from email, fails to send notification because of wrong deviceToken


$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsNotOk1;$authNotOk1)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=2;"Missing error")  // couldn't fetch deviceToken from email, unable to load AuthKey file


$response:=Mobile App Push Notification ($notificationOk;$bundleIdNotOk2;$recipientsNotOk2;$authNotOk2)

ASSERT:C1129(Not:C34($response.success);$response.errors)

ASSERT:C1129($response.errors.count()=2;"Missing error")  // couldn't fetch deviceToken from email, fails to send notification because of : wrong deviceToken, wrong authKeyId, and wrong bundle Id

