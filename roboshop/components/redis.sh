#!/bin/bash

source components/common.sh
print " Setting up redis YUM Rep "
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo >>$LOG_FILE
StatCheck $? "Redis YUM repository setup - "

print " Install redis"
yum install redis -y >>$LOG_FILE
StatCheck $? "installation of redis - "

print " Update listen address "
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf >>$LOG_FILE && sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf >>$LOG_FILE
StatCheck $? "Update listen address"

print " start redis database"
systemctl enable redis >>$LOG_FILE && systemctl start redis >>$LOG_FILE
StatCheck $? " started services - "