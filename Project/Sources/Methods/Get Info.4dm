//%attributes = {}
C_OBJECT:C1216($0)
C_OBJECT:C1216($template)

$template:=Folder:C1567(fk resources folder:K87:11;*).file("setting.json")
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** Method : GET Info $template : "+JSON Stringify:C1217($template))
If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	
	$0:=JSON Parse:C1218($template.getText())
	
End if 
