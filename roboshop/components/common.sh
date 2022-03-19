#!/bin/bash
StatCheck() {
  if [ $1 = 0 ];then
    echo -e " $2 \e[36mSuccess\e[0m"
  else
    echo -e " $2 \e[32mFailed\e[0m"
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
  echo " ===================================="
  echo -e "\n================$1=============" >>$LOG_FILE
  echo -e " `date` :- \e[36m $1 \e[0m"
}

APP_USER=roboshop

NODJS() {
  print " Setting up YUM repo "
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
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" >>$LOG_FILE
  StatCheck $? "Downloading nodejs config files  - "

  print "Cleaning old files "
  rm -rf /home/${APP_USER}/${COMPONENT} >>$LOG_FILE
  StatCheck $? " Old files cleanup -"

  print " extract and configure nodejs"
  cd /home/roboshop >>$LOG_FILE && unzip -o /tmp/${COMPONENT}.zip >>$LOG_FILE && mv -f ${COMPONENT}-main ${COMPONENT} >>$LOG_FILE && cd /home/roboshop/${COMPONENT} >>$LOG_FILE
  StatCheck $? " nodejs configuration - "

  print " npm installation "
  npm install >>$LOG_FILE
  StatCheck $? " npm installation success "

  print " Changing permission for application user"
  chown -R ${APP_USER}:${APP_USER} /home/roboshop >>$LOG_FILE
  StatCheck $? " Permission changed - "

  print "update DNS name"
  sed -i -e 's/MONGO_DNSNAME/mongo.roboshop.internal/' \
         -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
         -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
         -e 's/MONGO_ENDPOINT/mongo.roboshop.internal/' /home/roboshop/catalogue/systemd.service >>$LOG_FILE
  StatCheck $? " DNS name updated - "

  print " Start systemd services "
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service >>$LOG_FILE && systemctl daemon-reload >>$LOG_FILE && systemctl start ${COMPONENT} >>$LOG_FILE  && systemctl enable ${COMPONENT} >>$LOG_FILE
  StatCheck $? " services started "
}
