//%attributes = {"invisible":true,"shared":true}
C_BOOLEAN:C305($0)
C_TEXT:C284($1)
SESSION INIT 
Case of 
	: (Position:C15(parameters.activation.prefix;$1)=2)
		Mobile App Active Session ($1)
		$0:=True:C214
End case 