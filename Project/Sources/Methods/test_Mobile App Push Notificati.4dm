//%attributes = {"invisible":true}
C_OBJECT:C1216($Obj_result;$response)
C_OBJECT:C1216($notification)
C_COLLECTION:C1488($recipientsOk1;$recipientsOk2;$recipientsNotOk)
C_TEXT:C284($bundleIdOk;$bundleIdNotOk;$error;$concatErrors)

$notification:=buildNotification ("This is title";"Here is the body of this notification").notification


  // BUNDLE ID
  //________________________________________

$bundleIdOk:="com.sample.NotifSampleApp2"
$bundleIdNotOk:="com.sample.xxxx"


  // RECIPIENTS
  //________________________________________

$recipientsOk1:=New collection:C1472(\
"abc@gmail.com")

$recipientsOk2:=New collection:C1472

$recipientsNotOk:=New collection:C1472(\
"123@gmail.com";\
"def@gmail.com")


  // ASSERTS
  //________________________________________

$response:=Mobile App Push Notification ($notification;$bundleIdOk;$recipientsOk1)

ASSERT:C1129($response.success;$response.errors)


$response:=Mobile App Push Notification ($notification;$bundleIdOk;$recipientsOk2)

ASSERT:C1129($response.success;$response.errors)


$response:=Mobile App Push Notification ($notification;$bundleIdNotOk;$recipientsOk1)

ASSERT:C1129(Not:C34($response.success);$response.errors)


$response:=Mobile App Push Notification ($notification;$bundleIdOk;$recipientsNotOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)


$response:=Mobile App Push Notification ($notification;$bundleIdNotOk;$recipientsNotOk)

ASSERT:C1129(Not:C34($response.success);$response.errors)
