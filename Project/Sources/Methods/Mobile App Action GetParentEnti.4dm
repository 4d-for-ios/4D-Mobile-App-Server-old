//%attributes = {}
  // Utility method to return the parent entity to apply action from `$1` context in `On Mobile App Action` database method.
C_OBJECT:C1216($1)  // Object containing `context.dataClass`, `context.entity.primaryKey`, `context.parent.primaryKey`, `context.parent.relationName` and `context.parent.dataClass` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  // Return the parent entity corresponding to the action.

C_OBJECT:C1216($Obj_request;$Obj_parent_dataClass;$Obj_entity_in;$Obj_entity_out)

$Obj_request:=$1

$Obj_parent_dataClass:=Mobile App Action GetParentData ($Obj_request)

If ($Obj_parent_dataClass#Null:C1517)
	
	If (Value type:C1509($Obj_request.context.parent)=Is object:K8:27)  // n.b. $Obj_request.context object already checked by previous method
		
		If (Length:C16(String:C10($Obj_request.context.parent.primaryKey))>0)
			
			$Obj_entity_in:=New object:C1471("primaryKey";$Obj_request.context.parent.primaryKey)
			
			$Obj_entity_out:=QueryByPrimaryKey ($Obj_parent_dataClass;$Obj_entity_in)
			
		End if 
	End if 
End if 

$0:=$Obj_entity_out