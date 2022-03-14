#!/bin/bash

source components/common.sh

print "MongoDB YUM Repo setup"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo >>$LOG_FILE
StatCheck $? "MongoDB repository - "

print " MongoDB installation "
yum install -y mongodb-org >>$LOG_FILE
StatCheck $? " MongoDB Installation - "

print "Configuring mongoDB lister address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $? " MongoDB lister address configure - "

print " starting and enabling mongodb services"
systemctl enable mongod >>$LOG_FILE && systemctl start mongod >>$LOG_FILE
StatCheck $? " service starting is -  "




