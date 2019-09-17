//%attributes = {"publishedWeb":true}
  // http://localhost/4DAction/deviceToken.  simulate /mobileapp/$deviceToken
  // > register token into session

  //C_TEXT($txt)
  //WEB GET HTTP BODY($txt)

  //C_BLOB($requete)
  //C_TEXT($texteRequete)
  //WEB GET HTTP BODY($requete)
  //$texteRequete:=BLOB to text($requete;UTF8 text without length)

  //ARRAY TEXT($noms;0)
  //ARRAY TEXT($valeurs;0)
  //WEB GET HTTP HEADER($noms;$valeurs)

  //$url:=""
  //For ($i;0;Size of array($noms))
  //If ($noms{$i}="X-URL")
  //$url:=$valeurs{$i}
  //end if
  //End for 

C_LONGINT:C283($vEmail)
C_TEXT:C284(vEMAIL)
ARRAY TEXT:C222($arrNames;0)
ARRAY TEXT:C222($arrVals;0)
WEB GET VARIABLES:C683($arrNames;$arrVals)  //we retrieve all the variables of the form
$vEmail:=Find in array:C230($arrNames;"email")

If ($vEmail>=0)
	
	vEMAIL:=$arrVals{$vEmail}
	  // associer mail / deviceToken sur Session ~ SessionManagement dans une autre méthode car ici ce n'est qu'un endpoint
	WEB SEND TEXT:C677("hello world")  // rendre le deviceToken correspondant
	
Else 
	
	WEB SEND TEXT:C677("error")
	
End if 



  //$kefrref:=JSON Stringify array($valeurs)
  //$obj:=JSON Stringify($txt)
