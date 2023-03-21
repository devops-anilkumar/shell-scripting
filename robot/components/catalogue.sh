#!/bin/bash

echo "i am catalogue"

COMPONENT=catalogue
source components/common.sh #source is goin to load the file and you can call all of them as per your need

NODEJS                       #CALLING MODEJS FUNCTION

#source is a command to import and run the file







# LOGFILE="/tmp/$COMPONENT.log"
# APPUSER=roboshop

# #set -e
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

# echo -n "CONFIGURING NODEJS REPO :"
# curl --silent --location https://rpm.nodesource.com/setup_16.x |  bash -    &>>  $LOGFILE
# stat $?

# echo -n "INSTALLING NODEJS :"
# yum install nodejs -y   &>> $LOGFILE
# stat $?

# id $APPUSER   &>> $LOGFILE
# if [ $? -ne 0 ] ; then
#    echo -n " CREATING THE APPLICATION USER ACCOUNT :"
#    useradd $APPUSER    &>> $LOGFILE
# stat $?
# fi

# echo -n "DOWNLOADUING THE $COMPONENT :"
# curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
# stat $?

# echo -n "EXTRACTING THE $COMPONENT IN THE $APPUSER DIRECTORY :"
# cd /home/$APPUSER
# rm -rf /home/$APPUSER/$COMPONENT   &>> $LOGFILE
# unzip -o /tmp/$COMPONENT.zip    &>> $LOGFILE
# stat $?


# echo -n "CONFIGURING THE PERMISSIONS :"
# mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
# chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
# stat $?

# echo -n "INSTALLING $COMPONENT APPLICATION :"
# cd /home/$APPUSER/$COMPONENT/
# npm install    &>>$LOGFILE
# stat $?

# echo -n "UPDATING THE SYSTEMD FILES WITH DB DETAILS :"
# sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
# mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
# stat $?

# echo -n "STARTING THE $COMPONENT SERVICE :"
# systemctl daemon-reload       &>> $LOGFILE
# systemctl enable $COMPONENT   &>> $LOGFILE
# systemctl restart $COMPONENT     &>> $LOGFILE
# stat $?




