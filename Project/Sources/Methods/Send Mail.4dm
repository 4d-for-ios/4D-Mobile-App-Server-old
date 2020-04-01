//%attributes = {"preemptive":"capable"}
C_TEXT:C284($htmlContent;$Txt_methodOnErrorCall;$value)
C_OBJECT:C1216($0;$1;$request;$status;$template;$parameters;$o;$transporter)

stringError:=""
$request:=$1
$parameters:=Get Setting 
$template:=Folder:C1567(fk resources folder:K87:11;*).folder("4D Mobile App Server").file($parameters.template.emailToSend)
If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	$o:=New object:C1471
	$o.smtp:=New object:C1471
	$o.smtp.host:=$parameters.smtp.host  //
	$o.smtp.acceptUnsecureConnection:=False:C215
	$o.smtp.port:=Choose:C955($o.smtp.acceptUnsecureConnection;465;587)
	$o.smtp.user:=$parameters.smtp.login
	$o.smtp.password:=$parameters.smtp.pwd
	$o.smtp.keepAlive:=True:C214
	$o.smtp.connectionTimeOut:=30
	$o.smtp.sendTimeOut:=100
	
	$o.mail:=New object:C1471
	$o.mail.from:=$parameters.smtp.from
	$o.mail.to:=$request.email
	$o.mail.subject:=$parameters.emailSubject
	$htmlContent:=$template.getText()
	$value:=$parameters.activation.url+"?"+$request.session.id
	$htmlContent:=Replace string:C233($htmlContent;"___IDSESSION___";$value)
	$o.mail.htmlBody:=$htmlContent
	$transporter:=SMTP New transporter:C1608($o.smtp)
	$Txt_methodOnErrorCall:=Method called on error:C704
	ON ERR CALL:C155("getErrorInfo")
	$status:=$transporter.send($o.mail)
	ON ERR CALL:C155($Txt_methodOnErrorCall)
	If ($status.success)
		Use (Storage:C1525)
			Use (Storage:C1525.session)
				Storage:C1525.session.push(New shared object:C1526(\
					"id";$request.session.id;\
					"team";$request.team.id;\
					"application";$request.application.id;\
					"date";Current date:C33;\
					"time";Current time:C178))
			End use 
		End use 
	End if 
	
	$0:=New object:C1471("status";$status.success;"statusText";$status.statusText;"error";stringError)
Else 
	$0:=New object:C1471("status";False:C215;"statusText";$template.platformPath+" is not found";"error";stringError)
End if 
