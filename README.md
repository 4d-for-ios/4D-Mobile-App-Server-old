# 4D Mobile App Server

[![language][code-shield]][code-url]
[![language-top][code-top]][code-url]
![code-size][code-size]
[![release][release-shield]][release-url]
[![license][license-shield]][license-url]

Utility methods to speed up the 4D Mobile App backend coding.

## Usage

### Classes

Wrap input from `On Mobile App...` database methods into this classes to get utility functions.

- [MobileAppServer.Action](Documentation/Classes/Action.md) provide utility methods for [`On Mobile App Action`](https://doc.4d.com/4Dv18/4D/18/On-Mobile-App-Action-database-method.301-4505017.en.html) coding.
- [MobileAppServer.Authentication](Documentation/Classes/Authentication.md) provide utility methods for [`On Mobile App Authentication`](https://doc.4d.com/4Dv18/4D/18/On-Mobile-App-Authentication-database-method.301-4505016.en.html) coding.

## Installing

Add this component to your "Components" database folder

On Unix system open a terminal.

### Using latest release

Download the latest release and put  it into the `Components/` folder

On mac or linux system you could do it using this command line

```bash
mkdir -p "Components" && curl -L https://github.com/4d-for-ios/4D-Mobile-App-Server/releases/latest/download/Mobile%20App%20Server.4DZ --output "Components/Mobile App Server.4dz"
```

### Using git submodule

#### to use source code

```bash
git submodule add https://github.com/4d-for-ios/4D-Mobile-App-Server.git "Components/4D Mobile AppServer.4dbase"
```

#### to use binary

```bash
git submodule add https://github.com/4d-for-ios/4D-Mobile-App-Server.git "Components/4D Mobile AppServer"
```

Open the project, for instance in unix system

```bash
open "Components/4D Mobile App Server/Project/4D Mobile App Server.4DProject"
```

Compile it to `Components/` folder. A `4D Mobile App Server.4dbase` will be created with inside a `4D Mobile App Server.4dz`

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags](https://github.com/4d-for-ios/4D-Mobile-App-Server/tags) on this repository.

## License

See the [LICENSE][license-url] file for details

## Contributing

See [CONTRIBUTING][contributing-url] guide.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[code-shield]: https://img.shields.io/static/v1?label=language&message=4d&color=blue
[code-top]: https://img.shields.io/github/languages/top/4d-for-ios/4D-Mobile-App-Server.svg
[code-size]: https://img.shields.io/github/languages/code-size/4d-for-ios/4D-Mobile-App-Server.svg
[code-url]: https://developer.4d.com/
[release-shield]: https://img.shields.io/github/v/release/4d-for-ios/4D-Mobile-App-Server
[release-url]: https://github.com/4d-for-ios/4D-Mobile-App-Server/releases/latest
[license-shield]: https://img.shields.io/github/license/4d-for-ios/4D-Mobile-App-Server
[license-url]: LICENSE.md
[contributing-url]: CONTRIBUTING.md
