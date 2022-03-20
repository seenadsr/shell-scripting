#!/bin/bash
source components/common.sh


 print "Setup YUM repositories for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash >>${LOG_FILE}

StatCheck $?

print " Install erlang & rabittmq"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y >>${LOG_FILE}
yum install rabbitmq-server -y >>${LOG_FILE}
StatCheck $?

print " start rabittmq services "
systemctl enable rabbitmq-server >>${LOG_FILE} && systemctl start rabbitmq-server >>${LOG_FILE}
StatCheck $?

rabbitmqctl list_users|grep roboshop >>${LOG_FILE}
if [ $? -ne 0 ];then
print "Create application user"
rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
StatCheck $?
else
 print " user already exist"
 StatCheck $?
fi

print " configure rabittmq "
rabbitmqctl set_user_tags roboshop administrator >>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" >>${LOG_FILE}
StatCheck $?