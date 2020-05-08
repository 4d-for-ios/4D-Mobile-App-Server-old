# Authentication with email confirmation

the base that allows using the 4D mobile app server component to confirm the sending of emails before opening the session to the user.

##  Contents ##
- [Disable sessions](#DisableSessions)
- [Resources](#Resources)

## Disable sessions ##

Call `Mobile App Email Checker`  method in the `On Mobile App Authentification` database  method with the information provided by the mobile application.

```swift
C_OBJECT($0)
C_OBJECT($1)
$0:= Mobile App Email Checker ($1)
```
in case of an error, the `Mobile App Email Checker` method returns a list of errors

## Resources ##

The settings.json file must contain the following parameters:

```json
{
    "smtp" : {
        "user":"mail@example.com",
      	"password":"******",
      	"from":"mail@example.com",
      	"host":"smtp.example.com",
        "port":465
        },
    "template":{    
		    "emailToSend": "ConfirmMailTemplate.html",
      	"emailConfirmActivation":"ActiveSessionTemplate.html"
        },
  	"emailSubject":"Application Name: Sign in confirmation",
  	"activation": {
    		"scheme":"http",
    		"hostname":"192.168.1.2",
        "port": "80",
    		"path":"activation",
    		"otherParameters":""
  	   },
  	"timeout":300000,
  	"message":{
    		"successConfirmationMailMessage":"Verify your email address",
    		"waitSendMailConfirmationMessage":"The mail is already sent thank you to wait before sending again",
    		"successActiveSessionsMessage":"You are successfully authenticated",
    		"expireActiveSessionsMessage":"This email confirmation link has expired!"
	     }
}
```
*activation.scheme*: **http or https** \
*activation.hostname*: **192.168.1.2** // server address \
*activation.port*: **80** // server port \
*activation.path*: **activation** // used to catch the value of the token connection \
*activation.otherParameters*: **param1=Value1&param2=value2** // custom user settings

*message.successConfirmationMailMessage*: message displayed in the mobile application if the email is sent successfully \
*message.waitSendMailConfirmationMessage*: message displayed in the mobile application if the user tries to login without activating his account from his email address and without respecting the expiration value of a connection \
*message.successActiveSessionsMessage*: message displayed in the activation web page if the session is activated \
*message.expireActiveSessionsMessage*: message displayed in the activation web page if the session has expired

The HTML template that will be sent to the user as a body in the confirmation email

```html
<html>
    <header>
    </header>
    <body>
        Hello,
        <br><br>
        To start using the App, you must first confirm your subscription by clicking on the following link:
        <a href="{{ URL }}">Click Here.</a>"<br>
        The link will expire in {{ EXPIRATIONMINUTES }} minutes.
        <br><br>
        Sincerely,
    </body>
</html>
```

{{ URL }} : will be modified by the set of activation values \
{{ EXPIRATIONMINUTES }} : **300000 -> 5min**; will be modified by the "timeout" value which exists in the Settings.json file
