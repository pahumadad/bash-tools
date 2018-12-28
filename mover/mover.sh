#!/bin/bash

WHITE="\033[1;37m"
NC="\033[0m"

move_movie() {
    if [ -z "$1" ]; then
        echo -e "$WHITE> Which movie you want to move?$NC"
        exit -1
    fi

    if [[ ! -d $1 ]]; then
        echo -e "$WHITE> You have to provide the movie's folder!$NC"
        exit -1
    fi

    folder="/share/Multimedia/movies/"

    echo "There will be move:"
    echo "$1 -> $folder"
    read -p "Are you sure [y/N]? " -r

    if [ -z "$FORCE" ]; then
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "${1}" "${folder}"
        fi
    else
        mv "${1}" "${folder}"
    fi
}

get_name() {
    name=$(echo ${1//.[sS][0-9][0-9][eE]*})

    echo ${name//./ }
}

get_season(){
    dig_1=$(echo $1 | egrep -o '[sS][0-9][0-9][eE]' | cut -c2)
    dig_2=$(echo $1 | egrep -o '[sS][0-9][0-9][eE]' | cut -c3)
    if [[ $dig_1 = 0 ]]; then
        season="Season $dig_2"
    else
        season="Season $dig_1$dig_2"
    fi
    echo $season
}

delete_folder() {
    folder=$(echo "${1}" | cut -d"/" -f 1)
    if [[ -d "${folder}" ]]; then
        if [ -z "$FORCE" ]; then
            read -p "Do you want to delete ${folder} [y/N]? "
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -r "${folder}"
            fi
        else
            rm -r "${folder}"
        fi
    fi
}

check_folders() {
    folder="$1/$2/"
    if [[ ! -d "${folder}" ]]; then
        if [ -z "$FORCE" ]; then
            read -p "Do you want to create the folder ${folder} [y/N]? "
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mkdir "${folder}"
            else
                echo -e "$WHITE> Folder does not exist!$NC"
                exit 1
            fi
        else
            mkdir "${folder}"
        fi
    fi
}

check_and_move() {
    path="/share/Multimedia/series"
    folder="$path/$2/$3/"

    echo "There will be move:"
    echo "$1 -> $folder"
    if [ -z "$FORCE" ]; then
        read -p "Are you sure [y/N][c: to change the series name]? " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            check_folders "$path" "${2}"
            check_folders "$path/${2}" "${3}"
            mv "${file}" "${folder}"
            delete_folder "${file}"
        elif [[ $REPLY =~ ^[c]$ ]]; then
            read -p "What is the correct serie's name? " -r
            check_and_move "${1}" "${REPLY}" "${3}"
        fi
    else
        check_folders "$path" "${2}"
        check_folders "$path/${2}" "${3}"
        mv "${file}" "${folder}"
        delete_folder "${file}"
    fi
}

move_serie() {
    if [ -z "$1" ]; then
        echo -e "$WHITE> Which chapter you want to move?$NC"
        exit -1
    fi

    if [[ -d $1 ]]; then
        file="$1/$(ls $1/ | grep $FILETYPE)"
    elif [[ -f $1 ]]; then
        file=$1
    else
        echo -e "$WHITE> $1 not found!$NC"
        exit 1
    fi

    name=$(get_name $1)
    season=$(get_season $1)

    check_and_move "${file}" "${name}" "${season}"
}

help() {
    echo -e "usage:\t[-s | --serie]\t\tto move a serie chapter"
    echo -e "\t[-m | --movie]\t\tto move a movie"
    echo -e "\t[-t | --filetype]\tto specify the file type to move"
    echo -e "\t[--force]\t\tto force execution with no asking"
}

ARG=""
FILE=""
FORCE=""
FILETYPE="mkv"
for (( i=1; i<=$#; i++)); do
    arg="${!i}"
    case "$arg" in
        --filetype | -t)
            i=$((i+1))
            if [ -z ${!i} ]; then
                help
            fi
            FILETYPE="${!i}"
            ;;
        --force)
            FORCE="true"
            ;;
        *)
            if [ -z "$ARG" ]; then
                i=$((i+1))
                FILE="${!i}"
                ARG=$arg
            else
                help
            fi
    esac
done
case "$ARG" in
    --serie | -s)
        move_serie "${FILE}"
        ;;
    --movie | -m)
        move_movie "${FILE}"
        ;;
    *)
        help $0
esac
