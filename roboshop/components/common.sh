#!/bin/bash
StatCheck() {
  if [ $1 = 0 ];then
    echo -e " `date` : $2 \e[36mSuccess\e[0m"
  else
    echo -e " `date` :$2 \e[32mFailed\e[0m"
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
  echo -e "\e[36m $1 \e[0m"
}