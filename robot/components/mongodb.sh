#!/bin/bash

echo "i am mongodb"

COMPONENT=mongodb
LOGFILE="/tmp/$COMPONENT.log"

set -e
#validating wether the executed user is root user or not
ID=$(id -u)
if [ "$ID" -ne 0 ] ; then 
   echo -e "\e[31m you should excute this script as a root user or with sudo as a prefix \e[0m"  
   exit 1
fi

stat() {
if [ $1 -eq 0 ] ; then
   echo -e "\e[32m success \e[0m"
else
   echo -e "\e[31m failure \e[0m"
   exit 2
fi
}

echo -n "CONGIGURING $COMPONENT REPO :"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo 
stat $?

echo -n "INSTALLING $COMPONENT :"
yum install -y mongodb-org &>> $LOGFILE
stat $?

echo -n "STARTING $COMPONENT :"
systemctl enable mongod   &>> $LOGFILE
systemctl start mongod    &>> $LOGFILE
stat $?


echo -n "UPDATING $COMPONENT VISIBILITY :"
sed -i -e's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?


echo -n "PERFORMING DAEMON-RELOAD :"
systemctl daemon-reload &>> $LOGFILE
systemctl restart mongod &>> $LOGFILE
stat $?

echo -n "DOWNLOADING $COMPONENT SCHEMA :"
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "EXTRACTING $COMPONENT SCHEMA :"
cd /tmp
unzip -o mongodb.zip   &>> $LOGFILE 
stat $?

echo -n "INJECTING SCHEMA :"
cd mongodb-main
mongo < catalogue.js   &>> $LOGFILE
mongo < users.js       &>> $LOGFILE
stat $?