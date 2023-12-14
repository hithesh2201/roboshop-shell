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
SN=$($0)
DATE=$(date)
LOGFILE="/tmp/$SN+$DATE.log"
if [ "$ID" -ne 0 ];
then
    echo -e " $R Use root user"
else
    echo -e "$G ROOT USER"  
fi

if [ ! -e "/etc/yum.repos.d/mongo.repo" ]; then
    cp mongo.txt /etc/yum.repos.d/mongo.repo
    echo -e "$G Copied Successfully"
else
    echo -e "Already copied so $Y skipped$N successfully"
fi

sudo dnf install mongodb-org -y &>>LOGFILE
CHECK "mongodb"

sudo systemctl enable mongod &>>LOGFILE
CHECK "enabled"

sudo systemctl start mongod &>>LOGFILE
CHECK "started"
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/mongod.conf
sudo systemctl restart mongod &>>LOGFILE
CHECK "Restarted"
echo -e "$G Mongodb script runned successfully"
