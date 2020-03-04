//%attributes = {}
C_COLLECTION:C1488($validEmailList;$invalidEmailList)
C_TEXT:C284($email)

  // List of Valid Email Addresses

$validEmailList:=New collection:C1472(\
"email@example.com";\
"firstname.lastname@example.com";\
"email@subdomain.example.com";\
"firstname+lastname@example.com";\
"email@123.123.123.123";\
"email@[123.123.123.123]";\
"\"email\"@example.com";\
"1234567890@example.com";\
"email@example-one.com";\
"_______@example.com";\
"email@example.name";\
"email@example.museum";\
"email@example.co.jp";\
"firstname-lastname@example.com";\
"very.unusual.”@”.unusual.com@example.com";\
"very.”(),:;<>[]”.VERY.”very@\\ \"very”.unusual@strange.example.com")


For each ($email;$validEmailList)
	
	ASSERT:C1129(isEmail ($email);"Invalid mail address : "+$email)
	
End for each 


  // List of Invalid Email Addresses

$invalidEmailList:=New collection:C1472(\
"plainaddress";\
"@example.com";\
"email@example")


For each ($email;$invalidEmailList)
	
	ASSERT:C1129(Not:C34(isEmail ($email));"Valid mail address : "+$email)
	
End for each 
