#!/usr/bin/env bash

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

check_image() {
    IMAGE=$1

    ID=$(docker images \
        --filter=reference="$IMAGE" \
        --format "{{.ID}}")

    echo $ID
}

build_airflow() {
    IMAGE=$(check_image "$AIRFLOW_NAME:$AIRFLOW_VERSION")

    if [ -z "$IMAGE" ]; then
        echo "> No Airflow docker image found... building it"
        bash ./build_image.sh $AIRFLOW_VERSION $AIRFLOW_HOME

        check_command $? "Build Airflow"
    fi
}

start_airflow() {
    CMD="docker run -ti --name $AIRFLOW_NAME -e AIRFLOW__CORE__EXECUTOR=$EXECUTOR \\"
    if [ ! -z $DAGS_PATH ];then
        CMD+="-v $DAGS_PATH:$AIRFLOW_HOME/dags \\"
    fi
    if [ ! -z $POSTGRES_CONTAINER ];then
        if [ "${POSTGRES_DSN: -1}" == "/" ]; then
            POSTGRES_DSN+="$POSTGRES_CONTAINER"
        fi
        CMD+="--link $POSTGRES_CONTAINER -e AIRFLOW__CORE__SQL_ALCHEMY_CONN=$POSTGRES_DSN \\"
    fi
    if [ ! -z $RABBITMQ_CONTAINER ];then
        CMD+="--link $RABBITMQ_CONTAINER -e AIRFLOW__CELERY__BROKER_URL=$RABBITMQ_URL \\"
    fi
    if [ ! -z $REDIS_CONTAINER ];then
        CMD+="--link $REDIS_CONTAINER -e AIRFLOW__CELERY__RESULT_BACKEND=$REDIS_URL \\"
    fi
    CMD+="-p $PORT:8080 $AIRFLOW_NAME:$AIRFLOW_VERSION bash"
    eval $CMD

    check_command $? "Airflow"
}

stop_airflow() {
    docker rm -f $AIRFLOW_NAME
}

help() {
    echo -e "usage $0"
    echo -e "container options:"
    echo -e "\t[--start]\tto start a Airflow Docker container"
    echo -e "\t\t\tif a dump file y given with '--db-dump' argument there will be created"
    echo -e "\t\t\tthe new Docker DB image and this will be used to start the container"
    echo -e "\t\t\toptionals: [--user-name, --user-pass, --db-name, --db-port, --db-img, --db-dump]"
    echo -e "\t[--stop]\tto stop a Airflow Docker container"
    echo -e "\t\t\tneeds: [--db-name]"
    echo -e "\t[--restart]\tto restart a Airflow Docker container"
    echo -e "\t\t\tneeds: [--db-name]"

    echo -e "\nDB options:"
    echo -e "\t[--airflow-home PATH]\t\tset the Airflow workdir path"
    echo -e "\t[--airflow-version VERSION]\t\tset the Airflow version to use"
    echo -e "\t[--executor EXECUTOR]\t\t\tset the executor"
    echo -e "\t\t\t\t\t\tdefault: [LocalExecutor]"
    echo -e "\t\t\t\t\t\toptions: [LocalExecutor, SequentialExecutor, CeleryExecutor]"
    echo -e "\t[--dags-path PATH]\t\tset the Airflow DAGs folder"
    echo -e "\t[--port PORT]\t\t\t\tAirflow webserver port. Default: 8080"
    echo -e "\t[--postgres CONTAINER_NAME]\t\tlink with this Docker container"
    echo -e "\t[--postgres-dsn DSN]\t\t\tset the AIRFLOW__CORE__SQL_ALCHEMY_CONN"
    echo -e "\t\t\t\t\t\tdefault: postgresql+psycopg2://airflow:airflow@IP:5432/$CONTAINER_NAME"
    echo -e "\t[--rabbitmq CONTAINER_NAME]\t\tlink with this Docker container"
    echo -e "\t[--broker-url BROKER_URL]\t\tset the AIRFLOW__CELERY__BROKER_URL"
    echo -e "\t\t\t\t\t\tdefault: amqp://guest:guest@IP:5672"
    echo -e "\t[--redis CONTAINER_NAME]\t\tlink with this Docker container"
    echo -e "\t[--result-backend RESULT_BACKEND]\tset the AIRFLOW__CELERY__RESULT_BACKEND"
    echo -e "\t\t\t\t\t\tdefault: redis://IP:6379/0"
    exit 0
}

IP=$(bash ip_check.sh)
AIRFLOW_HOME="/usr/local/airflow"
AIRFLOW_NAME="airflow"
AIRFLOW_VERSION="1.10.4"
DAGS_PATH=""
EXECUTOR="LocalExecutor"
PORT="8080"
POSTGRES_CONTAINER=""
POSTGRES_DSN="postgresql+psycopg2://airflow:airflow@$IP:5432/"
RABBITMQ_CONTAINER=""
RABBITMQ_URL="amqp://guest:guest@$IP:5672"
REDIS_CONTAINER=""
REDIS_URL="redis://$IP:6379/0"
for (( i=1; i<=$#; i++)); do
    arg="${!i}"
    case "$arg" in
        --airflow-home)
            i=$((i+1))
            AIRFLOW_HOME="${!i}"
            ;;
        --airflow-version)
            i=$((i+1))
            AIRFLOW_VERSION="${!i}"
            ;;
        --dags-path)
            i=$((i+1))
            DAGS_PATH="${!i}"
            ;;
        --executor)
            i=$((i+1))
            EXECUTOR="${!i}"
            ;;
        --port)
            i=$((i+1))
            PORT="${!i}"
            ;;
        --postgres)
            i=$((i+1))
            POSTGRES_CONTAINER="${!i}"
            ;;
        --postgres-dsn)
            i=$((i+1))
            POSTGRES_DSN="${!i}"
            ;;
        --rabbitmq)
            i=$((i+1))
            RABBITMQ_CONTAINER="${!i}"
            ;;
        --rabbitmq-url)
            i=$((i+1))
            RABBITMQ_URL="${!i}"
            ;;
        --redis)
            i=$((i+1))
            REDIS_CONTAINER="${!i}"
            ;;
        --redis-url)
            i=$((i+1))
            REDIS_URL="${!i}"
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
        build_airflow
        start_airflow
        ;;
    --stop)
        stop_airflow
        ;;
    --restart)
        stop_airflow
        start_airflow
        ;;
    *)
        help
esac
