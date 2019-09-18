//%attributes = {"publishedWeb":true}
  // http://localhost/4DAction/deviceToken.  simulate /mobileapp/$deviceToken
  // > register token into session

C_COLLECTION:C1488($1)  // contains a collection of mail address

  // DB MOCKUP
  // 1st is ipad, other are fake
ARRAY OBJECT:C1221($dataArray;0)
APPEND TO ARRAY:C911($dataArray;New object:C1471("email";"abc@gmail.com";"deviceToken";"f3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a83786"))
APPEND TO ARRAY:C911($dataArray;New object:C1471("email";"def@gmail.com";"deviceToken";"f3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657aXXXXX"))
APPEND TO ARRAY:C911($dataArray;New object:C1471("email";"ghi@gmail.com";"deviceToken";"f3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657aYYYYY"))


C_BLOB:C604($requete)
C_TEXT:C284($texteRequete)
WEB GET HTTP BODY:C814($requete)
$texteRequete:=BLOB to text:C555($requete;UTF8 text without length:K22:17)

C_COLLECTION:C1488($recipients)
$recipients:=JSON Parse:C1218($texteRequete)

C_TEXT:C284($mail)


ARRAY OBJECT:C1221($response;0)

For each ($mail;$recipients)
	
	For ($i;1;Size of array:C274($dataArray))
		
		If (OB Get:C1224($dataArray{$i};"email")=$mail)
			
			APPEND TO ARRAY:C911($response;$dataArray{$i})
			
		End if 
		
	End for 
	
End for each 

WEB SEND TEXT:C677(JSON Stringify array:C1228($response))

  //ARRAY TEXT($noms;0)
  //ARRAY TEXT($valeurs;0)
  //WEB GET HTTP HEADER($noms;$valeurs)

  //$url:=""
  //For ($i;0;Size of array($noms))
  //If ($noms{$i}="X-URL")
  //$url:=$valeurs{$i}
  //end if
  //End for 

  //C_LONGINT($vEmail)
  //C_TEXT(vEMAIL)
  //ARRAY TEXT($arrNames;0)
  //ARRAY TEXT($arrVals;0)
  //WEB GET VARIABLES($arrNames;$arrVals)  //we retrieve all the variables of the form
  //$vEmail:=Find in array($arrNames;"email")

  //If ($vEmail>=0)

  //vEMAIL:=$arrVals{$vEmail}
  //// associer mail / deviceToken sur Session dans une autre méthode car ici ce n'est qu'un endpoint
  //WEB SEND TEXT("f3d7358e36a99d7913d58a91f62660b30b8a2a1f013be86479c5db2657a83786") // rendre le deviceToken correspondant

  //Else 

  //WEB SEND TEXT("error")

  //end if


  //$kefrref:=JSON Stringify array($valeurs)
  //$obj:=JSON Stringify($txt)
