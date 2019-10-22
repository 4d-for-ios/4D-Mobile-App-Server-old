//%attributes = {"preemptive":"capable"}
C_OBJECT:C1216($0)  // Returned object
C_OBJECT:C1216($1)  // Notification content
C_OBJECT:C1216($2)  // Recipients collections
C_OBJECT:C1216($3)  // Authentication object

C_COLLECTION:C1488($recipientMails;$deviceTokens)
C_OBJECT:C1216($Obj_result;$Obj_notification;$Obj_auth;$Obj_authScript_result;$status)


  // PARAMETERS
  //________________________________________

C_LONGINT:C283($Lon_parameters)

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=3;"Missing parameter"))
	
	$Obj_result:=New object:C1471("success";False:C215)
	$Obj_result.errors:=New collection:C1472
	$Obj_result.warnings:=New collection:C1472
	
	
	$Obj_notification:=$1  // TODO : title, body...
	
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
		
		If (($Obj_authScript_result.success)\
			 & (Length:C16(String:C10($Obj_authScript_result.jwt))>0))
			
			$jwt:=$Obj_authScript_result.jwt
			
		Else 
			  // Script failed (probably because of AuthKey file not found)
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
	
	C_COLLECTION:C1488($mailAndDeviceTokenCollection)
	
	$mailAndDeviceTokenCollection:=New collection:C1472
	
	If ($deviceTokens.length>0)
		
		C_TEXT:C284($dt)
		
		For each ($dt;$deviceTokens)
			
			  // For each deviceToken we build an object with mail address information to match session result collection
			
			$mailAndDeviceTokenCollection.push(New object:C1471(\
				"email";"Unknown mail address";\
				"deviceToken";$dt))
			
		End for each 
		
		  // Else : no deviceTokens given in entry
		
	End if 
	
	
	  // GET SESSIONS INFO
	  //________________________________________
	
	If ($recipientMails.length>0)
		
		C_TEXT:C284($appId;$mail)
		C_OBJECT:C1216($Obj_session)
		
		  // In sessions file, apps are identified with <teamId>.<bundleId> 
		$appId:=$Obj_auth.teamId+"."+$Obj_auth.bundleId
		
		For each ($mail;$recipientMails)
			
			$Obj_session:=MOBILE APP Get session info ($appId;$mail)
			
			If ($Obj_session.success)
				
				If (Length:C16(String:C10($Obj_session.session.device.token))>0)
					
					$mailAndDeviceTokenCollection.push(New object:C1471(\
						"email";$Obj_session.session.email;\
						"deviceToken";$Obj_session.session.device.token))
					
				Else   // No deviceToken found for current session
					
					$Obj_result.warnings.push("We couldn't find related deviceTokens to the following mail addresses : "+$mail)
					
				End if 
				
			Else   // No session found for current mail address 
				
				$Obj_result.warnings.push("No session file was found for the following mail addresses : "+$mail)
				
			End if 
			
		End for each 
		
		  // Else : no recipientMails given in entry
		
	End if 
	
	
	  // BUILD NOTIFICATION
	  //________________________________________
	
	C_TEXT:C284($payload)
	
	$payload:=buildNotification ($Obj_notification)
	
	
	  // SEND NOTIFICATION
	  //________________________________________
	
	C_OBJECT:C1216($mailAndDeviceToken)
	
	For each ($mailAndDeviceToken;$mailAndDeviceTokenCollection)  // Sending a notification for every single deviceToken
		
		C_OBJECT:C1216($notificationInput)
		
		$notificationInput:=New object:C1471
		$notificationInput.jwt:=$Obj_authScript_result.jwt
		$notificationInput.bundleId:=$Obj_auth.bundleId
		$notificationInput.payload:=$payload
		$notificationInput.deviceToken:=$mailAndDeviceToken.deviceToken
		$notificationInput.isDevelopment:=True:C214
		
		$status:=sendNotification ($notificationInput)
		
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
