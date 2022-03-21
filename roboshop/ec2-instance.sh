#!/bin/bash

AMI_ID=$(aws ec2 describe-images --filter Name=name,Values=Centos-7-DevOps-Practice --query 'Images[].ImageId' --output text)
aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro