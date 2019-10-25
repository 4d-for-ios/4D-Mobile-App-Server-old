//%attributes = {"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned object
C_OBJECT:C1216($1)  // Notification content
C_OBJECT:C1216($2)  // Recipients collections
C_OBJECT:C1216($3)  // Authentication object

C_COLLECTION:C1488($recipientMails;$deviceTokens)
C_OBJECT:C1216($Obj_result;$Obj_notification;$Obj_auth;$Obj_authScript_result;$status;$Obj_recipients_result)


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
	
	
	C_BOOLEAN:C305($isMissingRecipients;$isIncompleteAuth;$isAuthScriptFailure)
	
	If (Not:C34($recipientMails.length>0) & (Not:C34($deviceTokens.length>0)))  // Both recipientMails and deviceTokens collections are empty
		
		$isMissingRecipients:=True:C214
		
		$Obj_result.errors.push("Both recipients and deviceTokens collections are empty")
		
	End if 
	
	If ((Length:C16(String:C10($Obj_auth.bundleId))=0)\
		 | (Length:C16(String:C10($Obj_auth.authKey))=0)\
		 | (Length:C16(String:C10($Obj_auth.authKeyId))=0)\
		 | (Length:C16(String:C10($Obj_auth.teamId))=0))  // Incomplete authentication object
		
		$isIncompleteAuth:=True:C214
		
		$Obj_result.errors.push("Incomplete authentication object")
		
	Else 
		  // Get JSON Web Token from authentication script
		$Obj_authScript_result:=authScript ($Obj_auth)
		
		If (Not:C34($Obj_authScript_result.success)\
			 | Not:C34(Length:C16(String:C10($Obj_authScript_result.jwt))>0))  // Script failed (probably because of AuthKey file not found)
			
			$isAuthScriptFailure:=True:C214
			
			$Obj_result.errors.push("Failed to generate JSON Web Token from authentication script")
			
		End if 
		
	End if 
	
Else   // Missing parameter
	
	ABORT:C156
	
End if 


  // PREPARE NOTIFICATION SENDING
  //________________________________________

If (Not:C34($isMissingRecipients) & Not:C34($isIncompleteAuth) & Not:C34($isAuthScriptFailure))
	
	
	  // Build (mails + deviceTokens) collection
	  //________________________________________
	
	C_TEXT:C284($appId)
	
	$appId:=$Obj_auth.teamId+"."+$Obj_auth.bundleId  // In sessions file, apps are identified with <teamId>.<bundleId> 
	
	$Obj_recipients_result:=buildRecipients ($2;$appId)
	
	$Obj_result.warnings:=$Obj_recipients_result.warnings
	
	
	  // BUILD NOTIFICATION
	  //________________________________________
	
	C_TEXT:C284($payload)
	
	$payload:=JSON Stringify:C1217(buildNotification ($Obj_notification))
	
	
	  // SEND NOTIFICATION
	  //________________________________________
	
	C_OBJECT:C1216($mailAndDeviceToken;$notificationInput)
	
	For each ($mailAndDeviceToken;$Obj_recipients_result.recipients)  // Sending a notification for every single deviceToken
		
		$notificationInput:=New object:C1471
		$notificationInput.jwt:=$Obj_authScript_result.jwt
		$notificationInput.bundleId:=$Obj_auth.bundleId
		$notificationInput.payload:=$payload
		$notificationInput.deviceToken:=$mailAndDeviceToken.deviceToken
		$notificationInput.isDevelopment:=True:C214
		
		$status:=apple_sendNotification ($notificationInput)
		
		If ($status.success)  // Notification sent successfully
			
			$Obj_result.success:=True:C214  // At least one notification was sent successfully, other potential failures are pushed in warnings collection
			
		Else 
			  // Adding notfication sending failure message to the returned object for further treatment
			$Obj_result.warnings.push("Failed to send push notification to "+String:C10($mailAndDeviceToken.email))
			
		End if 
		
	End for each 
	
	  // Else : errors occurred, already pushed in $Obj_result.errors
	
End if 


$0:=$Obj_result
