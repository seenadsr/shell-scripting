#!/bin/bash

if [ -z $1 ];then
  echo -e "\e{31mInstance name to be specified\e[0m"
  exit 1
fi
COMPONENT=$1
AMI_ID=$(aws ec2 describe-images --filter Name=name,Values=Centos-7-DevOps-Practice --query 'Images[].ImageId' --output text)
aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro --tag-specifications 'ResourceType=instance,Tags=[{Key=name,Value=${COMPONENT}}]'