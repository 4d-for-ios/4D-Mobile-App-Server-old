Class constructor
C_OBJECT:C1216($1)

If ($1=Null:C1517)
	ASSERT:C1129(False:C215;"Failed to "+Current method name:C684)
	  //$0:=Null
End if 

If ((Length:C16(String:C10($1.bundleId))=0)\
 | (Length:C16(String:C10($1.authKey))=0)\
 | (Length:C16(String:C10($1.authKeyId))=0)\
 | (Length:C16(String:C10($1.teamId))=0))  // Incomplete authentication object
	
	ASSERT:C1129(False:C215;"Incomplete authentication object")
	
Else 
	
	C_OBJECT:C1216($Obj_authScript_result)
	  // Get JSON Web Token from authentication script
	$Obj_authScript_result:=authScript ($1)
	
	If (Not:C34($Obj_authScript_result.success)\
		 | Not:C34(Length:C16(String:C10($Obj_authScript_result.jwt))>0))  // Script failed (probably because of AuthKey file not found)
		
		ASSERT:C1129(False:C215;"Failed to generate JSON Web Token from authentication script")
		
	Else 
		
		This:C1470.auth:=$1
		This:C1470.auth.jwt:=$Obj_authScript_result.jwt
		
	End if 
	
End if 



Function send()
C_OBJECT:C1216($0)
C_OBJECT:C1216($1)  // Notification content
C_VARIANT:C1683($2)  // Recipients

If (This:C1470.auth=Null:C1517)
	ASSERT:C1129(False:C215;"Class initialization failed")
	ABORT:C156
End if 

Case of 
		
	: (Count parameters:C259>1)
		
		$0:=Mobile App Push Notification ($1;manageEntryRecipient ($2);This:C1470.auth)
		
	: (This:C1470.recipients#Null:C1517)
		
		$0:=Mobile App Push Notification ($1;manageEntryRecipient (This:C1470.recipients);This:C1470.auth)
		
	Else 
		
		$0.success:=False:C215
		$0.errors:=New collection:C1472
		$0.warnings:=New collection:C1472
		$0.errors.push("No recipient given")
		
End case 