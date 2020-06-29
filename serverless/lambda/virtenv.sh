#!/bin/bash

# Check virtualenv is installed
if which apt-get >/dev/null 2>&1
then
	apt-get -y install virtualenv
elif which dnf >/dev/null 2>&1
then
	dnf -y install virtualenv
else
	yum -y install virtualenv
fi
