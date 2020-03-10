//%attributes = {}
C_OBJECT:C1216($Json_Filde;$result;$Path_File_Session;$Path_Folder_Session;$template;$parameters;$data)
C_TIME:C306($time;$dif_Time)
C_TEXT:C284($1;$URL;$MSG;$htmlContent;$Real_URL)
C_LONGINT:C283($index)
C_BOOLEAN:C305($active)

stringError:=""
$parameters:=Get Setting 
$active:=False:C215
$template:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file($parameters.template.emailConfirmActivation)
$htmlContent:=""
If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	$URL:=$1
	$Real_URL:=Substring:C12($URL;9)
	If ($Real_URL#"")
		$index:=Storage:C1525.session.extract("id").indexOf($Real_URL)
		If ($index>-1)
			$data:=Storage:C1525.session[$index]
			If ($data#Null:C1517)
				If ($data.date=Current date:C33)
					$dif_Time:=Current time:C178-$data.time
					If ($dif_Time<?00:05:00?)
						$Path_Folder_Session:=Folder:C1567(fk mobileApps folder:K87:18;*).folder($data.team+"."+$data.application)
						If ($Path_Folder_Session.exists)
							$Path_File_Session:=$Path_Folder_Session.file($data.id)
							If ($Path_File_Session.exists)
								$Json_Filde:=JSON Parse:C1218($Path_File_Session.getText())
								If ($Json_Filde.status="pending")
									$Json_Filde.status:="accepted"
									$Path_File_Session.setText(JSON Stringify:C1217($Json_Filde))
									Use (Storage:C1525)
										Use (Storage:C1525.session)
											Storage:C1525.session.remove($index)
										End use 
									End use 
									MOBILE APP REFRESH SESSIONS:C1596
									$MSG:="You are successfully authenticated"
									$active:=True:C214
								End if 
							Else 
								$MSG:="Please contact administrator to unlock your session."
							End if 
						Else 
							$MSG:="Please contact administrator to unlock your session."
						End if 
						
					Else 
						$MSG:="This email confirmation link has expired!"
						Use (Storage:C1525)
							Use (Storage:C1525.session)
								Storage:C1525.session.remove($result.index)
							End use 
						End use 
					End if 
				Else 
					$MSG:="This email confirmation link has expired!"
				End if 
			Else 
				$MSG:="This email confirmation link has expired!"
			End if 
		Else 
			$MSG:="This email confirmation link has expired!"
		End if 
		
	End if 
	
	$htmlContent:=Document to text:C1236($template.platformPath)
	$htmlContent:=Replace string:C233($htmlContent;"___MESSAGE___";$MSG)
	WEB SEND TEXT:C677($htmlContent)
Else 
	$MSG:="settings.json file is not valid"
	$htmlContent:=Document to text:C1236($template.platformPath)
	$htmlContent:=Replace string:C233($htmlContent;"___MESSAGE___";"Please contact administrator")
	WEB SEND TEXT:C677($htmlContent)
End if 
$0:=New object:C1471("success";$active;"message";$MSG;"error";stringError)
