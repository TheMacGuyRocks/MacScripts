#!/bin/bash

#Uncomment if using independently
#username=theusername
#password="password1"

#Ensures unique ID is next available
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))

dscl . -create /Users/$username
dscl . -create /Users/$username UserShell /bin/bash
dscl . -create /Users/$username RealName $username 
dscl . -create /Users/$username UniqueID $USERID
dscl . -create /Users/$username PrimaryGroupID 20
dscl . -create /Users/$username NFSHomeDirectory /Users/$username
dscl . -passwd /Users/$username $password 

#Uncomment to make admin
#dscl . -append /Groups/admin GroupMembership $username
