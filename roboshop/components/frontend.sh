#!/bin/bash
source components/common.sh
print "Installing nginx"
yum install nginx -y >>$LOG_FILE
StatCheck $? "Nginx Installation - "

print "Copying frontend config files"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >> $LOG_FILE
StatCheck $? "Curl copy - "

print " cleaning up old-files"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
StatCheck $? "cleaning up files -"


cd /usr/share/nginx/html >>$LOG_FILE
print "extracting files "
unzip /tmp/frontend.zip >>$LOG_FILE && mv frontend-main/* . >>$LOG_FILE && mv static/* . >>$LOG_FILE
StatCheck $? "extracting files - "


print " Configuring roboshop files"
mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$LOG_FILE
sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf >>$LOG_FILE
StatCheck $? "Configuring roboshop - "


print "starting nginx services"
systemctl restart nginx >>$LOG_FILE && systemctl enable nginx >>$LOG_FILE && systemctl status nginx|grep active >>$LOG_FILE
StatCheck $? " Nginx status - "