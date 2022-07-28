#!/bin/bash

# ---------------------  Mount Student Resources --------------------- #
# ------------ Created by TheMacGuy - tom@themacguy.rocks ------------ #

# -------------- This Script relies on Native AD Binding ------------- #


#Define the Student Resources UNC Path (\\myserver\MyShare$\directory)
smbUncPath="\\myserver\MyShare$\directory"

# Do not run if user is the local admin
theUserName=$(/usr/bin/stat -f%Su /dev/console)

cleanSmbPath=$(echo $smbUncPath | tr '\' '/' )
noSpaces=$(echo $cleanSmbPath | sed 's/ /%20/')

dscl /Local/Default -list Users | grep $USER &> /dev/null
if [ $? == 0 ]; then
else

# Remove existing link folders
/bin/unlink ~/Desktop/Student\ Resources

/bin/mkdir -p ~/Network\ Resources
/bin/mkdir -p ~/Network\ Resources/Student\ Resources
/sbin/mount_smbfs "smb:/$noSpaces" ~/Network\ Resources/Student\ Resources
sleep 2
/bin/ln -s ~/Network\ Resources/Student\ Resources ~/Desktop/Student\ Resources

fi

exit 0
