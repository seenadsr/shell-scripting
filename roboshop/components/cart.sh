#!/bin/bash
source components/common.sh

print " Setting up cart YUM repo "
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
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" >>$LOG_FILE
StatCheck $? "Downloading nodejs config files  - "

print "Cleaning old files "
rm -rf /home/${APP_USER}/cart >>$LOG_FILE
StatCheck $? " Old files cleanup -"

print " extract and configure nodejs"
cd /home/roboshop >>$LOG_FILE && unzip -o /tmp/cart.zip >>$LOG_FILE && mv cart-main cart >>$LOG_FILE && cd /home/roboshop/cart >>$LOG_FILE
StatCheck $? " nodejs configuration - "

print " npm installation "
npm install >>$LOG_FILE
StatCheck $? " npm installation success "

print " Changing permission for application user"
chown -R ${APP_USER}:${APP_USER} /home/roboshop >>$LOG_FILE
StatCheck $? " Permission changed - "

print "update redis and catalogue DNS name"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' /home/roboshop/user/systemd.service >>$LOG_FILE
sed -i -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' /home/roboshop/user/systemd.service >>$LOG_FILE
StatCheck $? " update redis and catalogue DNS name - "

print " Start systemd services "
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service >>$LOG_FILE && systemctl daemon-reload >>$LOG_FILE && systemctl start cart >>$LOG_FILE  && systemctl enable cart >>$LOG_FILE
StatCheck $? " services started "
