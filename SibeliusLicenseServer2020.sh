#!/bin/bash
#hostname="mysibelius.mydomain.domain"
hostname="Your Sibelius License Server FQDN"

mkdir -p "/Library/Application Support/Avid/Sibelius/_manuscript"

touch "/Library/Application Support/Avid/Sibelius/_manuscript/LicenceServerInfo"

echo "$hostname:7312">"/Library/Application Support/Avid/Sibelius/_manuscript/LicenceServerInfo"
sudo defaults write /Library/LaunchAgents/com.avid.ApplicationManager.plist RunAtLoad -boolean false
exit