#!/bin/bash

echo "i am redis"

COMPONENT=redis

source components/common.sh

#LOGFILE="/tmp/$COMPONENT.log"
# set -e
# #validating wether the executed user is root user or not
# ID=$(id -u)
# if [ "$ID" -ne 0 ] ; then 
#    echo -e "\e[31m you should excute this script as a root user or with sudo as a prefix \e[0m"  
#    exit 1
# fi

# stat() {
# if [ $1 -eq 0 ] ; then
#    echo -e "\e[32m success \e[0m"
# else
#    echo -e "\e[31m failure \e[0m"
#    exit 2
# fi
# }

echo -n "CONFIGURING $COMPONENT REPO :"
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo   &>>  $LOGFILE
stat $?

echo -n "INSTALLING $COMPONENT SERVER :"
yum install redis-6.2.11 -y     &>> $LOGFILE
stat $?

echo -n "UPDATING $COMPONENT VISIBILITY :"
sed -i -e's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i -e's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
stat $?

echo -n "PERFORMING DAEMON-RELOAD :"
systemctl daemon-reload   &>> $LOGFILE
systemctl enable $COMPONENT  &>>  $LOGFILE
systemctl restart $COMPONENT  &>> $LOGFILE
stat $?