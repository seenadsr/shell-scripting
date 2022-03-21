#!/bin/bash

if [ -z $1 ];then
  echo -e "\e[31mInstance name to be specified\e[0m"
  exit 1
fi
COMPONENT=$1
AMI_ID=$(aws ec2 describe-images --filter Name=name,Values=Centos-7-DevOps-Practice --query 'Images[].ImageId' --output text)
SG_ID=$(aws ec2 describe-security-groups --filter "Name=group-name,Values=launch-wizard-3"|jq ."SecurityGroups[].GroupId"|sed -e 's/"//g')

PRIVATE_IP=$(aws ec2 run-instances \
--image-id ${AMI_ID} \
--instance-type t2.micro \
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
--security-group-ids ${SG_ID} \
--instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
|jq ."Instances[].PrivateIpAddress" |sed -e 's/"//g')

sed -e 's/PRIVATE_IP/${PRIVATE_IP}' -e 's/COMPONENT/${COMPONENT}' sample.json >/tmp/record.json
