#!/bin/bash

# this is a script created to launch EC2 servers and create the associated route53 record
if [ -z "$1" ] ; then
    echo -e "\e[31m component name is requried \e[0m \t\t"
    echo -e "\t\t\t \e[32m sample usage is : $ bash create-ec2.sh user \e[0m"
    exit 1
fi

HOSTEDZONEID="Z01019823KGEEYKYEE9GQ"
COMPONENT=$1

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=awslab-security | jq ".SecurityGroups[].GroupId" | sed -e 's/"//g')
echo "Ami ID is $AMI_ID "

echo -n "LAUNCHING THE INSTANCE WITH $AMI_ID AS AMI :"
IPADDRESS=$(aws ec2 run-instances \
                     --image-id $AMI_ID  \
                     --instance-type t2.micro  \
                     --security-group-ids ${SGID}  \
                     --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
                     --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$COMPONENT}]" | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')
echo $IPADDRESS
sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${IPADDRESS}" robot/record.json > /tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONEID --change-batch file:///tmp/record.json | jq





