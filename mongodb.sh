#!/bin/bash
ID=$(id -u)
if [ "$ID" -ne 0 ];
then
    echo "Use root user"
fi

    