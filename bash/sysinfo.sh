#!/bin/bash

#First We are creating variable.
Hostname=$(hostname -f)
Os_name_version=$(hostnamectl status| sed -n 's/^Operating System: //p')
IP=$(ip route | head -n1 | awk '{print$3}')
root_space=$(df -h / | tail -n 1 | awk '{print$3}')
#Now we are using cat to write in the end of file and using the above variable for required output
cat << EOF

Report for $(hostname)
======================
FQDN: $Hostname
Operating System name and version: $Os_name_version
Ip Address: $IP
Root Filesystem Free Space: $root_space
======================

EOF
