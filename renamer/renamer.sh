#!/bin/bash

rename_batch() {
    IFS=,
    [ ! -f $FILE ] && { echo "$input file not found"; exit 99; }

    while read -r old new || [ -n "$old" ]
    do
        STR1="$old"
        STR2="$new"
        rename
    done < $FILE
}

rename() {
    RED="\033[0;31m"
    NC="\033[0m"
    for i in *; do
        name=${i//${STR1}/${STR2}}
        if [ "$i" != "$name" ]; then
            list="$list$i~~~->~~~${RED}$name${NC}\n"
            if [ "$APPLY" = "true" ]; then
                mv "$i" "$name"
            fi
        fi
    done

    echo -e $list | column -s "~~~" -t
}

help() {
    echo -e "usage:"
    echo -e "\t[-a | --apply]\t\tto apply the rename. By default will only simulate and show the results"
    echo -e "\t[-s1 | --str1 STRING1]\tSTRING1 is the string to look for in files names to be replaced"
    echo -e "\t[-s2 | --str2 STRING2]\tSTRING2 is the string to replace in the files names"
    echo -e "\t[-f | --file FILE]\tabsolute path to the CSV file with STRING1 and STRING2 rows"
    exit 0
}

FILE=""
STR1=""
STR2=""
APPLY="false"
for (( i=1; i<=$#; i++)); do
    arg="${!i}"
    case "$arg" in
        --apply | -a)
            APPLY="true"
            ;;
        --file | -f)
            i=$((i+1))
            FILE="${!i}"
            ;;
        --str1 | -s1)
            i=$((i+1))
            STR1="${!i}"
            ;;
        --str2 | -s2)
            i=$((i+1))
            STR2="${!i}"
            ;;
        *)
            help
    esac
done

if [ ! -z $FILE ]; then
    rename_batch
elif [ ! -z "${STR1}" ] && [ ! -z "${STR2}" ]; then
    rename
else
    help
fi
