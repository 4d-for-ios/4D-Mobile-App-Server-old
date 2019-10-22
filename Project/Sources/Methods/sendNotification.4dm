//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output success object
C_OBJECT:C1216($1)  // input object
C_OBJECT:C1216($Obj_result)
C_TEXT:C284($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
C_TEXT:C284($endpoint)


  // ENDPOINT
  //________________________________________

$Obj_result:=New object:C1471("success";False:C215)


If (Not:C34(Bool:C1537($1.isDevelopment)))
	
	$endpoint:="api.push.apple.com"
	
Else 
	
	$endpoint:="https://api.sandbox.push.apple.com"
	  //$endpoint:="https://api.development.push.apple.com"
	
End if 

If ((Length:C16(String:C10($1.jwt))>0)\
 & (Length:C16(String:C10($1.bundleId))>0)\
 & (Length:C16(String:C10($1.payload))>0)\
 & (Length:C16(String:C10($1.deviceToken))>0))
	
	$cmdPush:="curl --verbose "+\
		"--header \"content-type: application/json\" "+\
		"--header \"authorization: bearer "+$1.jwt+"\" "+\
		"--header \"apns-topic: "+$1.bundleId+"\" "+\
		"--data '"+$1.payload+"' "+\
		""+$endpoint+"/3/device/"+$1.deviceToken
	
	LAUNCH EXTERNAL PROCESS:C811($cmdPush;$cmdPush_in;$cmdPush_out;$cmdPush_err)
	
	If (Length:C16($cmdPush_err)>0)
		
		logAndAlert ($cmdPush_err)
		
	End if 
	
	If (Length:C16($cmdPush_out)>0)  // If notification sending failed, $cmdPush_out contains the error
		
		logAndAlert ($cmdPush_out)
		
	Else   // Notification sent successfully
		
		$Obj_result.success:=True:C214
		
	End if 
	
	  // Else : missing parameter in input object
	
End if 

$0:=$Obj_result