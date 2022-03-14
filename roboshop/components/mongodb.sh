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
systemctl enable mongod >>$LOG_FILE && systemctl restart mongod >>$LOG_FILE
StatCheck $? " service starting is -  "

print " Download the schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" >>LOG_FILE
StatCheck $? " Downloading  schema - "

print " Extracting Schema"
cd /tmp >>LOG_FILE && unzip -o mongodb.zip >>LOG_FILE && cd mongodb-main >>LOG_FILE
StatCheck $? "Extracting schema - "

print "Load the schema "
mongo < catalogue.js >>LOG_FILE && mongo < users.js >>LOG_FILE
StatCheck $? " loading Schema - "



