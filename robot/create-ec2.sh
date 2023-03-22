#!/bin/bash

# this is a script created to launch EC2 servers and create the associated route53 record 

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId')
echo "Ami ID is $AMI_ID "
