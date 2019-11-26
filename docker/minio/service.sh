#!/usr/bin/env bash

check_command() {
    if [ $1 -ne 0 ]; then
        echo -e "\x1B[91mERROR: "
        echo -e "\x1B[97mDocker run exit with code " $1
        echo -e "\x1B[39m"
        exit 1
    else
        echo -e "\x1B[97m> Redis [\x1B[32mOK\x1B[97m]"
        echo -e "\x1B[39m"
    fi
}

start_minio() {
    docker run -d \
        --name $NAME \
        -p $PORT:9000 \
        -e MINIO_ACCESS_KEY=$ACCESS_KEY \
        -e MINIO_SECRET_KEY=$SECRET_KEY \
        -v $DATA:/data \
        minio/minio server /data

    check_command $?
}

stop_minio() {
    docker rm -f $NAME
}

help() {
    echo -e "usage $0"
    echo -e "\t[--start]\tto start a Redis Docker container DB"
    echo -e "\t\t\toptionals: [--name, --port, --data, --access, --secret]"
    echo -e "\t[--stop]\tto stop a Redis Docker container DB"
    echo -e "\t\t\tneeds: [--name]"
    echo -e "\t[--restart]\tto restart a Redis Docker container DB"
    echo -e "\t\t\tneeds: [--name]"
    echo -e "container options:"
    echo -e "\t[--name NAME]\tset the container name. Dafult is 'minio'"
    echo -e "\t[--port PORT]\tset the minio port. Dafult is '9000'"
    echo -e "\t[--data DATA]\tset the data folder. Dafult is '/tmp/minio'"
    echo -e "\t[--access KEY]\tset the access key. Dafult is 'AKIAIOSFODNN7EXAMPLE'"
    echo -e "\t[--secret KEY]\tset the secret key. Dafult is 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'"
    exit 0
}

ARG=""
NAME="minio"
PORT="9000"
DATA="/tmp/data"
ACCESS_KEY="AKIAIOSFODNN7EXAMPLE"
SECRET_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
for (( i=1; i<=$#; i++)); do
    arg="${!i}"
    case "$arg" in
        --name)
            i=$((i+1))
            NAME="${!i}"
            ;;
        --port)
            i=$((i+1))
            PORT="${!i}"
            ;;
        --data)
            i=$((i+1))
            DATA="${!i}"
            ;;
        --access)
            i=$((i+1))
            ACCESS_KEY="${!i}"
            ;;
        --secret)
            i=$((i+1))
            SECRET_KEY="${!i}"
            ;;
        *)
            if [ -z "$ARG" ]; then
                ARG=$arg
            else
                help
            fi
    esac
done

case "$ARG" in
    --start)
        start_minio
        ;;
    --stop)
        stop_minio
        ;;
    --restart)
        stop_minio
        start_minio
        ;;
    *)
        help
esac
