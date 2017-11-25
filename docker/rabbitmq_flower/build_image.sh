#!/usr/bin/env bash

IMAGE_NAME="flower"
IP=$(bash ip_check.sh)

if [ -z $IP ]; then
    echo "> You must provide an IP address"
    exit -1
fi

echo "> Building $IMAGE_NAME docker image"
docker build --build-arg IP=$IP -t ${IMAGE_NAME} .

echo "> All set! $IMAGE_NAME was built successfully"
