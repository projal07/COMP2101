#!/bin/bash

echo "FQDN: $(hostname)"
echo "Host Information: "
hostnamectl status | sed -n 1,9p 	#I'm using sed with -n option to print line 1-9 filtering the large output of hostnamectl
echo "IP Addresses: "
hostname -I | awk '{print$1" " $2" " $3}' # Here I'm bringing host IP address(Not Local) and printing just three ip in case of many ip address.
echo "Root Filesystem Status: "
df -h / 		#Here I'm using df with option -h to bring the disk usgage output in Human Readable Form of partition mounted on /
