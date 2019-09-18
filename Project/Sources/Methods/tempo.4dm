//%attributes = {}
$request:=$1  // Informations provided by mobile application
$response:=New object:C1471("success";False:C215)  // Informations returned to mobile application

C_OBJECT:C1216($notification;$alert)
C_COLLECTION:C1488($recipients)
C_TEXT:C284($bundleId;$title;$subtitle;$body;$url;$imageURL)

  // Everything supposedly received in $request:=$1

  // BUILD NOTIFICATION

$title:="This is title"
$subtitle:="This is subtitle"
$body:="Here is the body of this notification"
$url:=""
$imageURL:=""

$alert:=New object:C1471(\
"title";$title;\
"subtitle";$subtitle;\
"body";$body)

$notification:=New object:C1471
$notification.aps:=New object:C1471(\
"alert";$alert;\
"badge";2;\
"sound";"default";\
"mutable-content";1;\
"category";"ACTIONS")
$notification.custom:=New object:C1471(\
"mykey";"myvalue")

If (Length:C16(String:C10($url))>0)
	$notification.aps.url:=$url
End if 
If (Length:C16(String:C10($imageURL))>0)
	$notification.data:=New object:C1471("media-url";$imageURL)
End if 




$bundleId:="com.sample.xxxx"

$recipients:=New collection:C1472(\
"abc@gmail.com";\
"def@gmail.com";\
"ghi@gmail.com")

$success:=Mobile App Push Notification ($notification;$bundleId;$recipients)
  //$success:=Mobile App Push Notification ($notification;"";$recipients)


  // TODO UNIT TEST AVEC PARAM FOIREUX
  // TODO SUCCESS ?