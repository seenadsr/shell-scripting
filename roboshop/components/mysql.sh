#!/bin/bash
source components/common.sh

print " setup mysql repo "
curl -f -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo >>${LOG_FILE}
StatCheck $?

print "Install MySQL"
yum install mysql-community-server -y >>${LOG_FILE}
StatCheck $?

print "Start MySQL"
systemctl enable mysqld >>${LOG_FILE}&& systemctl start mysqld >>${LOG_FILE}

echo "show databases"|mysql -uroot -pRoboShop@1 2>>${LOG_FILE}
if [ $? -ne 0 ];then
print " Changing root default passowrd "
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/password.sql
DEFAULT_ROOT_PASSWD=$(grep "temporary password" /var/log/mysqld.log|awk '{print $NF}')
mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWD}"  < /tmp/password.sql 2>>${LOG_FILE}
else
  print " Default password already changed "

StatCheck $?
fi

echo "show plugins"|mysql -uroot -pRoboShop@1|grep validate_password 2>>${LOG_FILE}
if [ $? -eq 0 ];then
print "Uninstall plugin validate_password"
echo "uninstall plugin validate_password;" >/tmp/plugin.sql
mysql --connect-expired-password -uroot -pRoboShop@1 < /tmp/plugin.sql 2>>${LOG_FILE}
else
  print "validate password not exist"
StatCheck $?
fi

print "Downlaod schema"
curl -f -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" >>${LOG_FILE}
StatCheck $?

print "Load schemas"
cd /tmp >>${LOG_FILE} && unzip -o mysql.zip >>${LOG_FILE} && cd mysql-main >>${LOG_FILE}
mysql -u root -pRoboShop@1 <shipping.sql
StatCheck $?