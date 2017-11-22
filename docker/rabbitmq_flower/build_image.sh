#!/usr/bin/env bash

get_ip_address() {
    ifconfig \
        | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' \
        | grep -Eo '([0-9]*\.){3}[0-9]*' \
        | grep -v '127.0.0.1'
}

IMAGE_NAME="flower"

echo "> Building $IMAGE_NAME docker image"

docker build --build-arg IP=$(get_ip_address) -t ${IMAGE_NAME} .

echo "> All set! $IMAGE_NAME was built successfully"
