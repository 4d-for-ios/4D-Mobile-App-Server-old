//%attributes = {}
C_TEXT:C284($htmlContent)
C_OBJECT:C1216($0;$1;$request;$status;$template;$parameters;$o;$transporter)

$request:=$1

$parameters:=Get Info 
$template:=Folder:C1567(fk resources folder:K87:11;*).file($parameters.SendTemplate)

If (Asserted:C1132($template.exists;"Missing file "+$template.platformPath))
	
	
	$o:=New object:C1471
	$o.smtp:=New object:C1471
	$o.smtp.host:=$parameters.host  //
	$o.smtp.acceptUnsecureConnection:=False:C215
	$o.smtp.port:=Choose:C955($o.smtp.acceptUnsecureConnection;465;587)
	$o.smtp.user:=$parameters.login
	$o.smtp.password:=$parameters.pwd
	$o.smtp.keepAlive:=True:C214
	$o.smtp.connectionTimeOut:=30
	$o.smtp.sendTimeOut:=100
	
	$o.mail:=New object:C1471
	$o.mail.from:=$parameters.from
	$o.mail.to:=$request.email
	$o.mail.subject:=$request.application.name+": Sign in confirmation"
	
	$htmlContent:=$template.getText()
	$htmlContent:=Replace string:C233($htmlContent;"___IDSESSION___";$request.session.id)
	
	$o.mail.htmlBody:=$htmlContent
	$transporter:=SMTP New transporter:C1608($o.smtp)
	ON ERR CALL:C155("000TrapThisErrorSMTP")  // 6.39d Pour éviter l'apparition de fenêtre d'erreur d'exécution au niveau du serveur
	$status:=$transporter.send($o.mail)
	ON ERR CALL:C155("")
	
	If ($status.success)
		Use (Storage:C1525.session)
			Storage:C1525.session.push(New shared object:C1526(\
				"id";$request.session.id;\
				"team";$request.team.id;\
				"application";$request.application.id;\
				"date";Current date:C33;\
				"time";Current time:C178))
		End use 
	End if 
	
	$0:=New object:C1471("status";$status.success;"statusText";$status.statusText)
	
End if 
