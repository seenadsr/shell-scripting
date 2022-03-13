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
  echo " run with root only ";exit 2
fi
echo -e "\e[36m Installing nginx\e[0m"
yum install nginx -y
StatCheck $? "Nginx Installation - "
echo "----------------------------------"
echo -e "\e[36m Copying frontend config files\e[0m"
curl -s -L -o /tmp/frontend.zip "https://githu.com/roboshop-devops-project/frontend/archive/main.zip"
StatCheck $? "Curl copy - "
echo  "----------------------------------"
echo -e "\e[36m Cleaning and extracting nginx file\e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
StatCheck $? " Cleanin and extracting - "
echo "----------------------------------"
echo -e "\e[36m starting nginx services\e[0m"

systemctl restart nginx
systemctl enable nginx
systemctl status nginx|grep active
StatCheck $? " Nginx status - "