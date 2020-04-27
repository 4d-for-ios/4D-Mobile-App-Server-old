//%attributes = {"invisible":true,"preemptive":"capable"}
  // Utility method to return the Session file from $1 parameter
C_OBJECT:C1216($0)  // Return object : the Session file corresponding to the session Id given in entry JSON
C_OBJECT:C1216($1)  // Object containing the JSON file data given from mobile app

C_LONGINT:C283($Lon_parameters;$folder_indx;$session_indx)
C_OBJECT:C1216($Dir_mobileApps;$Obj_session;$appFolder;$sessionFile)
C_TEXT:C284($appId_req;$sessionId_req)


  // PARAMETERS
  //________________________________________

$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=1;"Missing parameter"))
	
	$appId_req:=$1.teamId+"."+$1.application.id
	
	$sessionId_req:=String:C10($1.session.id)
	
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18;*)
	
	$Obj_session:=New object:C1471("success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 


If ($Dir_mobileApps.exists)
	
	$appFolder:=$Dir_mobileApps.folder($appId_req)
	
	If ($appFolder.exists)
		
		$sessionFile:=$appFolder.file($sessionId_req)
		
		If ($sessionFile.exists)
			
			$Obj_session.session:=$sessionFile
			
			$Obj_session.success:=True:C214
			
			  // Else : couldn't find given session file
			
		End if 
		
		  // Else : couldn't find given app directory
		
	End if 
	
	  // Else : couldn't find MobileApps directory
	
End if 


$0:=$Obj_session