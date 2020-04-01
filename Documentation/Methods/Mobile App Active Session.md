# Authentication with email confirmation

the base that allows using the 4d mobile app server component to confirm the sending of emails before opening the session to the user.

##  Contents ##
- [Activate sessions](#ActivateSessions)
- [Resources](#Resources)

# Activate sessions ##

Call the ` Mobile App Active Session ` method in the  ` On Web Connection ` database  method with the Session ID parameter retrieved from the URL.

```swift
C_TEXT($1)
Case of 
    : ($1="/4D4IOS@")
        Mobile App Active Session ($1)
End case
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

The HTML template will be sent to the user as a body after activating the session from the confirmation email.

```html
<html>
    <header>
    </header>
    <body style="margin: 0px;padding: 0px;font: message-box">
        <div style = "background-color: #003265;padding: 15px 10px 20px 20px;margin: 0px;">
            <h2 style="color: #fff;   font-size: 1.3em;">___MESSAGE___</h2>
        </div>
    </body>
</html>
```
