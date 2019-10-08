//%attributes = {}
  // Utility method to return the parent dataClass to apply action from `$1` context in `On Mobile App Action` database method.
C_OBJECT:C1216($1)  // Object containing `context.parent.dataClass` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  // Return the parent dataClass corresponding to the action.

If (Value type:C1509($1.context)=Is object:K8:27)
	
	If (Value type:C1509($1.context.parent)=Is object:K8:27)
		
		If (Length:C16(String:C10($1.context.parent.dataClass))>0)  // & $1.context.parent.dataClass#Null (String(Null) is "null")
			
			$0:=ds:C1482[$1.context.parent.dataClass]
			
		End if 
	End if 
End if 