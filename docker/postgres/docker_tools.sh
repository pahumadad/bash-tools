#!/usr/bin/env bash

check_image() {
    IMAGE=$1

    ID=$(docker images \
        --filter=reference="$IMAGE" \
        --format "{{.ID}}")

    echo $ID
}

check_container() {
    CONTAINER=$1

    ID=$(docker ps -aqf "name=$CONTAINER")

    echo $ID
}

check_run() {
    ID=$1

    IS_RUN=$(docker inspect -f {{.State.Running}} $ID)

    echo $IS_RUN
}

help() {
    echo "Usage: $1 [-i | -c | -r] INFO"
    text=""
    text="\t-i [DOCKER IMAGE NAME]*to check the docker image\n"
    text="${text}\t-c [DOCKER CONTAINER NAME]*to check the docker container\n"
    text="${text}\t-c [DOCKER IMAGE ID]*to check the docker container\n"
    text="${text}\t-r [DOCKER CONTAINER ID]*to check if the docker container is running\n"

    echo $text | column -s "*" -t
}

if [ ! $# -eq 2 ]; then
    help
fi

case "$1" in
    -i)
        check_image ${2}
        ;;
    -c)
        check_container ${2}
        ;;
    -r)
        check_run ${2}
        ;;
    *)
        help $0
esac
