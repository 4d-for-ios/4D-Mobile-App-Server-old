//%attributes = {"publishedWeb":true}
  //
  // http://localhost/4DAction/deviceToken
  // Simulates /mobileapp/$deviceToken
  //
  // Registers token into session
  //________________________________________

  // Request's body is as follow :
  //
  // {
  //  "email": "abc@gmail.com",
  //  "teamId": "UTT7VDX8W5",
  //  "session": { "id": "60711cd925b8a0facde10e1de30b13c43e342254"},
  //  "application": { "id": "com.sample.NotifSampleApp2", "name": "Application Name" },
  //  "device": { "id": "fdkjqfg5766sdgf", "name": "Iphone", "token": "xxxxxxxxx" },
  //  "userInfo" : {}
  // }

C_BLOB:C604($request)
C_TEXT:C284($request_txt;$deviceToken_req)
C_OBJECT:C1216($httpContents;$response)

$response:=New object:C1471("success";False:C215)


  // GET REQUEST BODY
  //________________________________________

WEB GET HTTP BODY:C814($request)

$request_txt:=BLOB to text:C555($request;UTF8 text without length:K22:17)

$httpContents:=JSON Parse:C1218($request_txt)

$deviceToken_req:=$httpContents.device.token


  // RETRIEVE THE SESSION INFO
  //________________________________________

C_OBJECT:C1216($Obj_session;$currentSessionObject)
C_TEXT:C284($currentSessionContent;$newSessionContent)

$Obj_session:=MA Get session from JSON ($httpContents)

If ($Obj_session.success)
	
	$currentSessionContent:=Document to text:C1236($Obj_session.session.platformPath)
	
	$currentSessionObject:=JSON Parse:C1218($currentSessionContent)
	
	  // Write deviceToken into session
	
	$currentSessionObject.device.token:=$deviceToken_req
	
	$newSessionContent:=JSON Stringify:C1217($currentSessionObject)
	
	TEXT TO DOCUMENT:C1237($Obj_session.session.platformPath;$newSessionContent)
	
	$response.success:=True:C214
	
	  // Else : couldn't find app directory or session file
	
End if 

WEB SEND TEXT:C677(JSON Stringify array:C1228($response))

