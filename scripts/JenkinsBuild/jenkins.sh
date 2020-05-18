#!/bin/bash

# yum -y update

# This version installs Jenkins
# Adds the admin user with password secret from XML template
# Addes a single job through the API

# Plugin list
cat >/tmp/pluginlist <<_EOF_
cloudbees-folder
configuration-as-code
antisamy-markup-formatter
build-timeout
credentials-binding
timestamper
ws-cleanup
workflow-aggregator
github-branch-source
pipeline-github-lib
pipeline-stage-view
git
github
git-parameter
pipeline
pipeline-build-step
pipeline-milestone-step
pipeline-model-definition
maven
ssh-slaves
matrix-auth
pam-auth
ldap
email-ext
mailer
_EOF_

# Check if Jenkins is already running
if rpm -qa | grep jenkins >/dev/null 2>&1
then
	service jenkins stop >/dev/null 2>&1
	>/var/log/jenkins/jenkins.log
fi

yum -y install java wget
if [[ ! -d /etc/yum.repos.d/jenkins.repo ]]
then
	wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
	rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
	yum -y install jenkins
fi

# Extract a previous base configuration
cd /var/lib
if [[ ! -e /tmp/jenkins-2.235.tgz ]]
then
	wget https://www.therapypages.com/jenkins-2.235.tgz -O /tmp/jenkins-2.235.tgz
fi

tar xvf /tmp/jenkins-2.235.tgz

# Start jenkins to get the directories
echo "Starting Jenkins for the first time"
service jenkins start
echo "Waiting for Jenkins"
until grep "Jenkins is fully up and running" /var/log/jenkins/jenkins.log >/dev/null 2>&1
do
	echo -n "."
	sleep 15
done
echo ""

# Install plugins
if [[ ! -e /tmp/batch-install-jenkins-plugins.sh ]]
then
	wget https://raw.githubusercontent.com/hgomez/devops-incubator/master/forge-tricks/batch-install-jenkins-plugins.sh -O /tmp/batch-install-jenkins-plugins.sh
	chmod 755 /tmp/batch-install-jenkins-plugins.sh
fi

/tmp/batch-install-jenkins-plugins.sh --plugins /tmp/pluginlist --plugindir /var/lib/jenkins/plugins

# Restart to initialise plugins
service jenkins stop
# Empty log to check for running
>/var/log/jenkins/jenkins.log
service jenkins start

echo "Waiting for Jenkins"
until grep "Jenkins is fully up and running" /var/log/jenkins/jenkins.log >/dev/null 2>&1
do
	echo -n "."
	sleep 15
done
echo ""

#echo "Creating first job"
#cd /vagrant/files
#./createJob hello_world

#systemctl restart jenkins.service
# service jenkins start
