//%attributes = {"invisible":true,"preemptive":"capable"}
C_OBJECT:C1216($0)  // output success object
C_OBJECT:C1216($1)  // input auth object
C_OBJECT:C1216($Obj_result;$jwt)

$Obj_result:=New object:C1471("success";False:C215)

  // Parameters already verified in calling method


  // GENERATE JSON WEB TOKEN
  //________________________________________

C_OBJECT:C1216($settings;$key;$header;$payload;$status)
C_TEXT:C284($signature;$message)

$settings:=New object:C1471
$settings.type:="PEM"
$settings.pem:=$1.authKey.getText()

$key:=MobileAppServer .jwt.new($settings)

$header:=New object:C1471("alg";"ES256";"kid";$1.authKeyId)
  //$payload:=New object("iss";$1.teamId;"iat";Current date)
C_LONGINT:C283($iat)
$iat:=((Current date:C33-Add to date:C393(!00-00-00!;1970;1;1))*86400)+(Current time:C178+0)-10000
  //$payload:=New object("iss";$1.teamId;"iat";1586527100)
$payload:=New object:C1471("iss";$1.teamId;"iat";$iat)
$signature:=$key.sign($header;$payload;New object:C1471("hash";"HASH256";"algorithm";"ES256"))

$status:=$key.verify($signature;New object:C1471("hash";"HASH256"))
ASSERT:C1129($status.success)

$Obj_result.success:=$status.success
$Obj_result.jwt:=$signature


$0:=$Obj_result