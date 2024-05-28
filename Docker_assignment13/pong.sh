#!/bin/bash

while true; do
    if [ -f "ping.txt" ]; then
        rm ping.txt
    fi
    touch pong.txt
    echo "Pong"
    sleep 1
done

