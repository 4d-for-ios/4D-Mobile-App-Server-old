//%attributes = {}
C_OBJECT:C1216($0)
C_OBJECT:C1216($template)
C_TEXT:C284($Txt_methodOnErrorCall)
$template:=Folder:C1567(fk resources folder:K87:11;*).file("mobileappserversetting.json")
If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	$Txt_methodOnErrorCall:=Method called on error:C704
	ON ERR CALL:C155("getErrorInfo")
	$0:=JSON Parse:C1218($template.getText())
	ON ERR CALL:C155($Txt_methodOnErrorCall)
End if 
