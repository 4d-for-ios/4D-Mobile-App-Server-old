[![pipeline status](https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/badges/master/pipeline.svg)](https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/commits/master)

# 4D Mobile App Server

Utility methods to improve the 4D Mobile App backend coding.

##  Contents ##
- [Action](#Action)

# Action ##

Utility methods to get dataClass or entity to apply action when inside `On Mobile App Action` database method.

```swift
$request:=$1  // Informations provided by mobile application
$response:=New object("success";False)  // Informations returned to mobile application

Case of
      //________________________________________
    : ($request.action="rate") // Rate a book, action scope is entity

      $book:=Mobile App Action GetEntity ($request)
      // Insert here the code for the action "Rate and Review" the book

      //________________________________________
    : ($request.action="purgeAll") // Purge all, action scope is table/dataclass

      $dataClass:=Mobile App Action GetDataClass($request)
      // Insert here the code to purge all entities of this dataClass.

      //________________________________________
    : ($request.action="add") // Add a new entitys

      $book:=Mobile App Action NewEntity ($request)
      $status:=$book.save()

End case

$0:=response
```

# Contributing #
See [CONTRIBUTING.md](CONTRIBUTING.md)
