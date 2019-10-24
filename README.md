[![pipeline status](https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/badges/master/pipeline.svg)](https://gitlab-4d.private.4d.fr/qmobile/4d-mobile-app-server/commits/master)

# 4D Mobile App Server

Utility methods to improve the 4D Mobile App backend coding.

##  Contents ##
- [Action](#Action)
- [Authentication](#Authentication)

# Action ##

Utility methods to get dataClass or entity to apply action when inside `On Mobile App Action` database method.

```swift
	// Create an object with formula
$action:=Mobile App Action($1) // $1 Informations provided by mobile application

Case of
      //________________________________________
    : ($action.name="purgeAll") // Purge all, action scope is table/dataclass

      $dataClass:=$action.getDataClass()
      // Insert here the code to purge all entities of this dataClass.

      //________________________________________
    : ($action.name="add") // Add a new entity

      $book:=$action.newEntity()
      $status:=$book.save()

      // if any book collection, add to it
      $result:=$action.link()
      If ($result.success)
        $status:=$result.save()
      End if
      $book:=$result.entity

      // get parent to control the number of books in the collection
      $parent:=$action.getParent()

      //________________________________________
    : ($action.name="rate") // Rate a book, action scope is entity

      $book:=$action.getEntity()
      // Insert here the code for the action "Rate and Review" the book

      //________________________________________
    : ($action.name="removeFromCollection") // remove

      $result:=$action.unlink()
      If ($result.success)
        $status:=$result.save()
      End if
      $book:=$result.entity

      //________________________________________
    : ($action.name="drop") // Drop an entity

      $status:=$action.dropEntity()

End case
```

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
See [CONTRIBUTING.md](CONTRIBUTING.md)
