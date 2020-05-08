//%attributes = {"invisible":true}
C_OBJECT:C1216($0)
C_OBJECT:C1216($template;$info;$file)
C_TEXT:C284($Txt_methodOnErrorCall)
$template:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file("settings.json")
If ($template.exists)
	$Txt_methodOnErrorCall:=Method called on error:C704
	ON ERR CALL:C155("GET ERROR INFO")
	$0:=JSON Parse:C1218($template.getText())
	ON ERR CALL:C155($Txt_methodOnErrorCall)
	If ($0.activation=Null:C1517)
		$0.activation:=New object:C1471
	End if 
	$info:=WEB Get server info:C1531()
	If ($0.activation.scheme=Null:C1517)
		$0.activation.scheme:=Choose:C955($info.security.HTTPSEnabled;"https";"http")
	End if 
	If ($0.activation.hostname=Null:C1517)
		$0.activation.hostname:=$info.options.webIPAddressToListen[0]
	End if 
	If ($0.activation.port=Null:C1517)
		$0.activation.port:=String:C10(Choose:C955($info.security.HTTPSEnabled;$info.options.webHTTPSPortID;$info.options.webPortID))
	End if 
	If ($0.activation.path=Null:C1517)
		$0.activation.path:="activation"
	End if 
	If ($0.activation.otherParameters=Null:C1517)
		$0.activation.otherParameters:=""
	End if 
	
	If ($0.emailSubject=Null:C1517)
		$0.emailSubject:="Application Name: Sign in confirmation"
	End if 
	If ($0.timeout=Null:C1517)
		$0.timeout:=300000
	End if 
	If ($0.message=Null:C1517)
		$0.message:=New object:C1471
	End if 
	If ($0.message.successConfirmationMailMessage=Null:C1517)
		$0.message.successConfirmationMailMessage:="Verify your email address"
	End if 
	If ($0.message.waitSendMailConfirmationMessage=Null:C1517)
		$0.message.waitSendMailConfirmationMessage:="The mail is already sent thank you to wait before sending again"
	End if 
	If ($0.message.successActiveSessionsMessage=Null:C1517)
		$0.message.successActiveSessionsMessage:="You are successfully authenticated"
	End if 
	If ($0.message.expireActiveSessionsMessage=Null:C1517)
		$0.message.expireActiveSessionsMessage:="This email confirmation link has expired!"
	End if 
	If ($0.template=Null:C1517)
		$0.template:=New object:C1471
	End if 
	If ($0.template.emailToSend=Null:C1517)
		$file:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file("ConfirmMailTemplate.html")
		$file.create()
		$file.setText("<html>\n    <header>\n    </header>\n    <body>\n        Hello,\n        <br><br>\n        To start using the App, you must first confirm your subscription by clicking on the following link: \n        <a href=\"{{ URL }}\">Click Here.</a>\"<br>\n        The link"+" will expire in {{ EXPIRATIONMINUTES }} minutes.\n        <br><br>\n        Sincerely,\n    </body>\n</html>")
		$0.template.emailToSend:="ConfirmMailTemplate.html"
	End if 
	If ($0.template.emailConfirmActivation=Null:C1517)
		$file:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file("ActiveSessionTemplate.html")
		$file.create()
		$file.setText("<html>\n    <header>\n    </header>\n    <body style=\"margin: 0px;padding: 0px;font: message-box\">\n        <div style = \"background-color: #003265;padding: 15px 10px 20px 20px;margin: 0px;\">\n            <h2 style=\"color: #fff;   font-size: 1.3em;\">{{ MES"+"SAGE }}</h2>\n        </div>\n    </body>\n</html>")
		$0.template.emailConfirmActivation:="ActiveSessionTemplate.html"
	End if 
	
	$0.fileExist:=True:C214
Else 
	$0:=New object:C1471("fileExist";False:C215;"statusText";"Missing configuration files "+$template.platformPath)
End if 