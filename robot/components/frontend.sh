#!/bin/bash

echo "i am frontend"

COMPONENT=frontend
LOGFILE="/tmp/frontend.log"

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


echo -n "INSTALLING NGINX :"
 yum install nginx -y  &>> $LOGFILE
 stat $?
 
 echo -n "DOWNLOADING $COMPONENT :"
 curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"  &>> $LOGFILE 
 stat $?

echo -n "PERFORMING CLEANUP OF OLD $COMPONENT CONTENT :"
cd /usr/share/nginx/html
rm -rf *
stat $?

echo -n "COPYING DOWNLOADED $COMPONENT CONTENT:"
unzip /tmp/frontend.zip  &>> $LOGFILE
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?


echo -n "STARTING THE SERVICE :"
systemctl enable nginx &>> $LOGFILE
systemctl start nginx  &>> $LOGFILE
stat $?
