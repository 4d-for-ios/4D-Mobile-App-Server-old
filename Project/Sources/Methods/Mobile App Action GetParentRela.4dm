//%attributes = {}
  // Utility method to return the parent relationName to apply action from `$1` context in `On Mobile App Action` database method.
C_OBJECT:C1216($1)  // Object containing `context.parent.relationName` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  // Return the parent relationName corresponding to the action.

If (Value type:C1509($1.context)=Is object:K8:27)
	
	If (Value type:C1509($1.context.parent)=Is object:K8:27)
		
		If (Length:C16(String:C10($1.context.parent.relationName))>0)  // & $1.context.parent.relationName#Null (String(Null) is "null")
			
			$0:=$1.context.parent.relationName
			
		End if 
	End if 
End if 