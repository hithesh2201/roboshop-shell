#!/bin/bash

CHECK() {
    if [ $? -ne 0 ]; then
        echo -e "$R $1 not successfully $N"
        exit 1
    else
        echo -e "$G $1 successfully $N"
    fi
}

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGFILE="/tmp/logs.log"

if [ "$ID" -ne 0 ]; then
    echo -e " $R Use root user"
    exit 1
else
    echo -e "$G ROOT USER"
fi

# Disable and enable Node.js module
dnf module list --disabled nodejs &>>$LOGFILE
if [ $? -eq 0 ]; then
    dnf module disable nodejs -y
    CHECK "disabled"
fi

dnf module list --enabled nodejs:18 &>>$LOGFILE
if [ $? -ne 0 ]; then
    dnf module enable nodejs:18 -y
    CHECK "enabled"
fi

# Install Node.js
dnf list installed nodejs &>>$LOGFILE
if [ $? -ne 0 ]; then
    dnf install nodejs -y
    CHECK "nodejs"
fi

# User to add
username="roboshop"

# Check if the user exists
id "$username" &>>$LOGFILE
if [ $? -eq 0 ]; then
    echo "User $username already exists."
else
    # Add the user
    useradd "$username"
    CHECK "User $username added"
fi

# Create /app directory
[ -d "/app" ] && echo "Directory /app already exists." || mkdir -p /app && CHECK "Created /app directory"

# Download and unzip application code
curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip
CHECK "Downloaded"
unzip -o /tmp/user.zip -d /app
CHECK "Unzipped"

# Install Node.js dependencies
cd /app && npm install &>>$LOGFILE
CHECK "Installed Node.js dependencies"

cp -f /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service
CHECK "copied"
systemctl daemon-reload
systemctl enable user 
systemctl start user
# Install MongoDB shell
dnf list installed mongodb-org-shell &>/dev/null
if [ $? -ne 0 ]; then
    dnf install mongodb-org-shell -y &>>$LOGFILE
    CHECK "Installed MongoDB shell"
fi
mongo --host mongo.hiteshshop.online </app/schema/user.js &>>$LOGFILE
CHECK "Loaded MongoDB schema"

echo -e "$G Script run successfully"

