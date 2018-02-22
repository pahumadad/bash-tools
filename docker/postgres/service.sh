#!/usr/bin/env bash

USER_NAME="admin"
USER_PASS="admin"
DB_NAME="example_db"
DB_DUMP=""
DB_DOCKER_IMG="postgres"

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

check_running() {
    RUNNING=""
    CONTAINER=$(bash docker_tools.sh -c $1)
    if [ ! -z "$CONTAINER" ]; then
        RUNNING=$(bash docker_tools.sh -r $CONTAINER)
    fi

    echo $RUNNING
}

build_image() {
    if [ ! -f $DB_DUMP ]; then
        echo -e "\x1B[91mERROR: "
        echo -e "\x1B[97mDump SQL file not found:" $DB_DUMP
        echo -e "\x1B[39m"
        exit 1
    fi

    cp $DB_DUMP .
    DB_DUMP=$(basename $DB_DUMP)
    DB_DOCKER_IMG=$(echo $DB_DUMP | cut -d "." -f1)
    if [ ! -z $(bash docker_tools.sh -i $DB_DOCKER_IMG) ]; then
        echo -e "> Removing previous Docker DB image"
        docker rmi -f $DB_DOCKER_IMG
    fi

    echo -e "> Building Docker DB image with dump file:" $DB_DUMP
    docker build \
        --build-arg DUMP=$DB_DUMP \
        -t ${DB_DOCKER_IMG} \
        .
}

start_postgres() {
    if [ ! -z $DB_DUMP ]; then
        build_image
    fi
    STATE=$(check_running $DB_NAME)
    if [ "$STATE" = "true" ]; then
        echo -e "> The Docker container is already running"
    elif [ -z $(bash docker_tools.sh -i $DB_DOCKER_IMG) ]; then
        echo -e "\x1B[91mERROR: "
        echo -e "\x1B[97mDocker image not found:" $DB_DOCKER_IMG
        echo -e "\x1B[39m"
        exit 1
    else
        echo -e "> Launching PostgreSQL DB"

        docker run -d \
            -p 5432:5432 \
            -e POSTGRES_USER=$USER_NAME \
            -e POSTGRES_PASSWORD=$USER_PASS \
            -e POSTGRES_DB=$DB_NAME \
            --name $DB_NAME \
            $DB_DOCKER_IMG

        check_command $? "PostgreSQL"
    fi
}

stop_postgres() {
    STATE=$(check_running $DB_NAME)
    if [ -z "$STATE" ]; then
        docker rm -f $DB_NAME
    fi
}

help() {
    echo -e "usage $0"
    echo -e "container options:"
    echo -e "\t[--start]\tto start a PostgreSQL Docker container DB"
    echo -e "\t\t\tIf a dump file y given with '--db_dump' argument there will be created"
    echo -e "\t\t\tthe new Docker DB image and this will be used to start the container"
    echo -e "\t[--stop]\tto stop a PostgreSQL Docker container DB"
    echo -e "\t[--restart]\tto restart a PostgreSQL Docker container DB"
    echo -e "\nDB options:"
    echo -e "\t[--user_name DB_USER_NAME]\tset an user name. Default is 'admin'"
    echo -e "\t[--user_pass DB_USER_PASS]\tset an user pass. Default is 'admin'"
    echo -e "\t[--db_name DB_NAME]\t\tset a DB name. Dafult is 'example_db'"
    echo -e "\t\t\t\t\tThis name will be use as the Docker container name as well"
    echo -e "\t[--db_img DB_IMG_NAME]\t\tuse a specific Docker PostgreSQL DB image"
    echo -e "\t\t\t\t\tDefault is 'postgres'"
    echo -e "\t[--db_dump PATH/TO/DUMP.SQL]\tuse a 'dump.sql' file to create a Docker"
    echo -e "\t\t\t\t\tPostgreSQL DB image with this DB dump"
    echo -e "\t\t\t\t\tThe Docker image gotten will be called as the 'dump.sql' file used."
    exit 0
}

ARG=""
for (( i=1; i<=$#; i++)); do
    arg="${!i}"
    case "$arg" in
        --user_name)
            i=$((i+1))
            USER_NAME="${!i}"
            ;;
        --user_pass)
            i=$((i+1))
            USER_PASS="${!i}"
            ;;
        --db_name)
            i=$((i+1))
            DB_NAME="${!i}"
            ;;
        --db_img)
            i=$((i+1))
            DB_DOCKER_IMG="${!i}"
            ;;
        --db_dump)
            i=$((i+1))
            DB_DUMP="${!i}"
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
        start_postgres
        ;;
    --stop)
        stop_postgres
        ;;
    --restart)
        stop_postgres
        start_postgres
        ;;
    *)
        help
esac
