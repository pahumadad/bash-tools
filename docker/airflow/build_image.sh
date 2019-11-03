#!/usr/bin/env bash

if [ -z $1 ]; then
    echo -e "\x1B[91mERROR: "
    echo -e "\x1B[97mThe Airflow version must be given"
    echo -e "\x1B[39m"
    exit 1
fi

WORKDIR="/usr/local/airflow"
if [ -z $2 ]; then
    WORKDIR=$2
fi

VERSION=$1
NAME="airflow"
IMAGE=$NAME:$VERSION

echo "> Building $IMAGE docker image"
docker build \
    --build-arg AIRFLOW_HOME=$WORKDIR \
    --build-arg AIRFLOW_VERSION=$VERSION \
    -t ${IMAGE} .

if [ $? -ne 0 ]; then
    echo -e "\x1B[91mERROR: "
    echo -e "\x1B[97mDocker build exit with code " $?
    echo -e "\x1B[39m"
    exit 1
else
    echo "> All set! $IMAGE_NAME was built successfully"
fi
