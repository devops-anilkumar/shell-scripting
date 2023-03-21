#!/bin/bash

echo "i am catalogue"

COMPONENT=catalogue
LOGFILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

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

echo -n "CONFIGURING NODEJS REPO :"
curl --silent --location https://rpm.nodesource.com/setup_16.x |  bash -    &>>  $LOGFILE
stat $?

echo -n "INSTALLING NODEJS :"
yum install nodejs -y   &>> $LOGFILE
stat $?

echo -n " CREATING THE APPLICATION USER ACCOUNT :"
useradd $APPUSER    &>> $LOGFILE
stat $?

echo -n "DOWNLOADUING THE $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip"
stat $?

echo -n "EXTRACTING THE $COMPONENT IN THE $APPUSER DIRECTORY :"
cd /home/roboshop
unzip -O /tmp/catalogue.zip    &>> $LOGFILE
stat $?


# $ mv catalogue-main catalogue
# $ cd /home/roboshop/catalogue
# $ npm install



