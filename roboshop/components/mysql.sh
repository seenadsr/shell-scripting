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
StatCheck $?
fi

echo "show plugins"|mysql -uroot -pRoboShop@1|grep validate_password 2>>${LOG_FILE}
if [ $? -eq 0 ];then
print "Uninstall plugin validate_password"
echo "uninstall plugin validate_password;" >/tmp/plugin.sql
mysql --connect-expired-password -uroot -pRoboShop@1 < /tmp/plugin.sql 2 >>${LOG_FILE}
StatCheck $?
fi

#> uninstall plugin validate_password;
#```
#
### **Setup Needed for Application.**
#
#As per the architecture diagram, MySQL is needed by
#
#- Shipping Service
#
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
#```bash
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#```
#
#Load the schema for Services.