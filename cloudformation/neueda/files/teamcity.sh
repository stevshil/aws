#!/bin/bash

yum -y erase java-1.7.0-openjdk
yum -y install java-1.8.0-openjdk
if lsblk | grep xvdd
then
	mkdir /opt/TeamCity
	if file -sL /dev/xvdd1 | grep -v filesystem
	then
		echo -e 'n\np\n1\n\n\nw\nq\n' | fdisk /dev/xvdd
		mkfs -t ext3 /dev/xvdd1
	fi
fi
mount -t ext3 /dev/xvdd1 /opt/TeamCity
cd /tmp
[[ ! -d /opt/TeamCity/logs ]] && wget -q https://download.jetbrains.com/teamcity/TeamCity-2017.1.1.tar.gz
cd /opt
if df -h | grep xvdd1
then
	[[ ! -d /opt/TeamCity/logs ]] && tar xvf /tmp/TeamCity-2017.1.1.tar.gz
	[[ -e /opt/TeamCity/conf ]] && rm /tmp/TeamCity-2017.1.1.tar.gz || echo 'No tar file'
	[[ ! -d /opt/TeamCity/logs ]] && mkdir /opt/TeamCity/logs && touch /opt/TeamCity/logs/catalina.out
	echo 'mount -t ext3 /dev/xvdd1 /opt/TeamCity' >>/etc/rc.local
	echo '/opt/TeamCity/bin/startup.sh' >>/etc/rc.local
	/opt/TeamCity/bin/startup.sh
fi

