#!/bin/bash
CHECK(){
    if [ $? -ne 0 ] 
    then
        echo -e "$R $1 not  installed  successfully $N"
        exit 1
    else
        echo -e "$G $1 installed  successfully $N"
    fi
}
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ "$ID" -ne 0 ];
then
    echo -e " $R Use root user"
else
    echo -e "$G ROOT USER"  
fi

if [ ! -e "/etc/yum.repos.d/mongo.repo" ]; then
    cp mongo.txt /etc/yum.repos.d/mongo.repo
fi
CHECK "copy"

sudo dnf install mongodb-org -y 
CHECK "mongodb"

sudo systemctl enable mongod
CHECK "enable"

sudo systemctl start mongod
CHECK "start"
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/mongod.conf
sudo systemctl restart mongod
CHECK "Restart"
echo "$G Mongodb script runned successfully"
