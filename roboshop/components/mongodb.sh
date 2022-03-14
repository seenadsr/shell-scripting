#!/bin/bash

source components/common.sh

print "MongoDB YUM Repo setup"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
StatCheck $? "MongoDB repository - "

print " MongoDB installation "
yum install -y mongodb-org
StatCheck $? " MongoDB Installation success"


print " starting and enabling mongodb services"
systemctl enable mongod
systemctl start mongod



