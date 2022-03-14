#!/bin/bash
source components/common.sh

print " Setting up catalouge YUM repo "
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - >> $LOG_FILE
StatCheck $? " Repo downloaded -  "

print " Installing nodejs  "
yum install nodejs gcc-c++ -y >>LOG_FILE
StatCheck $? " Installation nodejs - "

print " Adding application user roboshop and switch to roboshop"
useradd roboshop >> $LOG_FILE && su - roboshop >>LOG_FILE
StatCheck $? " Adding roboshop user and switching is - "

print " Download nodejs config file "
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" >>LOG_FILE
StatCheck $? "Downloading nodejs config files  - "

print " extract and configure nodejs"
cd /home/roboshop && unzip /tmp/catalogue.zip && mv catalogue-main catalogue & cd /home/roboshop/catalogue >>LOG_FILE
StatCheck $? " nodejs configuration - "

print " npm installation "
npm install >>LOG_FILE
StatCheck $? " npm installation success "