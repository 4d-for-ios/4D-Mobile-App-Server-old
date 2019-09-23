//%attributes = {}
C_OBJECT:C1216($0;$1)

C_OBJECT:C1216($request)
C_OBJECT:C1216($notification;$alert)
C_COLLECTION:C1488($recipients)
C_TEXT:C284($bundleId;$title;$subtitle;$body;$url;$imageURL)

$request:=$1  // Informations provided by mobile application

$response:=New object:C1471("success";False:C215)  // Informations returned to mobile application


  // BUILD NOTIFICATION
  //________________________________________

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


  // Or we can delegate the notification building process

  // $notification:=buildNotification("This is title";"Here is the body of this notification").notification


  //$bundleId:="com.sample.xxxx"
$bundleId:="com.sample.NotifSampleApp2"


$recipients:=New collection:C1472(\
"abc@gmail.com";\
"def@gmail.com";\
"ghi@gmail.com")


  // SEND A NOTIFICATION
  //________________________________________

C_OBJECT:C1216($response)

C_OBJECT:C1216($auth)
C_TEXT:C284($authKey;$authKeyId;$teamId)

$authKey:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("AuthKey_4W2QJ2R2WS.p8").platformPath
$authKeyId:="4W2QJ2R2WS"
$teamId:="UTT7VDX8W5"  // Should get it in Session

$auth:=New object:C1471(\
"authKey";$authKey;\
"authKeyId";$authKeyId;\
"teamId";$teamId)

$response:=Mobile App Push Notification ($notification;$bundleId;$recipients;$auth)

  // $response.success True or False
  // $response.errors contains a collection of Text errors
$0:=$response
