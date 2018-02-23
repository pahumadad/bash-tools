#!/bin/bash

rename_batch() {
    input=$1
    OLDIFS=$IFS
    IFS=,
    [ ! -f $input ] && { echo "$input file not found"; exit 99; }
    while read old new
    do
        if [ $2 ]; then
            rename "$old" "$new" "$2"
        else
            rename "$old" "$new"
        fi
    done < $input
    IFS=$OLDIFS 
}

rename() {
    RED="\033[0;31m"
    NC="\033[0m"
    for i in *; do
        name=${i//${1}/${2}}
        if [ "$i" != "$name" ]; then
            list="$list$i~~~->~~~${RED}$name${NC}\n"
            if [ ! -z $3 ]; then
                mv "$i" "$name"
            fi
        fi
    done

    echo -e $list | column -s "~~~" -t
}

help() {
    echo "Usage $1 {options}:"
    echo -e "-s, --simulate\tSimulate output"
    echo -e "-a, --apply\tApply rename"
    echo -e "-h, --help\tShow this help and exit"
}

case "$1" in
    --simulate | -s)
        rename_batch "${2}"
        ;;
    --apply | -a)
        apply=true
        rename_batch "${2}" $apply
        ;;
    *)
        help $0
esac
