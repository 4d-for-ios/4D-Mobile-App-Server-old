//%attributes = {}
C_OBJECT:C1216($1)  // notification content
C_TEXT:C284($2)  // bundle id
C_COLLECTION:C1488($3)  // recipients email collection
C_OBJECT:C1216($0)

C_TEXT:C284($bundleId)
C_COLLECTION:C1488($recipients)
C_OBJECT:C1216($Obj_result;$Obj_notification)
$Obj_result:=New object:C1471("success";False:C215)

  //$0 .success Bool , errors ...

$Obj_notification:=$1
$bundleId:=$2
$recipients:=$3


C_LONGINT:C283($Lon_parameters)
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
	If (Length:C16(String:C10($bundleId))=0)
		ALERT:C41("BundleID can't be empty")
		ABORT:C156
	End if 
	
	If (Length:C16(String:C10($Obj_notification.aps.alert.title))=0)
		ALERT:C41("Notification title can't be empty")
		ABORT:C156
	End if 
	
Else 
	
	ABORT:C156
	
End if 

  // notification

$payload:=JSON Stringify:C1217($Obj_notification)

  // endpoint

C_TEXT:C284($endpoint)
$endpoint:="https://api.sandbox.push.apple.com"
  //$endpoint:="https://api.development.push.apple.com"



  // device tokens

C_TEXT:C284($response)
$httpStatus_l:=HTTP Request:C1158(HTTP GET method:K71:1;"http://localhost/4DAction/deviceToken";$recipients;$response)

C_COLLECTION:C1488($deviceTokens)
$deviceTokens:=JSON Parse:C1218($response)


  // Get authentication from script

C_TEXT:C284($authScriptPath;$authScriptPathFinal)
$authScriptPath:=Get 4D folder:C485(Current resources folder:K5:16)+"scripts"+Folder separator:K24:12+"authScript.sh"
$authScriptPathFinal:=Convert path system to POSIX:C1106($authScriptPath)

C_TEXT:C284($cmd;$cmd_in;$cmd_out;$cmd_err)
$cmd:="/bin/sh "+$authScriptPathFinal

LOG EVENT:C667(Into 4D debug message:K38:5;$cmd)
  //SET ENVIRONMENT VARIABLE("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"true")
LAUNCH EXTERNAL PROCESS:C811($cmd;$cmd_in;$cmd_out;$cmd_err)

$jwt:=$cmd_out

If (Length:C16($cmd_err)=0)
	
	For each ($deviceToken;$deviceTokens)
		
		$cmd:="curl --verbose "+\
			"--header \"content-type: application/json\" "+\
			"--header \"authorization: bearer "+$jwt+"\" "+\
			"--header \"apns-topic: "+$bundleId+"\" "+\
			"--data '"+$payload+"' "+\
			""+$endpoint+"/3/device/"+$deviceToken
		
		LAUNCH EXTERNAL PROCESS:C811($cmd;$cmd_in;$cmd_out;$cmd_err)
		
		  // CHECK SUCCESS OR NOT, RETURN SUCCESS OR NOT
		
		If (Length:C16($cmd_out)>0)
			LOG EVENT:C667(Into 4D debug message:K38:5;$cmd_out)
		End if 
		
		If (Length:C16($cmd_err)>0)
			LOG EVENT:C667(Into 4D debug message:K38:5;$cmd_err)
		End if 
		
	End for each 
	
Else 
	
	LOG EVENT:C667(Into 4D debug message:K38:5;$cmd_err)
	ALERT:C41($cmd_err)
	$0:=$Obj_result
End if 