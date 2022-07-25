#!/bin/bash

## Turn on Remote Desktop Sharing, allow access for all users, and enable the menu extra:
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -allUsers -privs -all -clientopts -setmenuextra -menuextra no

## Restart the ARD Agent and helper:
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent

exit 0