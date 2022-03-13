#!/bin/bash

echo -e "\e[36m Installing nginx\e[0m"
yum install nginx -y
if [ $? = 0 ];then
  echo "installing nginx is success"
else
  echo "installation command failed";exit 1
fi
echo "----------------------------------"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
if [ $? = 0 ];then
  echo "Copying config files success"
else
  echo " file copy is failed ";exit 1
fi
echo  "----------------------------------"
echo -e "\e[36m Cleaning and extracting nginx file\e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
if [ $? = 0 ];then
  echo "Cleaning and configuration is success"
else
  echo "Cleaning and configuration is failed";exit 1
fi
echo "----------------------------------"
echo -e "\e[36m starting nginx services\e[0m"
systemctl enable nginx
systemctl stop nginx
systemctl start nginy
#systemctl status nginx|grep active
if [ $? = 0 ];then
  echo "starting nginx success"
else
  echo "starting nginx failed";exit 1
fi