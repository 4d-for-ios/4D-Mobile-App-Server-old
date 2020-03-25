/*

Utility methods for development stage

*/

Class constructor
	
	This:C1470.deletedRecordsTable:=New object:C1471(\
		"name";"__DeletedRecords";\
		"fields";New collection:C1472)
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"ID";\
		"type";"INT64";\
		"indexed";True:C214;\
		"primaryKey";True:C214;\
		"autoincrement";True:C214))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__Stamp";\
		"type";"INT64";\
		"indexed";True:C214))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableNumber";\
		"type";"INT32"))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__TableName";\
		"type";"VARCHAR(255)"))
	
	This:C1470.deletedRecordsTable.fields.push(New object:C1471(\
		"name";"__PrimaryKey";\
		"type";"VARCHAR(255)"))
	
	This:C1470.stampField:=New object:C1471(\
		"name";"__GlobalStamp";\
		"type";"INT64";\
		"indexed";True:C214)
	
/*=======================================================*/
Function updateStructure
	
	C_VARIANT:C1683($1)
	C_OBJECT:C1216($0)
	
	$0:=dev Update structure (This:C1470;$1)
	
/*=======================================================*/
Function indexName
	
	C_TEXT:C284($1;$0)
	C_LONGINT:C283($i;$l)
	C_TEXT:C284($t)
	C_COLLECTION:C1488($c)
	
	ARRAY TEXT:C222($aT_words;0)
	
	  //replace the underscore with a blank
	$t:=Replace string:C233($1;"_";" ")
	$c:=New collection:C1472
	COLLECTION TO ARRAY:C1562(Split string:C1554($t;"");$aT_words)
	$t:=Lowercase:C14($t)
	$l:=1
	
	For ($i;2;Size of array:C274($aT_words);1)
		
		If (Character code:C91($aT_words{$i})#Character code:C91($t[[$i]]))  // Cesure
			
			$c.push(Substring:C12($t;$l;$i-$l))
			$l:=$i
			
		End if 
	End for 
	
	$c.push(Substring:C12($t;$l))
	
	$t:=$c.join()
	
	GET TEXT KEYWORDS:C1141($t;$aT_words)
	$c:=New collection:C1472
	
	For ($i;1;Size of array:C274($aT_words);1)
		
		$aT_words{$i}:=Lowercase:C14($aT_words{$i})
		
		If ($i>1)
			
			$aT_words{$i}[[1]]:=Uppercase:C13($aT_words{$i}[[1]])
			
		End if 
		
		$c.push($aT_words{$i})
		
	End for 
	
	$0:=$c.join()