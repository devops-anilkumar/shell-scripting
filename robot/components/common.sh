

LOGFILE="/tmp/$COMPONENT.log"
APPUSER=roboshop

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

CREATE_USER(){
    id $APPUSER   &>> $LOGFILE
if [ $? -ne 0 ] ; then
   echo -n " CREATING THE APPLICATION USER ACCOUNT :"
   useradd $APPUSER    &>> $LOGFILE
stat $?
fi
}

DOWNLOAD_AND_EXTRACT(){
    echo -n "DOWNLOADUING THE $COMPONENT :"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/stans-robot-project/$COMPONENT/archive/main.zip" &>> $LOGFILE
stat $?

echo -n "EXTRACTING THE $COMPONENT IN THE $APPUSER DIRECTORY :"
cd /home/$APPUSER
rm -rf /home/$APPUSER/$COMPONENT   &>> $LOGFILE
unzip -o /tmp/$COMPONENT.zip    &>> $LOGFILE
stat $?


echo -n "CONFIGURING THE PERMISSIONS :"
mv /home/$APPUSER/$COMPONENT-main /home/$APPUSER/$COMPONENT
chown -R $APPUSER:$APPUSER /home/$APPUSER/$COMPONENT
stat $?
}

NPM_INSTALL(){
    echo -n "INSTALLING $COMPONENT APPLICATION :"
    cd /home/$APPUSER/$COMPONENT/
    npm install    &>>$LOGFILE
    stat $?
}

CONFIG_SVC(){
    echo -n "UPDATING THE SYSTEMD FILES WITH DB DETAILS :"
    sed -i -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/$APPUSER/$COMPONENT/systemd.service
    mv /home/$APPUSER/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
    stat $?

    echo -n "STARTING THE $COMPONENT SERVICE :"
    systemctl daemon-reload      &>> $LOGFILE
    systemctl enable $COMPONENT   &>> $LOGFILE
    systemctl restart $COMPONENT  &>> $LOGFILE
    stat $?
}


MVN_PACKAGE(){
     echo -n "CREATING $COMPONENT PACKAGE :"
     cd /home/$APPUSER/$COMPONENT/
     mvn clean package   &>>$LOGFILE
     mv target/shipping-1.0.jar shipping.jar
     stat $?
}


PYTHON() {
    echo -n "INSTALLING PYTHON AND DEPENDANCIES :"
    yum install python36 gcc python3-devel -y  &>> $LOGFILE
    stat $?

    # CALLING CREATE_USER FUNCTION
    CREATE_USER

    # CALLING DOWNLOAD_AND_EXTRACT FUNCTION
    DOWNLOAD_AND_EXTRACT
  
    echo -n "INSTALLING $COMPONENT :"
    cd /home/$APPUSER/$COMPONENT
    pip3 install -r requirements.txt   &>> $LOGFILE
    stat $?

    USERID=$(id -u roboshop)
    GROUPID=$(id -g roboshop)
    echo -n "UPDATING $COMPONENT.ini FILE :"
    sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}"  /home/$APPUSER/$COMPONENT/$COMPONENT.ini
    stat $? 

    # CALLING CONFIG_SVC FUNCTION
    CONFIG_SVC

}

JAVA(){
      echo -n "INSTALLING MAVEN :"
      yum install maven -y &>> $LOGFILE
      stat $?
      # CALLING CREATE_USER FUNCTION
      CREATE_USER

      # CALLING DOWNLOAD_AND_EXTRACT
      DOWNLOAD_AND_EXTRACT

      # CALLING MAVEN_PACKAGE FUNCTION
      MVN_PACKAGE
       
      #CALLING CONFIG_SVC FUNCTION
      CONFIG_SVC

}


NODEJS(){
    echo -n "CONFIGURING NODEJS REPO :"
    curl --silent --location https://rpm.nodesource.com/setup_16.x |  bash -    &>>  $LOGFILE
    stat $?

    echo -n "INSTALLING NODEJS :"
    yum install nodejs -y   &>> $LOGFILE
    stat $?
    # CALLING CREATE USER FUNCTION
    CREATE_USER

    # CALLING DOWNLOAD_AND_EXTRACT
    DOWNLOAD_AND_EXTRACT

    # CALLING NPM_INSTALL
    NPM_INSTALL

    # CALLING CONFIG_SVC
    CONFIG_SVC

    # CALLING CONFIG_SVC
    CONFIG_SVC

}