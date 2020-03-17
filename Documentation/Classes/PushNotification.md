# Push 🔔

Utility methods to send push notifications to different recipients.

## Usage

To use the send() function from PushNotification class, you will need to build a notification object, a recipients object, and an authentication object.

### Build authentication object
In order to use the component to send push notification, it is required to have an authentication file AuthKey_XXXX.p8 from Apple.
This file has to be placed in component's Resources/script folder next to authScriptArgs.sh file.
It is important to note what are $authKey, $authKeyId and teamId refering to.

[Check how to generate .p8 key file](Documentation/Methods/Generate_p8.md) // go to .io github pages

```4d
$authKey="AuthKey_XXXYYY.p8"  // name of the file
$authKeyId=AuthKey_XXXYYY   // is the second part of $authKey filename
$teamId=TEAM123456   // is the team related to the AuthKey file
```

```4d
$bundleId:="com.sample.myappname"
$authKey:=File("/RESOURCES/scripts/AuthKey_XXXYYY.p8").platformPath
$authKeyId:="AuthKey_XXXYYY"
$teamId:="TEAM123456"

$auth:=New object(\
    "bundleId";$bundleId;\
    "authKey";$authKey;\
    "authKeyId";$authKeyId;\
    "teamId";$teamId)
```


### Use PushNotification class to authenticate
```4d
$pushNotification:=MobileAppServer .PushNotification.new($auth)
```


### Build notification object

```4d
$notification:=New object
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
$notification.image:="https://media.giphy.com/media/eWW9O2a4IdpWU/giphy.gif"
```


### Build recipients object. 
This object can contain 2 collections : one of mail addresses whose deviceToken will be retrieved in Session files, and one of deviceTokens

```4d
$recipients:=New object
$recipients.recipientMails:=New collection(\
    "abc@gmail.com";\
    "def@gmail.com";\
    "ghi@gmail.com")
$recipients.deviceTokens:=New collection(\
    "fe4efz52zf7ze5ffe4efz52zf7ze5ffe4efz52zf7ze5ffe4efz52zf7ze5f")
```


### Send push notifications
```4d
// Sends a push notification to every recipient
$response:=$pushNotification.send($notification;$recipients)

  // $response.success True or False
  // $response.errors contains a collection of Text errors, Success is False
  // $response.warnings contains a collection of Text warnings, Success is True or False

reviewIssues ($response.errors;"Errors") // Will display an alert if any error occurred
reviewIssues ($response.warnings;"Warnings") // Will display an alert if any warning occurred
```