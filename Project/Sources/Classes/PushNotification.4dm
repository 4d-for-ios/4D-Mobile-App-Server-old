Class constructor
C_OBJECT:C1216($1;$2;$3)
This:C1470.notification:=$1
This:C1470.recipients:=$2
This:C1470.auth:=$3

If (($1=Null:C1517) | ($2=Null:C1517) | ($3=Null:C1517))
	ASSERT:C1129(False:C215;"Failed to "+Current method name:C684)
	  //$0:=Null
End if 

Function pushNotification
C_OBJECT:C1216($0)
$0:=Mobile App Push Notification (This:C1470.notification;This:C1470.recipients;This:C1470.auth)