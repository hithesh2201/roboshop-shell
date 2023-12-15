#!/bin/bash

# Install Golang
dnf install golang -y

# Add application user
useradd roboshop

# Setup app directory
mkdir /app

# Download application code
curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip

# Configure Go module
cd /app
go mod init dispatch

# Download dependencies
go get

# Build the software
go build

# Setup SystemD Dispatch Service
cat <<EOF > /etc/systemd/system/dispatch.service
[Unit]
Description=Dispatch Service

[Service]
User=roboshop
Environment=AMQP_HOST=rabbitmq.hiteshshop.online
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target
EOF

# Load the service
systemctl daemon-reload

# Enable and start the service
systemctl enable dispatch
systemctl start dispatch
