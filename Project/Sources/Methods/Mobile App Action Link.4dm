//%attributes = {"invisible":true}
  /// # Mobile App Action Link
  //: Utility method to link an entity from `$1` context in `On Mobile App Action` database method.
/*:
## Overview

in `On Mobile App Action`

```4d
Case of 

    : ($1.action="addInCollection")

     $linkEntity:=Mobile App Action Link($1)
     $status:=$linkEntity.save()
````

*/

C_OBJECT:C1216($1)  /// * $1: Object containing `context.entity.relationName` ie. same input as `On Mobile App Action`
C_OBJECT:C1216($0)  /// * $0: Return an object which contains the entity corresponding to the action and success boolean

C_OBJECT:C1216($Obj_request;$Obj_result)

$Obj_request:=$1
$Obj_result:=New object:C1471("success";False:C215)

If (Length:C16(String:C10($Obj_request.context.entity.relationName))>0)
	
	$Obj_result.parent:=MA Action GetParentEntity ($Obj_request)
	
	If ($Obj_result.parent#Null:C1517)
		
		$Obj_result.entity:=Mobile App Action GetEntity ($Obj_request)
		
		If ($Obj_result.entity#Null:C1517)
			
			$Obj_result.entity[$Obj_request.context.entity.relationName]:=$Obj_result.parent
			$Obj_result.success:=True:C214
			$Obj_result.save:=Formula:C1597(This:C1470.entity.save())
			
		End if 
	End if 
End if 

$0:=$Obj_result