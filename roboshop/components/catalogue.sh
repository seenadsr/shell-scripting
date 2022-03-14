#!/bin/bash
source components/common.sh

print " Setting up catalouge YUM repo "
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - >> $LOG_FILE
StatCheck $? " Repo downloaded -  "

print " Installing nodejs  "
yum install nodejs gcc-c++ -y >>LOG_FILE
StatCheck $? " Installation nodejs - "

print " Adding application user roboshop "
id ${APP_USER} >>$LOG_FILE
if [ $? -ne 0 ];then
useradd ${APP_USER} >> $LOG_FILE
fi
StatCheck $? " Application user adding  - "

print " Download nodejs config file "
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" >>LOG_FILE
StatCheck $? "Downloading nodejs config files  - "

print " extract and configure nodejs"
cd /home/roboshop >>LOG_FILE && unzip -o /tmp/catalogue.zip >>LOG_FILE && mv catalogue-main catalogue >>LOG_FILE && cd /home/roboshop/catalogue >>LOG_FILE
StatCheck $? " nodejs configuration - "

print " npm installation "
npm install >>LOG_FILE
StatCheck $? " npm installation success "

print " Changing permission for application user"
chown -R ${APP_USER}:${APP_USER} /home/roboshop >>LOG_FILE
StatCheck $? " Permission changed - "
