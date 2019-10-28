//%attributes = {"shared":true,"preemptive":"capable"}
C_OBJECT:C1216($2)
C_OBJECT:C1216($1)
C_OBJECT:C1216($0)
C_OBJECT:C1216($request;$response)
$request:=$1
$response:=$2
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** DB Method $1 : "+JSON Stringify:C1217($1))
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** DB Method $2 : "+JSON Stringify:C1217($2))
$response.verify:=True:C214
MOBILE APP REFRESH SESSIONS:C1596
Deactivate Session ($request;$response)
$0:=$response
