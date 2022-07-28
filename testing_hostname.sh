NUM=$(osascript -e 'display dialog "Please enter the HOSTNAME:" default answer "" with title "Define Hostname"  
set the FloatNumber to text returned of the result
return FloatNumber')