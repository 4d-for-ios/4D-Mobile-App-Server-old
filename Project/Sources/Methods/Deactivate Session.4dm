//%attributes = {}
C_TIME:C306($dif_Time)
C_OBJECT:C1216($1;$request;$response;$2;$obj_;$data)
C_LONGINT:C283($index)
$request:=$1
$response:=$2

$index:=Storage:C1525.session.extract("id").indexOf($request.session.id)

If ($index>-1)
	$data:=Storage:C1525.session[$index]
	If ($data.date=Current date:C33)
		$dif_Time:=Current time:C178-$data.time
		If ($dif_Time<=?00:05:00?)
			$response.statusText:="The mail is already sent thank you to wait before sending again "+String:C10($dif_Time)+"index : "+String:C10($index)+" time "+String:C10($data.time)
		Else 
			$obj_:=Send Mail ($request)
			If ($obj_.status)
				$response.statusText:="Verify your email address"
			Else 
				$response.statusText:=$obj_.statusText
			End if 
		End if 
	Else 
		$response.statusText:="The mail is already sent thank you to wait before sending again; index : "+String:C10($index)+" date "+String:C10($data.date)
	End if 
Else 
	$obj_:=Send Mail ($request)
	If ($obj_.status)
		$response.statusText:="Verify your email address"
	Else 
		$response.statusText:=$obj_.statusText
	End if 
End if 

