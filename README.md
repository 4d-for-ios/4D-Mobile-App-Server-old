[![language](https://img.shields.io/static/v1?label=language&message=4d&color=blue)](https://developer.4d.com/)
[![language-top](https://img.shields.io/github/languages/top/4d-for-ios/4D-Mobile-App-Server.svg)](https://developer.4d.com/)
![code-size](https://img.shields.io/github/languages/code-size/4d-for-ios/4D-Mobile-App-Server.svg)
[![release](https://img.shields.io/github/v/release/4d-for-ios/4D-Mobile-App-Server)](https://github.com/4d-for-ios/4D-Mobile-App-Servere/releases/latest)
[![license](https://img.shields.io/github/license/4d-for-ios/4D-Mobile-App-Server)](LICENSE)

# 4D Mobile App Server

Utility methods to improve the 4D Mobile App backend coding.

- [Mobile App Action](Documentation/Methods/Mobile%20App%20Action.md) to use with `On Mobile App Action`.
- [Mobile App Authentication](Documentation/Methods/Mobile%20App%20Authentication.md) to use with `On Mobile App Authentication`.

# Authentication ##

Utility methods to get manipulate session when inside `On Mobile App Authentication` database method.

```swift
    // Create an object with formula
$auth:=Mobile App Authentication($1) // $1 Informations provided by mobile application

$myAppId:=$auth.getAppId()

$mySessionFile:=$auth.getSessionFile()

$mySessionObject:=$auth.getSessionObject()
$mySessionObject.status:="pending"
$mySessionObject.save()

```

# Contributing #

See [CONTRIBUTING](CONTRIBUTING.md) guide.
