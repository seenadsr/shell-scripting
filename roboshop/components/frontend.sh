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

print() {
  echo -e "\e[36m $1 \e[0m"
}

space () {
  echo "  "
  echo "======================================"
}
print "Installing nginx"
yum install nginx -y
StatCheck $? "Nginx Installation - "
space
print "Copying frontend config files"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
StatCheck $? "Curl copy - "
space
print " cleaning up old-files"
rm -rf /usr/share/nginx/html
StatCheck $? "cleaning up files -"

cd /usr/share/nginx/html
print "extracting files "
unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* .
StatCheck $? "extracting files - "

print " Configuring roboshop files"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
StatCheck $? "Configuring roboshop - "
space

print "starting nginx services"
systemctl restart nginx && systemctl enable nginx && systemctl status nginx|grep active
StatCheck $? " Nginx status - "