//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output success object
C_OBJECT:C1216($1)  // input auth object
C_OBJECT:C1216($Obj_result;$authScript)
C_TEXT:C284($cmdAuth;$cmdAuth_in;$cmdAuth_out;$cmdAuth_err)
C_TEXT:C284($authScriptPathFinalWithArgs)

LOG EVENT:C667(Into 4D debug message:K38:5;$cmdAuth)

$Obj_result:=New object:C1471("success";False:C215)

  // Parameters already verified in calling method


  // AUTHENTICATION FROM SCRIPT
  //________________________________________

$authScript:=File:C1566("/RESOURCES/scripts/authScriptArgs.sh")

If ($authScript.exists)
	
	$authScriptPathFinalWithArgs:=Convert path system to POSIX:C1106($authScript.platformPath)+" "+\
		Convert path system to POSIX:C1106($1.authKey)+" "+\
		$1.authKeyId+" "+\
		$1.teamId
	
	$cmdAuth:="/bin/sh "+$authScriptPathFinalWithArgs
	
	LAUNCH EXTERNAL PROCESS:C811($cmdAuth;$cmdAuth_in;$cmdAuth_out;$cmdAuth_err)
	
	If (Length:C16($cmdAuth_err)=0)  // If script execution failed, $cmdAuth_err contains the error
		
		$Obj_result.jwt:=$cmdAuth_out  // Contains the JSON Web Token required for authorization header
		$Obj_result.success:=True:C214
		
	Else 
		
		LOG EVENT:C667(Into 4D debug message:K38:5;$cmdAuth_err)
		
	End if 
	
	  // Else : Missing authScript file
	
End if 

$0:=$Obj_result