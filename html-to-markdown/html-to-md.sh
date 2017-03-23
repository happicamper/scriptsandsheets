#!/bin/bash
# This is dependent to git@github.com:aaronsw/html2text.git repository
# credits to aaronsw

while IFS='' read -r eachline || [[ -n "$eachline" ]] || [[ -n $newname ]]; do
    echo "Text read from file: $eachline"
    newname=$(echo $eachline | awk -F '.' '{print $1".md"}')
    /home/html2text/html2text.py $eachline > $newname
done < "$1"
