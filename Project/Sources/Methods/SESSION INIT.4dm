//%attributes = {"invisible":true}
  //create a share collection accessible from several processes
If (Storage:C1525.sessions=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.sessions:=New shared collection:C1527
	End use 
End if 
  //create an object accessible from the current process
If (parameters=Null:C1517)
	parameters:=Get settings 
End if 