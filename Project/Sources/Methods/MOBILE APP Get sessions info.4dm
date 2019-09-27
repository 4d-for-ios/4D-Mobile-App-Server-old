//%attributes = {}
  // ----------------------------------------------------
  // Project method : MOBILE APP Get sessions info
  // Database: MOBILE SESSION MANAGEMENT
  // ID[759E8A62FEAA48DA8E9A2B5AC05637F6]
  // Created #6-6-2018 by Vincent de Lachaux
  // ----------------------------------------------------
  // Description:
  // Returns an object containing detailed information on mobile applications
  // & devices sessions
  // ----------------------------------------------------
  // Declarations
C_OBJECT:C1216($0)

C_LONGINT:C283($Lon_app;$Lon_i;$Lon_indx;$Lon_parameters)
C_TEXT:C284($Dir_root)
C_OBJECT:C1216($Obj_application;$Obj_infos)

ARRAY TEXT:C222($tFile_sessions;0)
ARRAY TEXT:C222($tTxt_folders;0)

If (False:C215)
	C_OBJECT:C1216(MOBILE APP Get sessions info ;$0)
End if 

  // ----------------------------------------------------
  // Initialisations
$Lon_parameters:=Count parameters:C259

If (Asserted:C1132($Lon_parameters>=0;"Missing parameter"))
	
	  // NO PARAMETERS REQUIRED
	
	  // Optional parameters
	If ($Lon_parameters>=1)
		
		  // <NONE>
		
	End if 
	
	$Dir_root:=Get 4D folder:C485(MobileApps folder:K5:47;*)
	
	$Obj_infos:=New object:C1471(\
		"apps";New collection:C1472)
	
Else 
	
	ABORT:C156
	
End if 

  // ----------------------------------------------------
If (Test path name:C476($Dir_root)=Is a folder:K24:2)
	
	  // Each folder corresponds to an application
	FOLDER LIST:C473($Dir_root;$tTxt_folders)
	SORT ARRAY:C229($tTxt_folders)
	
	For ($Lon_app;1;Size of array:C274($tTxt_folders);1)
		
		$Obj_application:=New object:C1471(\
			"name";$tTxt_folders{$Lon_app};\
			"id";$tTxt_folders{$Lon_app};\
			"sessions";New collection:C1472)
		
		$tTxt_folders{0}:=$Dir_root+$tTxt_folders{$Lon_app}+Folder separator:K24:12
		
		  // Each file corresponds to a session
		DOCUMENT LIST:C474($tTxt_folders{0};$tFile_sessions;Absolute path:K24:14+Ignore invisible:K24:16)
		
		For ($Lon_i;1;Size of array:C274($tFile_sessions);1)
			
			$Obj_application.sessions.push(JSON Parse:C1218(Document to text:C1236($tFile_sessions{$Lon_i})))
			
		End for 
		
		  // The last session index or -1 if no sessions
		$Lon_indx:=$Obj_application.sessions.length-1
		
		If ($Lon_indx>=0)
			
			  // Get the application name
			If (Length:C16(String:C10($Obj_application.sessions[$Lon_indx].application.name))>0)
				
				$Obj_application.name:=$Obj_application.sessions[$Lon_indx].application.name+" ("+$Obj_application.name+")"
				
			End if 
		End if 
		
		$Obj_infos.apps.push($Obj_application)
		
	End for 
End if 

  // ----------------------------------------------------
  // Return
$0:=$Obj_infos

  // ----------------------------------------------------
  // End