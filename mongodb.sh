#!/bin/bash
ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
NORMAL="\e[0m"

if [ "$ID" -ne 0 ];
then
    echo " $R Use root user"
else
    echo "$G ROOT USER"  
fi

    