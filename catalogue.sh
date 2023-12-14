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

dnf module disable nodejs -y
CHECK "disabled"
dnf module enable nodejs:18 -y
CHECK "enabled"
dnf install nodejs -y
CHECK "nodejs"

# Check if the user "roboshop" exists
if id -u roboshop; then
    echo "User roboshop exists."
else
    useradd roboshop
fi

mkdir -p /app 
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
CHECK "downloading"

