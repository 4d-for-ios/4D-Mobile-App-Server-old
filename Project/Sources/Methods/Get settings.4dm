//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_OBJECT:C1216($template;$info)
C_TEXT:C284($Txt_methodOnErrorCall)
$template:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file("settings.json")
If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	$Txt_methodOnErrorCall:=Method called on error:C704
	ON ERR CALL:C155("GET ERROR INFO")
	$0:=JSON Parse:C1218($template.getText())
	ON ERR CALL:C155($Txt_methodOnErrorCall)
End if 

If ($0.activation=Null:C1517)
	$0.activation:=New object:C1471
End if 
$info:=WEB Get server info:C1531()
If ($0.activation.scheme=Null:C1517)
	$0.activation.scheme:=Choose:C955($info.security.HTTPSEnabled;"https";"http")
End if 
If ($0.activation.hostname=Null:C1517)
	$0.activation.hostname:=$info.options.webIPAddressToListen[0]
End if 
If ($0.activation.port=Null:C1517)
	$0.activation.port:=String:C10(Choose:C955($info.security.HTTPSEnabled;$info.options.webHTTPSPortID;$info.options.webPortID))
End if 
If ($0.activation.path=Null:C1517)
	$0.activation.path:="4D4IOS"
End if 
If ($0.activation.otherParameters=Null:C1517)
	$0.activation.otherParameters:=""
End if 