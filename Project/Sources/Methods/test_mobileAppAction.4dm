//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($input;$action)
C_OBJECT:C1216($entity;$status)
C_OBJECT:C1216($dataclass)

$input:=New object:C1471("context";New object:C1471("dataClass";"Table_1"))
$action:=Mobile App Action ($input)

  // TEST: get dataclass
$dataclass:=$action.getDataClass()
ASSERT:C1129($dataclass#Null:C1517)

If ($dataclass#Null:C1517)
	
	  // clean
	For each ($entity;$dataclass.all())
		$status:=$entity.drop()
	End for each 
	
	  // TEST: create entity
	$entity:=$action.newEntity()
	ASSERT:C1129($entity#Null:C1517)
	
	If ($entity#Null:C1517)
		
		$entity.ID:=1
		$status:=$entity.save()
		ASSERT:C1129($status.success;JSON Stringify:C1217($status))
		
		If ($status.success)
			  // TEST: get entity
			$input.context.entity:=New object:C1471("primaryKey";$entity.ID)
			ASSERT:C1129($action.getEntity().ID=$entity.ID)  // there is no equal for entity....
		End if 
		
		  // Test: get parent
		C_TEXT:C284($parentDataClassName)
		C_OBJECT:C1216($parent;$parentDataClass)
		
		$parentDataClassName:="Table_2"
		$parentDataClass:=ds:C1482[$parentDataClassName]
		For each ($parent;$parentDataClass.all())
			$status:=$parent.drop()
		End for each 
		
		$parent:=$parentDataClass.new()
		$parent.ID:=1
		$parent.save()
		
		$input.context.parent:=New object:C1471("dataClass";"Table_2";"primaryKey";$parent.ID)
		ASSERT:C1129($action.getParent().ID=$parent.ID)  // there is no equal for entity....
		
		
	End if 
End if 
