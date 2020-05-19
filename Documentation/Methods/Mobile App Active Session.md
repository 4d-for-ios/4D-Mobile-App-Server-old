# Authentication with email confirmation

the base that allows using the 4D mobile app server component to confirm the sending of emails before opening the session to the user.

##  Contents ##
- [Activate sessions](#ActivateSessions)
- [Resources](#Resources)

## Activate sessions ##

Call the `Mobile App Active Session` method in the  `On Web Connection` database  method with the Session ID parameter retrieved from the URL.

```swift
C_TEXT($1)

Case of
: (Mobile App Active Session($1).success)
    //add log if you want
End case
```
in case of an error, the `Mobile App Active Session` method returns a list of errors

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

The HTML template will be sent to the user as a body after activating the session from the confirmation email. \

Note: if the settings file does not exist in the Resources folder of your 4D base, a settings.sample.json file will be created, there you will find the mandatory configuration that you must fill out

```html
<html>
    <header>
    </header>
    <body style="margin: 0px;padding: 0px;font: message-box">
        <div style = "background-color: #003265;padding: 15px 10px 20px 20px;margin: 0px;">
            <h2 style="color: #fff;   font-size: 1.3em;">{{message}}</h2>
        </div>
    </body>
</html>
```
*{{message}}* : will be changed by the status of your request
