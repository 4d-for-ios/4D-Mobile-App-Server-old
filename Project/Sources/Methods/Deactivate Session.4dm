//%attributes = {}
C_TIME:C306($dif_Time)
C_OBJECT:C1216($1;$request;$response;$2;$obj_;$data)
C_LONGINT:C283($index)
$request:=$1
$response:=$2
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $1 : "+JSON Stringify:C1217($1))
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $2 : "+JSON Stringify:C1217($2))

LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $request : "+JSON Stringify:C1217($request))
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $response : "+JSON Stringify:C1217($response))

LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** Storage.session.length : "+String:C10(Storage:C1525.session.length))
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** Storage.session : "+JSON Stringify:C1217(Storage:C1525.session))
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** Storage.session.extract(id) : "+JSON Stringify:C1217(Storage:C1525.session.extract("id")))
LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $index : "+String:C10($index))

$index:=Storage:C1525.session.extract("id").indexOf($request.session.id)

If (($index>-1) & (Storage:C1525.session.length#0))
	$data:=Storage:C1525.session[$index]
	LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $data : "+JSON Stringify:C1217($data))
	If ($data.date=Current date:C33)
		$dif_Time:=Current time:C178-$data.time
		LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $dif_Time : "+String:C10($dif_Time))
		LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $data.date : "+String:C10($data.date))
		LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $data.time : "+String:C10($data.time))
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
		LOG EVENT:C667(Into 4D debug message:K38:5;"**Send mail** $data.date : "+String:C10($data.date))
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

  //Use (Storage)
  //If (Storage.session=Null)
  //Storage.session:=New shared collection
  //End if 
  //End use 
