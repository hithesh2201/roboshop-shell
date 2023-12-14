#!/bin/bash
CHECK(){
    if [ $? -ne 0 ] 
    then
        echo "$1 not $R installed$N successfully"
        exit 1
    else
        echo "$1 $Ginstalled$N successfully"
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

dnf install mongodb-org -y 
CHECK "mongodb"

systemctl enable mongod
CHECK "enable"

systemctl start mongod
CHECK "start"
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/' /etc/mongod.conf
systemctl restart mongod
CHECK "Restart"
echo "Mongodb script runned successfully"
