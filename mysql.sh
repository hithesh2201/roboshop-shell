#!/bin/bash

# Disable the existing MySQL module
dnf module disable mysql -y

# Setup MySQL 5.7 repo file
cat <<EOF > /etc/yum.repos.d/mysql.repo
[mysql]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/\$basearch/
enabled=1
gpgcheck=0
EOF

# Install MySQL Server
dnf install mysql-community-server -y

# Start MySQL Service
systemctl enable mysqld
systemctl start mysqld

# Set the root password for MySQL
mysql_secure_installation --set-root-pass RoboShop@1

# Check if MySQL is running
if systemctl is-active --quiet mysqld; then
    echo "MySQL Server is running."
else
    echo "MySQL Server failed to start. Please check the logs."
fi
