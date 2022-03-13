#!/bin/bash

StatCheck() {
  if [ $1 = 0 ];then
    echo -e "$2 \e[36mSuccess\e[0m"
  else
    echo -e "$2 \e[32mFailed\e[0m"
    exit 2
  fi
}
USER_ID=`whoami`
if [ $USER_ID = 'root' ];then
  echo "$USER_ID proceeding installation"
else
  echo -e " \e[31mInstallation should run with only root\e[0m ";exit 2
fi

LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE
print() {
  echo "================$1=============" >>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

space () {
  echo "  "
  echo "======================================"
}
print "Installing nginx"
yum install nginx -y >>$LOG_FILE
StatCheck $? "Nginx Installation - "
space
print "Copying frontend config files"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >> $LOG_FILE
StatCheck $? "Curl copy - "
space
print " cleaning up old-files"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
StatCheck $? "cleaning up files -"
space

cd /usr/share/nginx/html >>$LOG_FILE
print "extracting files "
unzip /tmp/frontend.zip >>$LOG_FILE && mv frontend-main/* . >>$LOG_FILE && mv static/* . >>$LOG_FILE
StatCheck $? "extracting files - "
space

print " Configuring roboshop files"
mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$LOG_FILE
StatCheck $? "Configuring roboshop - "
space

print "starting nginx services"
systemctl restart nginx >>$LOG_FILE && systemctl enable nginx >>$LOG_FILE && systemctl status nginx|grep active >>$LOG_FILE
StatCheck $? " Nginx status - "