//%attributes = {}
C_OBJECT:C1216($0)  // Returned object
C_TEXT:C284($1)  // teamId.bundleId
C_TEXT:C284($2)  // mail address

C_TEXT:C284($appId;$mail)

C_LONGINT:C283($Lon_parameters;$folder_indx;$session_indx)
C_OBJECT:C1216($Dir_mobileApps;$Obj_session;$appFolder;$sessionFile;$session)
C_TEXT:C284($sessionFilePath)

ARRAY TEXT:C222($sessionFilesList;0)
ARRAY TEXT:C222($appFoldersList;0)


  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=2;"Missing parameter"))
	
	  // Required parameters
	$appId:=$1
	
	$mail:=$2
	
	$Dir_mobileApps:=Folder:C1567(fk mobileApps folder:K87:18)
	
	$Obj_session:=New object:C1471("success";False:C215)
	
Else 
	
	ABORT:C156
	
End if 


  // ----------------------------------------------------
If ($Dir_mobileApps.exists)
	
	  // Each folder corresponds to an application
	FOLDER LIST:C473($Dir_mobileApps.platformPath;$appFoldersList)
	
	$folder_indx:=Find in array:C230($appFoldersList;$appId)
	
	If ($folder_indx>0)
		
		$appFolder:=$Dir_mobileApps.folder($appFoldersList{$folder_indx})
		
		If ($appFolder.exists)
			
			  // Each file corresponds to a session
			DOCUMENT LIST:C474($appFolder.platformPath;$sessionFilesList)
			
			For ($session_indx;1;Size of array:C274($sessionFilesList);1)
				
				$sessionFile:=$appFolder.file($sessionFilesList{$session_indx})
				
				$session:=JSON Parse:C1218($sessionFile.getText())
				
				If ($session.email=$mail)
					  //If ($mails.indexOf($session.email)>-1)
					
					$Obj_session.session:=$session
					
					$Obj_session.success:=True:C214  // Success True if at least one recipient was found
					
				End if 
				
			End for 
			
			  // Else : application directory doesn't exist
			
		End if 
		
		  // Else : couldn't find application directory
		
	End if 
	
	  // Else : couldn't find MobileApps folder
	
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_session

  // ----------------------------------------------------
  // End