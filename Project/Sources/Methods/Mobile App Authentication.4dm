//%attributes = {"shared":true,"preemptive":"capable"}
  /// # Mobile App Authentication (C_OBJECT)
  //: Utility method to return an utility object for authentication from `$1` context in `On Mobile App Authentication` database method.

$0:=New object:C1471("request";$1;\
"_is";"mobileAppAuthentication";\
"getAppID";Formula:C1597(This:C1470.request.team.id+"."+This:C1470.request.application.id);\
"getSessionFile";Formula:C1597(Folder:C1567(fk mobileApps folder:K87:18).folder(This:C1470.getAppID()).file(This:C1470.request.session.id));\
"getSessionObject";Formula:C1597(Mobile App Session Object (This:C1470.getSessionFile()))\
)