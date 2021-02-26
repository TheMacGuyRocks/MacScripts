#!/bin/bash

# ------------ Mount Teacher Resources  based on AD Group ------------ #
# ------------ Created by TheMacGuy - tom@themacguy.rocks ------------ #

# -------------- This Script relies on Native AD Binding ------------- #


#Define the Staff Resources UNC Path (\\myserver\MyShare$\directory)
smbUncPath="\\myserver\MyShare$\directory"

#Define Staff AD Group
staffGroup="All Staff"

# ---------------- YOU SHOULD NOT NEED TO MODIFY BELOW THIS LINE ----------------

# Do not run if user is the local admin
theUserName=$(/usr/bin/stat -f%Su /dev/console)

cleanSmbPath=$(echo $smbUncPath | tr '\' '/' )
noSpaces=$(echo $cleanSmbPath | sed 's/ /%20/')

# Do not run if user is the local admin
theUserName=$(/usr/bin/stat -f%Su /dev/console)

dscl /Local/Default -list Users | grep $USER &> /dev/null
if [ $? == 0 ]; then
	echo "nothing to be done"
else

	# Wait some time to allow the id command to work correctly
	/bin/sleep 3

	adGroups=$(/usr/bin/id -Gn $theUserName)
	/bin/unlink ~/Desktop/Teacher\ Resources

	# Teacher Resources. Check if user is a member of staff and if so put link on the desktop
	if [[ $adGroups =~ "$staffGroup" ]]; then
		/bin/mkdir -p ~/Network\ Resources
		/bin/mkdir -p ~/Network\ Resources/Teacher\ Resources
		/sbin/mount_smbfs "smb:/$noSpaces" ~/Network\ Resources/Teacher\ Resources
		/bin/ln -s ~/Network\ Resources/Teacher\ Resources ~/Desktop/Teacher\ Resources
	fi
fi

exit 0