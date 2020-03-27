# PushNotification 🔔

Utility class to send a push notification to one or multiple recipients.

## Usage

First of all, you will need to instanciate the `PushNotification` class with an authentication object.

To use the `send()`  and `sendAll()` functions from `PushNotification` class, you need a notification object that defines the content to send, and recipients.

### Build authentication object 

---

In order to use the component to send push notification, it is required to have an authentication file `AuthKey_XXXX.p8` from Apple.
This file has to be placed in component's `Resources/script` folder.
It is important to note what are `$authKey`, `$authKeyId` and `$teamId` refering to.

<a href="../Generate_p8.md">Check how to generate .p8 key file</a>

```4d
$authKey:=File("/RESOURCES/scripts/AuthKey_XXXYYY.p8")  // AuthKey file
$authKeyId=AuthKey_XXXYYY  // is the second part of the AuthKey filename
$teamId=TEAM123456  // is the team related to the AuthKey file
```

```4d
$bundleId:="com.sample.myappname"
$authKey:=File("/RESOURCES/scripts/AuthKey_XXXYYY.p8")
$authKeyId:="AuthKey_XXXYYY"
$teamId:="TEAM123456"

$auth:=New object
$auth.bundleId:=$bundleId
$auth.authKey:=$authKey
$auth.authKeyId:=$authKeyId
$auth.teamId:=$teamId
```


### Instanciate PushNotification class to authenticate

---

```4d
$pushNotification:=MobileAppServer .PushNotification.new($auth)
```

### Use PushNotification class to send push notifications

---

- #### `send()`

This function will send `$notification` to all `$recipients`.

```4d
$response:=$pushNotification.send($notification;$recipients)
```

- #### `sendAll()`

This function will send `$notification` to any recipient that has a session file on the server for the app.

```4d
$response:=$pushNotification.sendAll($notification)
```

### Build notification object

---

```4d
$notification:=New object
$notification.title:="This is title"
$notification.body:="Here is the content of this notification"
$notification.image:="https://media.giphy.com/media/eWW9O2a4IdpWU/giphy.gif"
```

### Recipients

---

Recipients can be of various types : an email address, a device token, an email address collection, a device token collection, or an object containing both collection.

- #### A single mail address

```4d
$mail:="abc@4dmail.com"
$response:=$pushNotification.send($notification;$mail)
```

- ##### A single device token

A device token can be found in a session file, it identifies a device for push notifications.

```4d
$deviceToken:="xxxxxxxxxxxx"
$response:=$pushNotification.send($notification;$deviceToken)
```

- ##### A mail address collection

```4d
$mails:=New collection("abc@4dmail.com";"def@4dmail.com";"ghi@4dmail.com")
$response:=$pushNotification.send($notification;$mails)
```

- ##### A device token collection

```4d
$deviceTokens:=New collection("xxxxxxxxxxxx";"yyyyyyyyyyyy";"zzzzzzzzzzzz")
$response:=$pushNotification.send($notification;$deviceTokens)
```

- ##### An object

This object should contain 2 collections : a mail address collection and a device token collection.

```4d
$recipients:=New object
$recipients.mails:=New collection("abc@4dmail.com";"def@4dmail.com";"ghi@4dmail.com")
$recipients.deviceTokens:=New collection("xxxxxxxxxxxx";"yyyyyyyyyyyy";"zzzzzzzzzzzz")
$response:=$pushNotification.send($notification;$recipients)
```

### Exploring results

---

You may encounter different kind of issues while sending a push notification. Exploring results lets you know if anything went wrong.

```4d
$response:=$pushNotification.sendAll($notification)

$response.success  // True or False
$response.warnings  // Contains a collection of Text warnings
$response.errors  // Contains a collection of Text errors (implies $response.success is False)
```
