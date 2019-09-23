//%attributes = {}
C_TEXT:C284($1)
C_BOOLEAN:C305($isDebug)

$isDebug:=True:C214

LOG EVENT:C667(Into 4D debug message:K38:5;$1)

If ($isDebug)
	
	ALERT:C41($1)
	
	  // Else just keep it in log
	
End if 