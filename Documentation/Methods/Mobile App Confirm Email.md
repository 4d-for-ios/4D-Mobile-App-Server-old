# Authentication with email confirmation

the base that allows using the 4d mobile app server component to confirm the sending of emails before opening the session to the user.

##  Contents ##
- [Disable sessions](#DisableSessions)
- [Resources](#Resources)
# Disable sessions ##

Call ` Mobile App Confirm Email `  method in the ` On Mobile App Authentification ` database  method with two parameters, 1st the information provided by the mobile application and 2nd the information returned to the mobile application

```swift
C_OBJECT($0;$response)
C_OBJECT($1;$request)
$request:=$1
$response:=New object
Mobile App Confirm Email ($1;$response)
$0:=$response
```

# Resources ##

The settings.json file must contain the following parameters:

```javascript
{
    "smtp" : {
        "login":"sender4dsmtp@gmail.com",
        "pwd":"*****",
        "from":"sender4dsmtp@gmail.com",
        "host":"smtp.gmail.com",
        "port":465
    },
    "template":{    
        "emailToSend": "ConfirmMailTemplate.html",
        "emailConfirmActivation":"ActiveSessionTemplate.html"
    },
    "emailSubject":"Application Name: Sign in confirmation",
    "activation": {
        "url":"http://192.168.1.2/4D4IOS"
    },
    "timeout":"00:05:00"
}
```

The HTML template that will be sent to the user as a body in the confirmation email

```html
<html>
    <header>
    </header>
    <body>
        Hello,
        <br><br>
        To start using the App, you must first confirm your subscription by clicking on the following link: 
        <a href="___IDSESSION___">Click Here.</a>"<br>
        The link will expire in 5 minutes.
        <br><br>
        Sincerely,
    </body>
</html>
```
