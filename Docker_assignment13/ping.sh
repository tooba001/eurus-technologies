#!/bin/bash

while true; do
    echo "Ping"
    sleep 1
    if [ -f "pong.txt" ]; then
        rm pong.txt
    fi
    echo "hello"
done

