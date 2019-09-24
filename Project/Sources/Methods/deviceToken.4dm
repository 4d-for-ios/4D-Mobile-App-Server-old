//%attributes = {"publishedWeb":true}
  // http://localhost/4DAction/deviceToken.  simulate /mobileapp/$deviceToken
  // > register token into session

  //________________________________________


  // DB MOCKUP
  //________________________________________

ARRAY OBJECT:C1221($dataArray;0)

  // First one is ipad's deviceToken, others are fake
APPEND TO ARRAY:C911($dataArray;New object:C1471("email";"abc@gmail.com";"deviceToken";"f3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a83786"))
APPEND TO ARRAY:C911($dataArray;New object:C1471("email";"def@gmail.com";"deviceToken";"f3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657aXXXXX"))
APPEND TO ARRAY:C911($dataArray;New object:C1471("email";"ghi@gmail.com";"deviceToken";"f3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657aYYYYY"))


  // Get request body
C_BLOB:C604($requete)
C_TEXT:C284($texteRequete)

WEB GET HTTP BODY:C814($requete)  // Contains a collection of mail address

$texteRequete:=BLOB to text:C555($requete;UTF8 text without length:K22:17)


C_COLLECTION:C1488($recipients)

$recipients:=JSON Parse:C1218($texteRequete)

ARRAY OBJECT:C1221($response;0)


  // FETCH DB
  //________________________________________

C_TEXT:C284($mail)
C_LONGINT:C283($i)

For each ($mail;$recipients)  // For each mail given, fetch its related deviceToken
	
	For ($i;1;Size of array:C274($dataArray))
		
		If (OB Get:C1224($dataArray{$i};"email")=$mail)  // If we found the give mail address
			
			APPEND TO ARRAY:C911($response;$dataArray{$i})  // We add the fetched deviceToken to the result list
			
		End if 
		
	End for 
	
End for each 

  // Returns the list of deviceTokens found
WEB SEND TEXT:C677(JSON Stringify array:C1228($response))




  //_____________________ sessions.

  // parcourir les sessions, trouver les deviceToken correspondants aux mails 

  //C_OBJECT($Obj_infos)
  //C_TEXT($bundleId;$teamId;$concatenatedId)



  //$bundleId:="com.myCompany.Tasks"          // given in entry
  //// should we get the team id from request
  //$teamId:="UTT7VDX8W5"                     // given in entry
  //$concatenatedId:=$teamId+"."+$bundleId


  //  // Retrieve the sessions informations
  //$Obj_infos:=MOBILE APP Get sessions info 

  //If ($Obj_infos.apps#Null)

  //For each ($app;$Obj_infos.apps)

  //If ($app.id=$concatenatedId)

  //For each ($session;$app.sessions)

  //For each ($mail;$recipients)  // For each mail given, fetch its related deviceToken

  //If ($mail=$session.email)

  //$newObject:=New object(\
"email";$session.email;\
"deviceToken";$session.deviceToken)

  //APPEND TO ARRAY($response;$newObject)  // We add the fetched deviceToken to the result list

  //End if

  //End for each 

  //End for each

  //End if

  //End for each

  //End if









