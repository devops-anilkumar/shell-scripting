#!/bin/bash

echo "i am frontend"

COMPONENT=frontend
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


echo -n "INSTALLING NGINX :"
 yum install nginx -y  &>> $LOGFILE
 stat $?
 
 echo -n "DOWNLOADING $COMPONENT :"
 curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"  &>> $LOGFILE 
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

for component in catalogue cart user shipping payment; do
     echo -n "updating the proxy details in the reverse proxy file :"
     sed -i "/$component/s/localhost/$component.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
done

echo -n "STARTING THE SERVICE :"
systemctl enable nginx &>> $LOGFILE
systemctl restart nginx  &>> $LOGFILE
stat $?
