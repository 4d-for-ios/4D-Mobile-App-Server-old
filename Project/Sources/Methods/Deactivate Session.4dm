//%attributes = {}
C_TIME:C306($dif_Time)
C_OBJECT:C1216($1;$request;$response;$2;$obj_;$data)
C_LONGINT:C283($index)
$request:=$1
$response:=$2
Use (Storage:C1525)
	If (Storage:C1525.session=Null:C1517)
		Storage:C1525.session:=New shared collection:C1527
	End if 
End use 
$index:=Storage:C1525.session.extract("id").indexOf($request.session.id)

If (($index>-1) & (Storage:C1525.session.length#0))
	$data:=Storage:C1525.session[$index]
	If ($data.date=Current date:C33)
		$dif_Time:=Current time:C178-$data.time
		If ($dif_Time<=?00:05:00?)
			$response.statusText:="The mail is already sent thank you to wait before sending again"
		Else 
			$obj_:=Send Mail ($request)
			If ($obj_.status)
				$response.statusText:="Verify your email address"
			Else 
				$response.statusText:=$obj_.statusText
			End if 
		End if 
	Else 
		$response.statusText:="The mail is already sent thank you to wait before sending again"
	End if 
Else 
	$obj_:=Send Mail ($request)
	If ($obj_.status)
		$response.statusText:="Verify your email address"
	Else 
		$response.statusText:=$obj_.statusText
	End if 
End if 
