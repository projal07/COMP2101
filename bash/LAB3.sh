#!/bin/bash

# Checking if lxd package is installed on the system or not
which lxd>/dev/null

# using if statement to install lxd if necessary
if [ $? -eq 0 ];then
	echo "LXD is already installed in your system"
else
	# Installing lxd in the system
	echo -e "lxd package is not installed in your system.\nNow installing lxd in your system. You may need to enter your password"
	sudo snap install lxd

	# for exit if the command fails
	if [ $? -ne 0 ];then
		echo "Got some error installing Lxd. Exiting now"
		exit 1
	fi
fi

# First checking if the interface is present or not
ip addr | grep lxdbr>/dev/null
if [ $? -eq 0 ];then
	echo "Interface exists. Moving on to the next step"
else
	lxd init --auto
	sleep 15

	# if this command fails then creating a exit status
	if [ $? -ne 0 ];then
		echo "Something went wrong. Exiting now"
		exit 1
	fi
fi

# Checking if the container already exists
lxc list | grep -q COMP2101-S22
if [ $? -ne 0 ];then
	# Launching the container
	lxc launch ubuntu:22.04 COMP2101-S22
else
	echo "COMP2101-S22 container exists. Moving to Next step now"
fi

# Get the IP address of the container
ip=$(lxc info COMP2101-S22 | awk '/inet:/ { print $2 }' | cut -d '/' -f 1 | head -n1)

# Checking if the IP address for the container is already present in /etc/hosts
grep 'COMP2101-S22' /etc/hosts >/dev/null
if [ $? -ne 0 ];then
	echo "$ip COMP2101-S22" | sudo tee -a /etc/hosts >/dev/null
else
	echo "IP address for COMP2101-S22 already in /etc/hosts."
fi

# Checking if Apache2 is already installed on the container
lxc exec COMP2101-S22 -- which apache2 > /dev/null
if [ $? -ne 0 ]; then
	# Installing Apache2 on the container
	sudo lxc exec COMP2101-S22 -- sudo apt install apache2 -y >/dev/null 2>&1 
	if [ $? -eq 0 ];then
		echo "You have completely installed Apache2."
	fi
else
	echo "Apache2 already exists on your container. Moving to the next step."
fi

# Installing curl
sudo apt install curl -y >/dev/null

# Retrieving the website
curl http://COMP2101-S22 >/dev/null
if [ $? -eq 0 ];then
	echo "Congratulations! You have successfully retrieved the website. Lab Done."
else
	echo "Failure in retrieving website."
fi

