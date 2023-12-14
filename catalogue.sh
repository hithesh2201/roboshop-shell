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

# User to add
username="roboshop"

# Check if the user exists
if id "$username" >/dev/null 2>&1; then
    echo "User $username already exists."
else
    # Add the user
    useradd "$username"
    echo "User $username added successfully."
fi
mkdir -p /app 
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip
CHECK "downloading"
cd /app || exit
unzip /tmp/catalogue.zip
CHECK "Unzipped"
cd /app || exit
npm install 
cp roboshop-shell/catalogue.txt /etc/systemd/system/catalogue.service
CHECK "catalogue.service"
systemctl daemon-reload
CHECK "reload"
systemctl enable catalogue
CHECK "enabled"
systemctl start catalogue
CHECK "started"
cp roboshop-shell/catalogue.sh /etc/yum.repos.d/mongo.repo
CHECK "mongo_client repo added"
dnf install mongodb-org-shell -y
CHECK "mongo-client"
mongo --host mongo.hiteshshop.online </app/schema/catalogue.js
CHECK "Loaded"
echo -e "$G Script run successfully"


