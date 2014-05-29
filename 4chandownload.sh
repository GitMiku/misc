#!/bin/bash
if [ -z "$1" ]
then
    echo "This script downloads all files (including webm) from a 4chan thread"
    echo "Usage: $0 URL"
    exit 1
else
    thread=$(curl -s --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36" $1)
    files=$(echo $thread | tr '>' '\n' | grep 'File:' | sed s/title=// | cut -d'=' -f2 | sed s/'"\/\/'// | cut -d'"' -f1)
    for i in $(echo -e "$files")
    do
        wget $i
    done
fi
