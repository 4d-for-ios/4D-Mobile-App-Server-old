//%attributes = {"invisible":true}
  // Method that logs event received in paramter. If $isDebug is set to True, can also pop up messages in alert windows.
C_TEXT:C284($1)
C_BOOLEAN:C305($isDebug)

$isDebug:=False:C215

LOG EVENT:C667(Into 4D debug message:K38:5;$1)

If ($isDebug)
	
	ALERT:C41($1)
	
	  // Else just keep it in log
	
End if 