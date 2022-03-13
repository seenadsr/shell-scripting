#!/bin/bash

echo -e "\e[36m Installing nginx\e[0m"
yum install nginy -y
if [ $? = 0 ];then
  echo "installing nginx is success"
else
  echo "installation command failed";exit 1
fi
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[36m Cleaning and extracting nginx file\e[0m"
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[36m starting nginx services\e[0m"
systemctl restart nginx
systemctl enable nginx
systemctl status nginx|grep active

