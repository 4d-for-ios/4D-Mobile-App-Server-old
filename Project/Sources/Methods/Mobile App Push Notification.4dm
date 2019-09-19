//%attributes = {}
C_OBJECT:C1216($1)  // notification content
C_TEXT:C284($2)  // bundle Id
C_COLLECTION:C1488($3)  // recipients email collection
C_OBJECT:C1216($0)  // returned object

C_TEXT:C284($cmdAuth;$cmdAuth_in;$cmdAuth_out;$cmdAuth_err)
C_TEXT:C284($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
LOG EVENT:C667(Into 4D debug message:K38:5;$cmdAuth)
LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush)
  //SET ENVIRONMENT VARIABLE("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"true")

C_TEXT:C284($bundleId)
C_COLLECTION:C1488($recipients)
C_OBJECT:C1216($Obj_result;$Obj_notification)

$Obj_result:=New object:C1471("success";False:C215)


  // PARAMETERS
  //________________________________________

$Obj_notification:=$1

$bundleId:=$2

$recipients:=$3


C_LONGINT:C283($Lon_parameters)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	$Obj_result:=New object:C1471(\
		"success";False:C215)
	
	$Obj_result.errors:=New collection:C1472
	
	If (Length:C16(String:C10($bundleId))=0)  // Missing bundle Id
		
		ALERT:C41("Bundle Id can't be empty")
		
		ABORT:C156
		
	End if 
	
	If (Length:C16(String:C10($Obj_notification.aps.alert.title))=0)  // Missing mandatory notification title
		
		ALERT:C41("Notification title can't be empty")
		
		ABORT:C156
		
	End if 
	
Else   // Missing parameter
	
	ABORT:C156
	
End if 


  // NOTIFICATION
  //________________________________________

C_TEXT:C284($payload)

$payload:=JSON Stringify:C1217($Obj_notification)


  // ENDPOINT
  //________________________________________

C_TEXT:C284($endpoint)

$endpoint:="https://api.sandbox.push.apple.com"
  //$endpoint:="https://api.development.push.apple.com"


  // DEVICE TOKENS
  //________________________________________

C_TEXT:C284($response)

C_LONGINT:C283($httpStatus)

  // Call to deviceToken to fetch the deviceTokens of the recipient list provided
$httpStatus:=HTTP Request:C1158(HTTP GET method:K71:1;"http://localhost/4DAction/deviceToken";$recipients;$response)


C_COLLECTION:C1488($deviceTokens)

$deviceTokens:=JSON Parse:C1218($response)


  // Checks if we found a deviceToken for every mail given in entry
C_TEXT:C284($missingMails)

C_BOOLEAN:C305($mailFound;$isMissingMails)

C_TEXT:C284($mailInput)
C_OBJECT:C1216($deviceToken)

$isMissingMails:=False:C215

$missingMails:="We couldn't find related deviceTokens to the following mail addresses : \n"

For each ($mailInput;$recipients)
	
	$mailFound:=False:C215
	
	For each ($deviceToken;$deviceTokens)
		
		If ($deviceToken.email=$mailInput)
			
			$mailFound:=True:C214
			
		End if 
		
	End for each 
	
	If ($mailFound=False:C215)
		
		  // Adding missing mail to the list, to inform user
		
		$missingMails:=$missingMails+$mailInput+"\n"
		
		$isMissingMails:=True:C214
		
	End if 
	
End for each 

If ($isMissingMails)
	
	ALERT:C41($missingMails)
	
	  // Adding missing mail message to the returned object for further treatment
	$Obj_result.errors.push($missingMails)
	
End if 


  // AUTHENTICATION FROM SCRIPT
  //________________________________________

C_TEXT:C284($authScriptPath;$authScriptPathFinal)

$authScriptPath:=Get 4D folder:C485(Current resources folder:K5:16)+"scripts"+Folder separator:K24:12+"authScript.sh"

$authScriptPathFinal:=Convert path system to POSIX:C1106($authScriptPath)

$cmdAuth:="/bin/sh "+$authScriptPathFinal

LAUNCH EXTERNAL PROCESS:C811($cmdAuth;$cmdAuth_in;$cmdAuth_out;$cmdAuth_err)

C_TEXT:C284($jwt)
$jwt:=$cmdAuth_out  // Contains the JSON Web Token required for authorization header


If (Length:C16($cmdAuth_err)=0)  // If script execution failed, $cmdAuth_err contains the error
	
	$Obj_result.success:=True:C214  // So far, everything went well
	
	For each ($deviceToken;$deviceTokens)  // Sending a notification for every single deviceToken
		
		$cmdPush:="curl --verbose "+\
			"--header \"content-type: application/json\" "+\
			"--header \"authorization: bearer "+$jwt+"\" "+\
			"--header \"apns-topic: "+$bundleId+"\" "+\
			"--data '"+$payload+"' "+\
			""+$endpoint+"/3/device/"+$deviceToken.deviceToken
		
		LAUNCH EXTERNAL PROCESS:C811($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
		
		If (Length:C16($cmdPush_err)>0)
			
			LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush_err)
			
		End if 
		
		
		If (Length:C16($cmdPush_out)>0)  // If notification sending failed, $cmdPush_out contains the error
			
			LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush_out)
			
			  // Adding notfication sending failure message to the returned object for further treatment
			$Obj_result.errors.push("Failed to send push notification to "+$deviceToken.email)
			
			$Obj_result.success:=False:C215
			
		End if 
		
	End for each 
	
	
Else   // Script failed (probably because of AuthKey file not found
	
	LOG EVENT:C667(Into 4D debug message:K38:5;$cmdAuth_err)
	
	ALERT:C41($cmdAuth_err)
	
End if 

If ($isMissingMails)  // In case every mail given in entry weren't found, return value is not success
	
	$Obj_result.success:=False:C215
	
End if 


$0:=$Obj_result
