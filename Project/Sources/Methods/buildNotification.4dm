//%attributes = {}
C_TEXT:C284($1)  // Notification title
C_TEXT:C284($2)  // Notification body
C_OBJECT:C1216($0)  // Returned object

C_TEXT:C284($title;$body)
C_OBJECT:C1216($Obj_result;$notification;$alert)


  // PARAMETERS
  //________________________________________

$title:=$1

$body:=$2


C_LONGINT:C283($Lon_parameters)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
	$Obj_result.notification:=New object:C1471
	
	If (Length:C16(String:C10($title))=0)  // Missing mandatory notification title
		
		ALERT:C41("Notification title can't be empty")
		
		ABORT:C156
		
	End if 
	
Else   // Missing parameter
	
	ABORT:C156
	
End if 


  // BUILD NOTIFICATION
  //________________________________________

$alert:=New object:C1471(\
"title";$title;\
"body";$body)

$notification:=New object:C1471

$notification.aps:=New object:C1471(\
"alert";$alert)

$Obj_result.success:=True:C214
$Obj_result.notification:=$notification

$0:=$Obj_result