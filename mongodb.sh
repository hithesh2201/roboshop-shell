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

if [ ! -e "/etc/yum.repos.d/mongo.repo" ]; then
    cp mongo.txt /etc/yum.repos.d/mongo.repo
    echo -e "$G Copied Successfully"
else
    echo -e "$N Already copied so $Y skipped$N successfully"
fi

dnf install mongodb-org -y &>>$LOGFILE
CHECK "mongodb"

systemctl enable mongod &>>$LOGFILE
CHECK "enabled"

systemctl start mongod &>>$LOGFILE
CHECK "started"
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/mongod.conf
systemctl restart mongod &>>$LOGFILE
CHECK "Restarted"
echo -e "$G Mongodb script runned successfully"
