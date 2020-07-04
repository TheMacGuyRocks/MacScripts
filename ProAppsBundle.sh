#!/bin/bash

# ------- Mac Sparse Bundle mounting script for Apple Pro Apps ------- #
# ----------- Created by Tom Pearce - tom@themacguy.rocks ------------ #

#Variables
loggedInUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }') #Gets content for variable to get the username

sparseDisk=".YourDrive.sparsebundle" #TheName of the sparsedisk (period . makes it hidden)
shortSparseDisk="YourDrive" #TheName of the sparsedisk without spaces. THIS IS ALSO HOW THE DRIVE WILL DISPLAY



#Skip redirection if user is 'Local'
#Otherwise you get broken links. It  provides a "bare metal" experience when logged on locally (Useful for admins)
dscl /Local/Default -list Users | grep $USER &> /dev/null
if [ $? == 0 ]; then
    echo "Local User, skipping folder redirection"
    if [ -e /usr/local/bin/mysides ]
		MYSIDES="/usr/local/bin/mysides"
		then
		$MYSIDES remove all #Clears all items in the sidebar
		$MYSIDES add Home file:///Users/$USER/ #Adds User Home (%username%)
		$MYSIDES add Documents file:///Users/$USER/Documents #Adds Documents
	   	$MYSIDES add Desktop file:///Users/$USER/Desktop #Adds Desktop
	   	$MYSIDES add Pictures file:///Users/$USER/Pictures #Adds Pictures
	    $MYSIDES add Movies file:///Users/$USER/Movies #Adds Movies
	    $MYSIDES add Applications file:///Applications #Adds Applications
	fi
else
	function lmv(){ [ -e $1 -a -e $2 ] && mv $1 $2 && ln -s $2/$(basename $1) $(dirname $1); }

	if [ ! -d ~/$sparseDisk ]; then #Does this sparsebundle exist?
		#If it Doesnt
	    hdiutil create -size 10g -type SPARSEBUNDLE -nospotlight -fs HFS+ -volname $shortSparseDisk ~/$sparseDisk #Create a 10gb Sparse Bundle named using the shortSparseDisk variable in ~/ (home)
		hdiutil attach -mountpoint ~/$shortSparseDisk ~/$sparseDisk #Mount the new sparsebundle
		sleep 1 #Gives it a little rest
		mkdir ~/$shortSparseDisk/Movies #Makes a new directory on the sparsebundle
		mkdir ~/$shortSparseDisk/Music #Makes a new directory in the sparsebundle
		sleep 1 #Gives it a little rest
	else 
		#If it does already exist
		hdiutil detach ~/$shortSparseDisk #Detatch it incase for somereason it's attached
		hdiutil compact ~/$sparseDisk -batteryallowed #Compact the existing Sparsebundle (and allowing it to happen on Battery too!)
		hdiutil attach -mountpoint ~/$shortSparseDisk ~/$sparseDisk #Mount the sparsebundle
		sleep 1 #Gives it a little rest
		mkdir ~/$shortSparseDisk/Movies #Incase somebody has deleted it, it tries to re-make the directory in the sparse bundle. It will silently fail if it exists already
		mkdir ~/$shortSparseDisk/Music #Incase somebody has deleted it, it tries to re-make the directory in the sparse bundle. It will silently fail if it exists already
		sleep 1 #Gives it a little rest
	fi

	MUSIC="/home/$loggedInUser/Music"
	MOVIES="/home/$loggedInUser/Movies"

	mkdir /home/$loggedInUser/Music/
	mkdir /home/$loggedInUser/Movies/


	file=""

	if [ "$(ls -A $MUSIC)" ]; then
		echo "$MUSIC IS NOT EMPTY"t
		mv /home/$loggedInUser/Music /home/$loggedInUser/Music_Old/
		ln -sFfh /home/$loggedInUser/$shortSparseDisk/Music ~/Music
	else
		echo "$MUSIC is EMPTY"
		mv /home/$loggedInUser/Music /home/$loggedInUser/Music_Old/
		ln -sFfh /home/$loggedInUser/$shortSparseDisk/Music ~/Music
	fi

	if [ "$(ls -A $MOVIES)" ]; then
		echo "$MOVIES IS NOT EMPTY"
		mv /home/$loggedInUser/Movies /home/$loggedInUser/Movies_Old/
		ln -sFfh /home/$loggedInUser/$shortSparseDisk/Movies ~/Movies
	else
		echo "$MOVIES is EMPTY"
		mv /home/$loggedInUser/Movies /home/$loggedInUser/Movies_Old/
		ln -sFfh /home/$loggedInUser/$shortSparseDisk/Movies ~/Movies
	fi

	# Script uses mysides ( https://github.com/mosen/mysides ) to clear the sidebar
	# Removes all sides and adds /Applications, User Desktop, Documents, Downloads, Music and Movies
	if [ -e /usr/local/bin/mysides ]
	MYSIDES="/usr/local/bin/mysides"
	then
	    $MYSIDES remove all
	    $MYSIDES add Documents file:///home/$loggedInUser/
	    $MYSIDES add Applications file:///Applications
	    $MYSIDES add Desktop file:///home/$loggedInUser/Desktop
	    $MYSIDES add Downloads file:///home/$loggedInUser/Downloads
	    $MYSIDES add Movies file:///home/$loggedInUser/Movies
	    $MYSIDES add Music file:///home/$loggedInUser/Music
	fi

fi

#End Tom's Bit

# Hides Tags in sidebar
defaults write com.apple.finder ShowRecentTags -bool FALSE     
# Hides External Drives on Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool TRUE
# Hides Server Mounts on Desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool FALSE
# Hides Shared section on SideBar
defaults write com.apple.finder SidebarSharedSectionDisclosedState -bool FALSE
# Sets Default Finder window to open at Computer showing root HD, connected external drives, and connected servers instead of Recents
defaults write com.apple.finder NewWindowTarget PfHm
defaults write com.apple.finder NewWindowTargetPath PfHm

