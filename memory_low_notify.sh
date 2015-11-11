#!/bin/bash

#Minimum available memory limit, MB
THRESHOLD=20

#Check time interval, sec
INTERVAL=30

while :
do

    free=$(free -m|awk '/^Mem:/{print $4}')
    buffers=$(free -m|awk '/^Mem:/{print $6}')
    cached=$(free -m|awk '/^Mem:/{print $7}')
    available=$(free -m | awk '/^-\/+/{print $4}')
    total=$(free -m | awk '/^Mem:/{print $2}')

    percent_avail=$(($available * 100 / $total))

    message="Percent avail $percent_avail %, Free $free MB, buffers $buffers MB, cached $cached MB, available $available MB"

    if [ $percent_avail -lt $THRESHOLD ]
        then
        notify-send "Memory is running out!" "$message"
    fi

    echo "$message"

    sleep $INTERVAL

done
