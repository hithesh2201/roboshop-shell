#!/bin/bash
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

    