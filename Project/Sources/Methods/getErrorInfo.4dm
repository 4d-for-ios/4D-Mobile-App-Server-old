//%attributes = {}

C_COLLECTION:C1488($mycol)
ARRAY TEXT:C222($errcodes;0)
ARRAY TEXT:C222($errcomps;0)
ARRAY TEXT:C222($errmess;0)
GET LAST ERROR STACK:C1015($errcodes;$errcomps;$errmess)
$mycol:=New collection:C1472
ARRAY TO COLLECTION:C1563($mycol;$errmess)
stringError:=JSON Stringify:C1217($mycol)
