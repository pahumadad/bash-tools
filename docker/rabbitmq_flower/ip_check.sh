#!/usr/bin/env bash

get_ip_address() {
    ifconfig \
        | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' \
        | grep -Eo '([0-9]*\.){3}[0-9]*' \
        | grep -v '127.0.0.1'
}

check() {
    IP=""
    IPs=$(get_ip_address)

    NUM=$(echo "$IPs" | wc -w)
    if [ $NUM -gt 1 ]; then
        for ip in $IPs; do
            read -p "Do you want to use this IP address: $ip [y/N]?"
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                IP=$ip
                break
            fi
        done
    elif [ $NUM -eq 1 ]; then
        IP=$ip
    fi

    echo $IP
}

check
