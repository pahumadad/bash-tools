#!/usr/bin/env bash

RABBIT_NAME="rabbit_host"
FLOWER_NAME="flower"

check_command() {
    if [ $1 -ne 0 ]; then
        echo -e "\x1B[91mERROR: "
        echo -e "\x1B[97mDocker run exit with code " $1
        echo -e "\x1B[39m"
        exit 1
    else
        echo -e "\x1B[97m> $2 [\x1B[32mOK\x1B[97m]"
        echo -e "\x1B[39m"
    fi
}

build_flower() {
    bash ./build_image.sh

    check_command $? "Build Flower"
}

check_running() {
    CONTAINER=$(bash docker_tools.sh -c $1)
    if [ ! -z "$CONTAINER" ]; then
        RUNNING=$(bash docker_tools.sh -r $CONTAINER)
        if [ "$RUNNING" == "true" ]; then
            echo "> $1 container is running"
        elif [ "$RUNNING" == "false" ]; then
            docker rm -f $FLOWER_NAME
        fi
    else
        echo $1
    fi
}

start_rabbitmq() {
    STATE=$(check_running $RABBIT_NAME)
    if [ "$STATE" != "$RABBIT_NAME" ]; then
        echo $STATE
    else
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
    fi
}

start_flower() {
    IMAGE=$(bash docker_tools.sh -i $FLOWER_NAME)
    if [ -z "$IMAGE" ]; then
        echo "> No Flower docker image found... building it"
        build_flower
    fi

    STATE=$(check_running $FLOWER_NAME)
    if [ "$STATE" != "$FLOWER_NAME" ]; then
        echo $STATE
    else
        echo "> Launching Flower"

        docker run -d \
            --name $FLOWER_NAME \
            --link $RABBIT_NAME \
            -p 5555:5555 \
            $FLOWER_NAME

        check_command $? "Flower"
    fi
}

stop_containers() {
    for NAME in $FLOWER_NAME $RABBIT_NAME; do
        check_running $NAME
        if [ "$STATE" != "$NAME" ]; then
            docker rm -f $NAME
        fi
    done
}

delete_flower() {
    docker rmi $FLOWER_NAME
}

help() {
    echo -e "usage:\t[--start]\tstart RabbitMQ and Flower services"
    echo -e "$fakes\t[--stop]\tstop and delete containers"
    echo -e "$fakes\t[--restart]\tstop, delete and start containers"
    echo -e "$fakes\t[--build]\tstop and delete containers. Delete the flower image and start containers again"
}

case "$1" in
    --start)
        start_rabbitmq
        start_flower
        ;;
    --stop)
        stop_containers
        ;;
    --restart)
        stop_containers
        start_rabbitmq
        start_flower
        ;;
    --build)
        stop_containers
        delete_flower
        start_rabbitmq
        start_flower
        ;;
    *)
        help $0
esac
