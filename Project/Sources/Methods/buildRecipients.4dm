//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output recipients collection and warnings for failures
C_OBJECT:C1216($1)  // input object containing recipients collections
C_TEXT:C284($2)  // input app ID <teamId>.<bundleId>
C_COLLECTION:C1488($recipientMails;$deviceTokens;$mailAndDeviceTokenCollection)
C_OBJECT:C1216($Obj_result)

$Obj_result:=New object:C1471("success";False:C215)


  // Build (mails + deviceTokens) collection
  //________________________________________

$deviceTokens:=$1.deviceTokens
$recipientMails:=$1.recipientMails


$Obj_result.recipients:=New collection:C1472
$Obj_result.warnings:=New collection:C1472

If ($deviceTokens.length>0)
	
	C_TEXT:C284($dt)
	
	For each ($dt;$deviceTokens)
		
		  // For each deviceToken we build an object with mail address information to match session result collection
		
		$Obj_result.recipients.push(New object:C1471(\
			"email";"Unknown mail address";\
			"deviceToken";$dt))
		
	End for each 
	
	  // Else : no deviceTokens given in entry
	
End if 


  // GET SESSIONS INFO
  //________________________________________

If ($recipientMails.length>0)
	
	C_TEXT:C284($mail)
	C_OBJECT:C1216($Obj_session)
	
	For each ($mail;$recipientMails)
		
		$Obj_session:=MOBILE APP Get session info ($2;$mail)
		
		If ($Obj_session.success)
			
			If (Length:C16(String:C10($Obj_session.session.device.token))>0)
				
				$Obj_result.recipients.push(New object:C1471(\
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


$0:=$Obj_result