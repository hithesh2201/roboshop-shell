#!/bin/bash

# Install Python 3.6, GCC, and Python 3 development tools
dnf install python36 gcc python3-devel -y

# Add application user
useradd roboshop

# Setup app directory
mkdir /app

# Download application code
curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

# Install application dependencies
cd /app
pip3.6 install -r requirements.txt

# Setup SystemD Payment Service
cat <<EOF > /etc/systemd/system/payment.service
[Unit]
Description=Payment Service

[Service]
User=root
WorkingDirectory=/app
Environment=CART_HOST=cart.hiteshshop.online
Environment=CART_PORT=8080
Environment=USER_HOST=user.hiteshshop.online
Environment=USER_PORT=8080
Environment=AMQP_HOST=rabbitmq.hiteshshop.online
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123

ExecStart=/usr/local/bin/uwsgi --ini payment.ini
ExecStop=/bin/kill -9 $MAINPID
SyslogIdentifier=payment

[Install]
WantedBy=multi-user.target
EOF

# Load the service
systemctl daemon-reload

# Enable and start the service
systemctl enable payment
systemctl start payment
