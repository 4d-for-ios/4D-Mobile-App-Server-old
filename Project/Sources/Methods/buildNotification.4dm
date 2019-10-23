//%attributes = {"invisible":true,"preemptive":"capable"}
  //C_OBJECT($0)  // Returned object
  //C_TEXT($1)  // Notification title
  //C_TEXT($2)  // Notification body

  //C_TEXT($title;$body)
  //C_OBJECT($Obj_result;$notification;$alert)


  // PARAMETERS
  //________________________________________

  //C_LONGINT($Lon_parameters)

  //$Lon_parameters:=Count parameters

  //If (Asserted($Lon_parameters>=2;"Missing parameter"))

  //$title:=$1

  //$body:=$2

  //$Obj_result:=New object("success";False)

  //Else   // Missing parameter

  //ABORT

  //End if 

C_TEXT:C284($0)
C_OBJECT:C1216($1)
C_OBJECT:C1216($notification;$alert)

C_BOOLEAN:C305($isAPN)


  // BUILD NOTIFICATION
  //________________________________________

$notification:=New object:C1471

  // Fill title

If (Length:C16(String:C10($1.title))>0)  // Mandatory notification title
	
	$alert:=New object:C1471("title";$1.title)
	
Else 
	
	$alert:=New object:C1471("title";"Empty title")
	
End if 

  // Fill subtitle

If (Length:C16(String:C10($1.subtitle))>0)
	
	$alert.subtitle:=$1.subtitle
	
End if 

  // Fill body

If (Length:C16(String:C10($1.body))>0)
	
	$alert.body:=$1.body
	
End if 


$notification.aps:=New object:C1471("alert";$alert)

  // Fill data

If (Length:C16(String:C10($1.image))>0)
	
	$notification.data:=New object:C1471("media-url";$1.image)
	
End if 

  // Fill url

If (Length:C16(String:C10($1.url))>0)
	
	$notification.aps:=$url
	
End if 




$0:=JSON Stringify:C1217($Obj_notification)