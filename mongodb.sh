#!/bin/bash
ID=$(id -u)
if [ "$ID" -eq 0 ];
then
    echo "Already Root user"
else
    $(sudo su -)
    echo "made root user"
fi

    