#!/bin/bash

echo "i am mysql"

COMPONENT=mysql
source components/common.sh


echo -n "CONFIGURING $COMPONENT REPO :"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/stans-robot-project/mysql/main/mysql.repo  &>> $LOGFILE
stat $?

echo -n "INSTALLING $COMPONENT :"
yum install mysql-community-server -y  &>> $LOGFILE
stat $?

echo -n "ENABLING $COMPONENT :"
systemctl enable mysqld  &>> $LOGFILE
systemctl start mysqld    &>>  $LOGFILE
stat $?

