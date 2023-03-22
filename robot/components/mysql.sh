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

echo -n "GRAB $COMPONENT DEFAULT PASSWORD :"
DEFAULT_ROOT_PWS=$(sudo grep "temporary password" /var/log/mysqld.log | awk '{print $NF}')
stat $?

#this should only run for the first time or when the default password is not changed
echo "show databases;" | mysql -uroot -pRoboShop@1  &>> $LOGFILE
if [ $? -ne 0 ] ; then
    echo -n "PASWORD RESET OF ROOT USER :"
    mysql --connect-expired-password -uroot -p${DEFAULT_ROOT-PWS}
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT-PWS}  &>> $LOGFILE
    stat $?
fi

#Ensure you run this only when the password validation plugin exist
echo "show plugins;" | mysql -uroot -pRoboShop@1 | grep validate_password   &>> $LOGFILE
if [ $? -eq 0 ] ; then
    # echo -n "PASWORD RESET OF ROOT USER :"
    # mysql --connect-expired-password -uroot -p${DEFAULT_ROOT-PWS}
    # echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p${DEFAULT_ROOT-PWS}  &>> $LOGFILE
    # stat $?

   echo -n "UNINSTALLING PASWORD VALIDATION PLUGIN :"
   echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1  &>> $LOGFILE
   stat $?
fi



