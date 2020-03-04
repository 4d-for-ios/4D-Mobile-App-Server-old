//%attributes = {"invisible":true,"preemptive":"capable"}
C_BOOLEAN:C305($0)  // If input text is a mail address
C_TEXT:C284($1)  // Input text


If ($1=Null:C1517)
	ASSERT:C1129(False:C215;"Missing parameter")
End if 

$0:=Match regex:C1019(".+\\@.+\\..+";$1;1)