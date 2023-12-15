#!/bin/bash

# Install Erlang
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

# Configure YUM Repos for RabbitMQ
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

# Install RabbitMQ
dnf install rabbitmq-server -y 

# Start RabbitMQ Service
systemctl enable rabbitmq-server 
systemctl start rabbitmq-server 

# Wait for RabbitMQ to start (optional, adjust sleep time accordingly)
sleep 10

# Create RabbitMQ user for the application
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
