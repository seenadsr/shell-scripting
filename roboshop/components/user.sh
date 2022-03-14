#!/bin/bash
source components/common.sh

print " Setting up user YUM repo "
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - >> $LOG_FILE
StatCheck $? " Repo downloaded -  "

print " Installing nodejs  "
yum install nodejs gcc-c++ -y >>$LOG_FILE
StatCheck $? " Installation nodejs - "

print " Adding application user roboshop "
id ${APP_USER} >>$LOG_FILE
if [ $? -ne 0 ];then
useradd ${APP_USER} >> $LOG_FILE
fi
StatCheck $? " Application user adding  - "

print " Download nodejs config file "
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" >>$LOG_FILE
StatCheck $? "Downloading nodejs config files  - "

print "Cleaning old files "
rm -rf /home/${APP_USER}/user >>$LOG_FILE
StatCheck $? " Old files cleanup -"

print " extract and configure nodejs"
cd /home/roboshop >>$LOG_FILE && unzip -o /tmp/user.zip >>$LOG_FILE && mv user-main user >>$LOG_FILE && cd /home/roboshop/user >>$LOG_FILE
StatCheck $? " nodejs configuration - "

print " npm installation "
npm install >>$LOG_FILE
StatCheck $? " npm installation success "

print " Changing permission for application user"
chown -R ${APP_USER}:${APP_USER} /home/roboshop >>$LOG_FILE
StatCheck $? " Permission changed - "

print "update mnagodb and redis DNS name"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/user/systemd.service >>$LOG_FILE
sed -i -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' /home/roboshop/user/systemd.service >>$LOG_FILE
StatCheck $? " MangoDB & redis DNS name updated - "

print " Start systemd services "
mv /home/roboshop/user/systemd.service /etc/systemd/system/catalogue.service >>$LOG_FILE && systemctl daemon-reload >>$LOG_FILE && systemctl start user >>$LOG_FILE  && systemctl enable user >>$LOG_FILE
StatCheck $? " services started "
