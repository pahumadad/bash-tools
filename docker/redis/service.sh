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

start_redis() {
    if [ -z "$DATA" ]; then
        docker run -d \
            --name $NAME \
            -p $PORT:6379 \
            redis:5-alpine
    else
        docker run -d \
            --name $NAME \
            -v $DATA:/data \
            -p $PORT:6379 \
            redis:5-alpine
    fi

    check_command $?
}

stop_redis() {
    docker rm -f $NAME
}

save_rdb() {
    docker exec $NAME sh -c "redis-cli -h localhost --rdb /data/$DUMP_NAME"
}

help() {
    echo -e "usage $0"
    echo -e "\t[--start]\tto start a Redis Docker container DB"
    echo -e "\t\t\toptionals: [--name, --port, --data]"
    echo -e "\t[--stop]\tto stop a Redis Docker container DB"
    echo -e "\t\t\tneeds: [--name]"
    echo -e "\t[--restart]\tto restart a Redis Docker container DB"
    echo -e "\t\t\tneeds: [--db-name]"
    echo -e "\t[--save]\tto create a backup from a Redis Docker container DB"
    echo -e "\t\t\tthe backup will be left in the folder path given with"
    echo -e "\t\t\t'--data' (used when the container was started) with the"
    echo -e "\t\t\tfile name given with '--dump-name'"
    echo -e "\t\t\tneeds: [--db-name, --dump-name]"
    echo -e "container options:"
    echo -e "\t[--name NAME]\t\tset the container name. Dafult is 'redis'"
    echo -e "\t[--port PORT]\t\tset the DB port. Dafult is '6379'"
    echo -e "\t[--data FOLDER PATH]\tfolder mounted as '/data' used by Redis"
    echo -e "\t[--dump-name NAME]\tset the backup file name. Default is 'dump.rdb'"
    exit 0
}

ARG=""
DATA=""
NAME="redis"
PORT="6379"
DUMP_NAME="dump.rdb"
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
        --dump-name)
            i=$((i+1))
            DUMP_NAME="${!i}"
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
        start_redis
        ;;
    --stop)
        stop_redis
        ;;
    --restart)
        stop_redis
        start_redis
        ;;
    --save)
        save_rdb
        ;;
    *)
        help
esac
