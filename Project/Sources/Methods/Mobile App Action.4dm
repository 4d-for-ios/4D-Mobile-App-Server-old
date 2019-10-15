//%attributes = {}
  /// # Mobile App Action (C_OBJECT)
  //: Utility method to return an utility object to apply action from `$1` context in `On Mobile App Action` database method.
/*:
## Overview

in `On Mobile App Action`

```4d
// Create an object with formula
$action:=Mobile App Action($1) // $1 Informations provided by mobile application

Case of
      //________________________________________
    : ($action.name="purgeAll") // Purge all, action scope is table/dataclass

      $dataClass:=$action.getDataClass()
      // Insert here the code to purge all entities of this dataClass.

      //________________________________________
    : ($action.name="add") // Add a new entitys

      $book:=$action.newEntity()
      $status:=$book.save()
      //________________________________________
    : ($action.name="rate") // Rate a book, action scope is entity

      $book:=$action.getEntity()
      // Insert here the code for the action "Rate and Review" the book

End case
````

*/

$0:=New object:C1471("request";$1;\
"name";$1.action;\
"_is";"mobileAppAction";\
"getDataClass";Formula:C1597(Mobile App Action GetDataClass (This:C1470.request));\
"getEntity";Formula:C1597(Mobile App Action GetEntity (This:C1470.request));\
"newEntity";Formula:C1597(Mobile App Action NewEntity (This:C1470.request))\
)
