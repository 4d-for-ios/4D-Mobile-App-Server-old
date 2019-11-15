//%attributes = {"shared":true,"preemptive":"capable"}
C_OBJECT:C1216($2)
C_OBJECT:C1216($1)
C_OBJECT:C1216($0)
C_OBJECT:C1216($request;$response)
$request:=$1
$response:=$2
$response.verify:=True:C214
MOBILE APP REFRESH SESSIONS:C1596
Deactivate Session ($request;$response)
$0:=$response
