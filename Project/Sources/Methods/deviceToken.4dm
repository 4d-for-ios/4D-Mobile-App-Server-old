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
  //  "application": { "id": "com.sample.NotifSampleApp2", "name": "Application Name" },
  //  "device": { "id": "fdkjqfg5766sdgf", "name": "Iphone", "deviceToken": "xxxxxxxxx" }
  // }

C_BLOB:C604($request)
C_TEXT:C284($request_txt;$appId_req;$deviceToken_req;$email_req)
C_OBJECT:C1216($httpContents;$response)

$response:=New object:C1471("success";False:C215)


  // GET REQUEST BODY
  //________________________________________

WEB GET HTTP BODY:C814($request)

$request_txt:=BLOB to text:C555($request;UTF8 text without length:K22:17)

$httpContents:=JSON Parse:C1218($request_txt)

$appId_req:=$httpContents.teamId+"."+$httpContents.application.id
$deviceToken_req:=$httpContents.device.deviceToken
$email_req:=$httpContents.email


  // RETRIEVE THE SESSION INFO
  //________________________________________

C_OBJECT:C1216($Obj_infos;$app;$session;$sessionFile;$currentSessionObject)
C_TEXT:C284($currentSessionContent;$newSessionContent)

$Obj_infos:=MOBILE APP Get session info ($appId_req;$email_req)

If ($Obj_infos.success)
	
	$sessionFile:=Folder:C1567(fk mobileApps folder:K87:18).folder($appId_req).file($Obj_infos.session.session.id)
	
	If ($sessionFile.exists)
		
		$currentSessionContent:=Document to text:C1236($sessionFile.platformPath)
		
		$currentSessionObject:=JSON Parse:C1218($currentSessionContent)
		
		  // Write deviceToken in session
		
		$currentSessionObject.deviceToken:=$deviceToken_req
		
		$newSessionContent:=JSON Stringify:C1217($currentSessionObject)
		
		TEXT TO DOCUMENT:C1237($sessionFile.platformPath;$newSessionContent)
		
		$response.success:=True:C214
		
		  // Else : file doesn't exist
		
	End if 
	
	  // Else : couldn't find session file for the related app id / mail address
	
End if 

WEB SEND TEXT:C677(JSON Stringify array:C1228($response))









