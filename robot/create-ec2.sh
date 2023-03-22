#!/bin/bash

# this is a script created to launch EC2 servers and create the associated route53 record 

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' |sed -e 's/"//g')
echo "Ami ID is $AMI_ID "

echo -n "LAUNCHING THE INSTANCE WITH $AMI_ID AS AMI :"
aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro