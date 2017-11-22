#!/usr/bin/env bash

RABBIT_NAME="rabbit_host"
FLOWER_NAME="flower"

check_command() {
    if [ $1 -ne 0 ]; then
        echo "\x1B[91mERROR: "
        echo "\x1B[97mDocker run exit with code " $1
        echo "\x1B[39m"
        exit 1
    else
        echo "\x1B[97m> $2 [\x1B[32mOK\x1B[97m]"
        echo "\x1B[39m"
    fi
}

build_flower() {
    bash ./build_image.sh

    check_command $? "Build Flower"
}

start_rabbitmq() {
    RABBIT_NAME=$1
    echo "> Launching RabbitMQ"

    docker run -d \
        --hostname rabbit_host \
        --name rabbit_host \
        -e RABBITMQ_DEFAULT_USER=guest \
        -e RABBITMQ_DEFAULT_PASS=guest \
        -p 5672:5672 \
        -p 15672:15672 \
        rabbitmq:management

    check_command $? "RabbitMQ"
}

start_flower() {
    RABBIT_NAME=$1
    FLOWER_NAME=$2

    IMAGE=$(docker images | grep $FLOWER_NAME)
    echo "---Image: "$IMAGE
    if [ -z "$IMAGE" ]; then
        echo "> No Flower docker image found... building it"
        build_flower
    fi
    echo "> Launching Flower"

    docker run -d \
        --name $FLOWER_NAME \
        --link $RABBIT_NAME \
        -p 5555:5555 \
        $FLOWER_NAME

    check_command $? "Flower"
}

start_rabbitmq $RABBIT_NAME
start_flower $RABBIT_NAME $FLOWER_NAME
