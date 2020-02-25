  // Wrapper `On Mobile App Authentication` input 
Class constructor
C_OBJECT:C1216($1)
This:C1470.request:=$1
This:C1470.class:=cs:C1710[Split string:C1554(Current method name:C684;" ")[0]]
If ($1=Null:C1517)
	ASSERT:C1129(False:C215;"Failed to "+Current method name:C684)
	  //$0:=Null
End if 
/*Use (This.class)
If (This.class.folder=Null)
This.class.folder:=Folder(fk mobileApps folder)
End if 
End use*/

Function getAppID
C_TEXT:C284($0)
$0:=This:C1470.request.team.id+"."+This:C1470.request.application.id

Function getSessionFile
C_OBJECT:C1216($0)
$0:=Folder:C1567(fk mobileApps folder:K87:18).folder(This:C1470.getAppID()).file(This:C1470.request.session.id)
  //$0:=This.class.folder.folder(This.getAppID()).file(This.request.session.id)

Function getSessionObject
C_OBJECT:C1216($0)
$0:=Mobile App Session Object (This:C1470.getSessionFile())  // XXX maybe create a class also
