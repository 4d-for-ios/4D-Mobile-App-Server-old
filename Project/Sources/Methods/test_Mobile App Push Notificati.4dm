//%attributes = {"invisible":true}
C_OBJECT:C1216($Obj_result;$response)
C_OBJECT:C1216($alert;$notificationOk;$notificationNotOk)
C_COLLECTION:C1488($recipientsOk1;$recipientsOk2;$recipientsNotOk1;$recipientsNotOk2)
C_TEXT:C284($title;$body;$bundleIdOk;$bundleIdNotOk1;$bundleIdNotOk2;$error;$concatErrors)

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


  // ASSERTS
  //________________________________________

  // Correct push notifications

  //$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsOk1)

  //ASSERT($response.success;$response.errors)

  //$response:=Mobile App Push Notification ($notificationOk;$bundleIdOk;$recipientsOk2)

  //ASSERT($response.success;$response.errors)


  //  // Failing push notifications

  //$response:=Mobile App Push Notification($notificationOk;$bundleIdOk)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=1;"Missing error")  // missing parameter


  //$response:=Mobile App Push Notification($notificationNotOk;$bundleIdOk;$recipientsOk1)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=1;"Missing error")  // missing notification title


  //$response:=Mobile App Push Notification($notificationOk;$bundleIdNotOk1;$recipientsOk1)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=1;"Missing error")  // missing bundle Id


  //$response:=Mobile App Push Notification($notificationOk;$bundleIdNotOk2;$recipientsOk1)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=1;"Missing error")  // wrong bundle Id


  //$response:=Mobile App Push Notification($notificationOk;$bundleIdOk;$recipientsNotOk1)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=1;"Missing error")  // couldn't fetch deviceToken from email


  //$response:=Mobile App Push Notification($notificationOk;$bundleIdOk;$recipientsNotOk2)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=2;"Missing error")  // couldn't fetch deviceToken from email, wrong deviceToken


  //$response:=Mobile App Push Notification($notificationOk;$bundleIdNotOk2;$recipientsNotOk1)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=1;"Missing error")  // couldn't fetch deviceToken from email : didn't try to send push notification, so no "wrong bundle Id" error


  //$response:=Mobile App Push Notification($notificationOk;$bundleIdNotOk2;$recipientsNotOk2)

  //ASSERT(Not($response.success);$response.errors)

  //ASSERT($response.errors.count()=2;"Missing error")  // couldn't fetch deviceToken from email, wrong deviceToken : failed to send the push notification, the "wrong bundle Id" error is included is kind of overriden by "wrong deviceToken" error