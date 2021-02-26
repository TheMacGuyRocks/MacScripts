#!/bin/bash

# -----------------------  Mount SMB Home Path ----------------------- #
# ------------ Created by TheMacGuy - tom@themacguy.rocks ------------ #

# -------------- This Script relies on Native AD Binding ------------- #

# Mount Network Home Folder and Create Links

theUserName=$(/usr/bin/stat -f%Su /dev/console)
domainName=$(echo "show com.apple.opendirectoryd.ActiveDirectory" | scutil | grep "DomainNameFlat" | cut -d":" -f 2- | sed "s|^[ ]*||;s|[ ]*$||")

dscl /Local/Default -list Users | grep $USER &> /dev/null
if [ $? == 0 ]; then
    echo "Local User, skipping folder Run"
		MYSIDES remove all #Clears all items in the sidebar
		MYSIDES add Home file:///Users/$USER/ #Adds User Home
		MYSIDES add Documents file:///Users/$USER/Documents #Adds Documents
		MYSIDES add Desktop file:///Users/$USER/Desktop #Adds Desktop
		MYSIDES add Pictures file:///Users/$USER/Pictures #Adds Pictures
		MYSIDES add Movies file:///Users/$USER/Movies #Adds Movies
		MYSIDES add Applications file:///Applications #Adds Applications

else

	# Keep trying until the network home is mounted
	while [[ ! -d ~/MyNetworkHome/Documents ]]; do

	/bin/sleep 5

	# Read the user network home folder from Active Directory
	myHomeFolder=$(/usr/bin/dscl localhost -read /Active\ Directory/$domainName/All\ Domains/Users/$theUserName SMBHome | cut -d':' -f2-  | tr '\' '/' |  tr '\n' ' ' | cut -d' ' -f2- ) 
	noSpaces=$(echo $myHomeFolder | sed 's/ /%20/')

	myHomeFolderSMB=$(/bin/echo "$noSpaces")

	# Unlink any existing symbolic link and create the mount location folder if necessary
	/bin/unlink ~/MyNetworkHome
	mkdir -p ~/MyNetworkHome

	# Mount the network home folder
	/sbin/mount_smbfs $myHomeFolderSMB /Users/$theUserName/MyNetworkHome

	# If the relevant directories exist then create the symbolic links
	if [ -d ~/MyNetworkHome/Documents ] && [ -d ~/Documents ]; then
	mkdir ~/MyNetworkHome/Documents
	/bin/unlink ~/Documents/Network\ Documents
	/bin/ln -s ~/MyNetworkHome/Documents  ~/Documents/Network\ Documents
	fi

	if [ -d ~/MyNetworkHome/Movies ] && [ -d ~/Movies ]; then
	mkdir ~/MyNetworkHome/Movies
	/bin/unlink  ~/Movies/Network\ Movies
	/bin/ln -s ~/MyNetworkHome/Movies ~/Movies/Network\ Movies
	fi

	if [ -d ~/MyNetworkHome/Music ] && [ -d ~/Music ]; then
	mkdir ~/MyNetworkHome/Music
	/bin/unlink ~/Music/Network\ Music
	/bin/ln -s ~/MyNetworkHome/Music  ~/Music/Network\ Music
	fi

	if [ -d ~/MyNetworkHome/Pictures ] && [ -d ~/Pictures ]; then
	mkdir ~/MyNetworkHome/Pictures
	/bin/unlink ~/Pictures/Network\ Pictures
	/bin/ln -s ~/MyNetworkHome/Pictures  ~/Pictures/Network\ Pictures
	fi

	/bin/ln -s ~/MyNetworkHome ~/Desktop/Network\ Home
	sleep 5
		MYSIDES="/usr/local/bin/mysides"
		MYSIDES remove all #Clears all items in the sidebar
		MYSIDES add Home file:///Users/$theUserName/MyNetworkHome #Adds User Home
		MYSIDES add Documents file:///Users/$theUserName/MyNetworkHome/Documents #Adds Documents
		MYSIDES add Desktop file:///Users/$theUserName/MyNetworkHome/Desktop #Adds Desktop
		MYSIDES add Pictures file:///Users/$theUserName/MyNetworkHome/Pictures #Adds Pictures
		MYSIDES add Applications file:///Applications #Adds Applications

	done
fi

exit 0