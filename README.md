[![Build Status][build-shield]][build-url]
[![4D][code-shield]][code-url]

# 4D Mobile App Server

Utility methods to improve the 4D Mobile App backend coding.

- [Mobile App Action](Documentation/Methods/Mobile App Action.md) to use with `On Mobile App Action`.
- [Mobile App Authentication](Documentation/Methods/Mobile App Authentication.md) to use with `On Mobile App Authentication`.

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

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[code-shield]: https://img.shields.io/badge/4D-18-orange.svg?style=flat
[code-url]: https://developer.4d.com/
[build-shield]: https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/badges/master/pipeline.svg
[build-url]: https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/commits/master
