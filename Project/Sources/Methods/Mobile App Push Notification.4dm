//%attributes = {}
C_OBJECT:C1216($1)  // Notification content
C_TEXT:C284($2)  // Bundle Id
C_COLLECTION:C1488($3)  // Recipients email collection
C_OBJECT:C1216($4)  // Authentication object
C_OBJECT:C1216($0)  // Returned object

C_TEXT:C284($cmdAuth;$cmdAuth_in;$cmdAuth_out;$cmdAuth_err)
C_TEXT:C284($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
LOG EVENT:C667(Into 4D debug message:K38:5;$cmdAuth)
LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush)
  //SET ENVIRONMENT VARIABLE("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"true")

C_TEXT:C284($bundleId)
C_COLLECTION:C1488($recipients)
C_OBJECT:C1216($Obj_result;$Obj_notification;$Obj_auth)

$Obj_result:=New object:C1471(\
"success";False:C215)

$Obj_result.errors:=New collection:C1472


  // PARAMETERS
  //________________________________________

$Obj_notification:=$1

$bundleId:=$2

$recipients:=$3

$Obj_auth:=$4


C_TEXT:C284($missingParameter;$missingBundleId;$missingNotificationTitle;$missingAuth)

$missingParameter:="Missing parameter"

$missingBundleId:="Bundle Id can't be empty"

$missingNotificationTitle:="Notification title can't be empty"

$missingAuth:="Incomplete authentication object"

C_BOOLEAN:C305($isMissingParameter;$isMissingBundleId;$isMissingNotificationTitle;$isMissingAuth)

C_LONGINT:C283($Lon_parameters)

$Lon_parameters:=Count parameters:C259

If ($Lon_parameters>=4)
	
	If (Length:C16(String:C10($bundleId))=0)  // Missing bundle Id
		
		logAndAlert ($missingBundleId)
		
		$isMissingBundleId:=True:C214
		
		$Obj_result.errors.push($missingBundleId)
		
	End if 
	
	If (Length:C16(String:C10($Obj_notification.aps.alert.title))=0)  // Missing mandatory notification title
		
		logAndAlert ($missingNotificationTitle)
		
		$isMissingNotificationTitle:=True:C214
		
		$Obj_result.errors.push($missingNotificationTitle)
		
	End if 
	
	If ((Length:C16(String:C10($Obj_auth.authKey))=0) | (Length:C16(String:C10($Obj_auth.authKeyId))=0) | (Length:C16(String:C10($Obj_auth.teamId))=0))  // Incomplete authentication object
		
		logAndAlert ($missingAuth)
		
		$isMissingAuth:=True:C214
		
		$Obj_result.errors.push($missingAuth)
		
	End if 
	
Else   // Missing parameter
	
	logAndAlert ($missingParameter)
	
	$isMissingParameter:=True:C214
	
	$Obj_result.errors.push($missingParameter)
	
End if 

If (Not:C34($isMissingParameter) & Not:C34($isMissingBundleId) & Not:C34($isMissingNotificationTitle) & Not:C34($isMissingAuth))
	
	
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
		
		logAndAlert ($missingMails)
		
		  // Adding missing mail message to the returned object for further treatment
		
		$Obj_result.errors.push($missingMails)
		
	End if 
	
	
	  // AUTHENTICATION FROM SCRIPT
	  //________________________________________
	
	C_TEXT:C284($authScriptPath;$authScriptPathFinalWithArgs)
	
	$authScriptPath:=Folder:C1567(fk resources folder:K87:11).folder("scripts").file("authScriptArgs.sh").platformPath
	
	$authScriptPathFinalWithArgs:=Convert path system to POSIX:C1106($authScriptPath)+" "+\
		Convert path system to POSIX:C1106($Obj_auth.authKey)+" "+\
		$Obj_auth.authKeyId+" "+\
		$Obj_auth.teamId
	
	$cmdAuth:="/bin/sh "+$authScriptPathFinalWithArgs
	
	LAUNCH EXTERNAL PROCESS:C811($cmdAuth;$cmdAuth_in;$cmdAuth_out;$cmdAuth_err)
	
	
	If (Length:C16($cmdAuth_err)=0)  // If script execution failed, $cmdAuth_err contains the error
		
		C_TEXT:C284($jwt)
		$jwt:=$cmdAuth_out  // Contains the JSON Web Token required for authorization header
		
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
		
		logAndAlert ($cmdAuth_err)
		
	End if 
	
	If ($isMissingMails)  // In case every mail given in entry weren't found, return value is not success
		
		$Obj_result.success:=False:C215
		
	End if 
	
	  // Else nothing to do, in error (wrong parameters)
	
End if 


$0:=$Obj_result
