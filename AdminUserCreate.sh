#!/bin/bash

#Uncomment if using independently
#username=theusername
#password="password1"

#Ensures unique ID is next available
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
USERID=$((MAXID+1))

sudo dscl . -create /Users/$username
sudo dscl . -create /Users/$username UserShell /bin/bash
sudo dscl . -create /Users/$username RealName $username 
sudo dscl . -create /Users/$username UniqueID $USERID
sudo dscl . -create /Users/$username PrimaryGroupID 20
sudo dscl . -create /Users/$username NFSHomeDirectory /Users/$username
sudo dscl . -passwd /Users/$username $password 

#Comment to make make standard user
sudo dscl . -append /Groups/admin GroupMembership $username

exit