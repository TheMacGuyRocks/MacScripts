#!/bin/bash
#This script is useful for updating a Mac's name via Jamf Pro. This ensures the 'Sharing Name' and Hostname are syncronised. Useful if you then use information such as $HostName for a login banner

yourResetPolicy="myResetEvent" #Create a policy that resets the computer name set a 'Custom Event' trigger for example 'resetComputerName'

jamf policy -event $yourResetPolicy -verbose

# get Computer Name
computerName=$( /usr/sbin/scutil --get ComputerName )
echo "Computer Name: $computerName"

# create network name using only alphanumeric characters and hyphens for spaces
networkName=$( /usr/bin/sed -e 's/ /-/g' -e 's/[^[:alnum:]-]//g' <<< "$computerName" )
echo "Network Name: $networkName"

# set hostname and local hostname
/usr/sbin/scutil --set HostName "$networkName"
/usr/sbin/scutil --set LocalHostName "$networkName"

exit 0
