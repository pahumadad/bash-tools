#!/usr/bin/env bash

USER_NAME="admin"
USER_PASS="admin"
DB_NAME="example_db"

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

start_postgres() {
    STATE=$(check_running $DB_NAME)
    if [ "$STATE" != "$DB_NAME" ]; then
        echo $STATE
    else
        echo "> Launching PostgreSQL DB"

        docker run -d \
            -p 5432:5432 \
            -e POSTGRES_USER=$USER_NAME \
            -e POSTGRES_PASSWORD=$USER_PASS \
            -e POSTGRES_DB=$DB_NAME \
            --name $DB_NAME \
            postgres

        check_command $? "PostgreSQL"
    fi
}

stop_postgres() {
    STATE=$(check_running $DB_NAME)
    if [ "$STATE" != "$DB_NAME" ]; then
        docker rm -f $DB_NAME
    fi
}

help() {
    echo -e "usage $0"
    echo -e "container options:"
    echo -e "\t[--start]\tto start a PostgreSQL Docker container DB"
    echo -e "\t[--stop]\tto stop a PostgreSQL Docker container DB"
    echo -e "\t[--restart]\tto restart a PostgreSQL Docker container DB"
    echo -e "\nDB options:"
    echo -e "\t[--user_name]\tset an user name. Default is 'admin'"
    echo -e "\t[--user_pass]\tset an user pass. Default is 'admin'"
    echo -e "\t[--db_name]\tset a DB name. Dafult is 'example_db'."
    echo -e "\t\t\tThis name will be use as the Docker container name as well."
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
