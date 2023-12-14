#!/bin/bash
CHECK(){
    if [ $? -ne 0 ] 
    then
        echo "$1 not installed successfully"
        exit 1
    else
        echo "$1 installed successfully"
    fi
}
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
NORMAL="\e[0m"

if [ "$ID" -ne 0 ];
then
    echo -e " $R Use root user"
else
    echo -e "$G ROOT USER"  
fi

cp mongo.txt /etc/yum.repos.d/mongo.repo
CHECK "copy"

