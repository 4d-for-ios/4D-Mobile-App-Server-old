//%attributes = {}
C_OBJECT:C1216($0)  // Returned object
C_OBJECT:C1216($1)  // Notification content
C_OBJECT:C1216($2)  // Recipients collections
C_OBJECT:C1216($3)  // Authentication object

C_TEXT:C284($cmdAuth;$cmdAuth_in;$cmdAuth_out;$cmdAuth_err)
C_TEXT:C284($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
LOG EVENT:C667(Into 4D debug message:K38:5;$cmdAuth)
LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush)

C_COLLECTION:C1488($recipientMails;$deviceTokens)
C_OBJECT:C1216($Obj_result;$Obj_notification;$Obj_auth)


  // PARAMETERS
  //________________________________________

C_LONGINT:C283($Lon_parameters)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	$Obj_result:=New object:C1471("success";False:C215)
	$Obj_result.errors:=New collection:C1472
	$Obj_result.warnings:=New collection:C1472
	
	
	$Obj_notification:=$1
	
	$deviceTokens:=$2.deviceTokens
	$recipientMails:=$2.recipientMails
	
	$Obj_auth:=$3
	
	
	C_TEXT:C284($missingRecipients;$missingNotificationTitle;$incompleteAuth)
	C_BOOLEAN:C305($isMissingRecipients;$isMissingNotificationTitle;$isIncompleteAuth)
	
	If (Not:C34($recipientMails.length>0) & (Not:C34($deviceTokens.length>0)))  // Both recipientMails and deviceTokens collections are empty
		
		$missingRecipients:="Both recipients and deviceTokens collections are empty"
		
		logAndAlert ($missingRecipients)
		
		$isMissingRecipients:=True:C214
		
		$Obj_result.errors.push($missingRecipients)
		
	End if 
	
	If (Length:C16(String:C10($Obj_notification.aps.alert.title))=0)  // Missing mandatory notification title
		
		$missingNotificationTitle:="Notification title can't be empty"
		
		logAndAlert ($missingNotificationTitle)
		
		$isMissingNotificationTitle:=True:C214
		
		$Obj_result.errors.push($missingNotificationTitle)
		
	End if 
	
	If ((Length:C16(String:C10($Obj_auth.bundleId))=0)\
		 | (Length:C16(String:C10($Obj_auth.authKey))=0)\
		 | (Length:C16(String:C10($Obj_auth.authKeyId))=0)\
		 | (Length:C16(String:C10($Obj_auth.teamId))=0))  // Incomplete authentication object
		
		$incompleteAuth:="Incomplete authentication object"
		
		logAndAlert ($incompleteAuth)
		
		$isIncompleteAuth:=True:C214
		
		$Obj_result.errors.push($incompleteAuth)
		
	End if 
	
Else   // Missing parameter
	
	ABORT:C156
	
End if 


  // Build mails + deviceTokens collection
  //________________________________________

C_COLLECTION:C1488($mailAndDeviceTokenCollection)

$mailAndDeviceTokenCollection:=New collection:C1472

If ($deviceTokens.length>0)
	
	C_TEXT:C284($dt)
	
	For each ($dt;$deviceTokens)
		
		  // For each deviceToken we build an object with mail address information to match session results
		
		$mailAndDeviceTokenCollection.push(New object:C1471(\
			"email";"Unknown mail address";\
			"deviceToken";$dt))
		
	End for each 
	
	  // Else : no deviceTokens given in entry
	
End if 


  // GET SESSIONS INFO
  //________________________________________

C_BOOLEAN:C305($isNoSessionFound;$isMissingDeviceTokenFromSession)

If ($recipientMails.length>0)
	
	C_TEXT:C284($appId;$mail;$noSessionFound)
	C_OBJECT:C1216($Obj_session)
	
	$noSessionFound:="No session file was found for the following mail addresses : \n"
	
	  // In sessions file, apps are identified with <teamId>.<bundleId> 
	$appId:=$Obj_auth.teamId+"."+$Obj_auth.bundleId
	
	For each ($mail;$recipientMails)
		
		$Obj_session:=MOBILE APP Get session info ($appId;$mail)
		
		If ($Obj_session.success)
			
			C_TEXT:C284($missingDeviceTokenFromSession)
			
			$missingDeviceTokenFromSession:="We couldn't find related deviceTokens to the following mail addresses : \n"
			
			If (Length:C16(String:C10($Obj_session.session.deviceToken))>0)
				
				$mailAndDeviceTokenCollection.push(New object:C1471(\
					"email";$Obj_session.session.email;\
					"deviceToken";$Obj_session.session.deviceToken))
				
			Else   // No deviceToken found for current session
				
				$missingDeviceTokenFromSession:=$missingDeviceTokenFromSession+$mail+"\n"
				
				$isMissingDeviceTokenFromSession:=True:C214
				
			End if 
			
		Else   // No session found for current mail address 
			
			$noSessionFound:=$noSessionFound+$mail+"\n"
			
			$isNoSessionFound:=True:C214
			
		End if 
		
	End for each 
	
	If ($isMissingDeviceTokenFromSession)
		
		logAndAlert ($missingDeviceTokenFromSession)
		
		  // Adding missing mail message to the returned object for further treatment
		
		$Obj_result.warnings.push($missingDeviceTokenFromSession)
		
	End if 
	
	If ($isNoSessionFound)
		
		logAndAlert ($noSessionFound)
		
		  // Adding missing session message to the returned object for further treatment
		
		$Obj_result.warnings.push($noSessionFound)
		
	End if 
	
	  // Else : no recipientMails given in entry
	
End if 


If (Not:C34($isMissingRecipients) & Not:C34($isMissingNotificationTitle) & Not:C34($isIncompleteAuth))
	
	
	  // NOTIFICATION
	  //________________________________________
	
	C_TEXT:C284($payload)
	
	$payload:=JSON Stringify:C1217($Obj_notification)
	
	
	  // ENDPOINT
	  //________________________________________
	
	C_TEXT:C284($endpoint)
	
	$endpoint:="https://api.sandbox.push.apple.com"
	  //$endpoint:="https://api.development.push.apple.com"
	
	
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
		
		C_OBJECT:C1216($mailAndDeviceToken)
		
		For each ($mailAndDeviceToken;$mailAndDeviceTokenCollection)  // Sending a notification for every single deviceToken
			
			$cmdPush:="curl --verbose "+\
				"--header \"content-type: application/json\" "+\
				"--header \"authorization: bearer "+$jwt+"\" "+\
				"--header \"apns-topic: "+$Obj_auth.bundleId+"\" "+\
				"--data '"+$payload+"' "+\
				""+$endpoint+"/3/device/"+$mailAndDeviceToken.deviceToken
			
			LAUNCH EXTERNAL PROCESS:C811($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
			
			If (Length:C16($cmdPush_err)>0)
				
				LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush_err)
				
			End if 
			
			
			If (Length:C16($cmdPush_out)>0)  // If notification sending failed, $cmdPush_out contains the error
				
				LOG EVENT:C667(Into 4D debug message:K38:5;$cmdPush_out)
				
				  // Adding notfication sending failure message to the returned object for further treatment
				$Obj_result.warnings.push("Failed to send push notification to "+String:C10($mailAndDeviceToken.email))
				
			Else   // notification sent successfully
				
				$Obj_result.success:=True:C214  // At least one notification was sent successfully, other potential failures are pushed in warnings collection
				
			End if 
			
		End for each 
		
		
	Else   // Script failed (probably because of AuthKey file not found
		
		LOG EVENT:C667(Into 4D debug message:K38:5;$cmdAuth_err)
		
		logAndAlert ($cmdAuth_err)
		
		$Obj_result.errors.push($cmdAuth_err)
		
	End if 
	
	  // Else : errors occured, already pushed in $Obj_result.errors
	
End if 


$0:=$Obj_result
