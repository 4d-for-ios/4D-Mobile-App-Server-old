//%attributes = {}
C_OBJECT:C1216($0)
C_OBJECT:C1216($template)

$template:=Folder:C1567(fk resources folder:K87:11;*).file("mobileappserversetting.json")
If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	ON ERR CALL:C155("getSettingInfo")
	$0:=JSON Parse:C1218($template.getText())
	ON ERR CALL:C155("")
End if 
