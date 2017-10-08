#!/bin/bash

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
        else
            list="$list$i~~~->~~~$name\n"
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
        rename "${2}" "${3}"
        ;;
    --apply | -a)
        apply=true
        rename "${2}" "${3}" $apply
        ;;
    *)
        help $0
esac
