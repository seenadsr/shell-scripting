#!/bin/bash

source components/common.sh

print "MongoDB YUM Repo setup"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo >>$LOG_FILE
StatCheck $? "MongoDB repository - "

print " MongoDB installation "
yum install -y mongodb-org >>$LOG_FILE
StatCheck $? " MongoDB Installation success"


print " starting and enabling mongodb services"
systemctl enable mongod >>$LOG_FILE && systemctl start mongod >>$LOG_FILE




