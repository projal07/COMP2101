#!/bin/bash

echo "FQDN: $(hostname)"
echo "Host Information: "
hostnamectl status | sed -n 1,9p 	#I'm using sed with -n option to print line 1-9 filtering the large output of hostnamectl
echo "IP Addresses: "
hostname -I | awk '{print$1" " $2" " $3}'
echo "Root Filesystem Status: "
df -h /
