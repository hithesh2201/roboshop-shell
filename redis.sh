#!/bin/bash
CHECK(){
    if [ $? -ne 0 ] 
    then
        echo -e "$R $1 not  successfully $N"
        exit 1
    else
        echo -e "$G $1  successfully $N"
    fi
}
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGFILE="/tmp/logs.log"
if [ "$ID" -ne 0 ];
then
    echo -e " $R Use root user"
    exit 1
else
    echo -e "$G ROOT USER"  
fi

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
CHECK "redis"


dnf module enable redis:remi-6.2 -y &>>$LOGFILE
CHECK "enabled"

dnf install redis -y
CHECK "installed"

systemctl start mongod &>>$LOGFILE
CHECK "started"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf
systemctl enable redis &>>$LOGFILE
CHECK "enabled"
systemctl start redis &>>$LOGFILE
CHECK "started"
echo -e "$G redis script runned successfully"
