#!/bin/bash
if [ -z "$1" ]
then
    echo "This script downloads all files (including webm) from a 4chan thread"
    echo "Usage: $0 URL"
    echo "Optionally you can take a screenshot of the thread too with (requires cutycapt to be installed):"
    echo "$0 -s URL"
    exit 1
else
    if [ "$1" == "-s" ]
    then
        url=$2
    else
        url=$1
    fi
    screenshot=$(echo $url | sed s/'http:\/\/'// | sed s/'boards.4chan.org'// | sed s/'\/'/-/g | cut -d'-' -f2-10).png
    thread=$(curl -s --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36" $url)
    files=$(echo $thread | tr '>' '\n' | grep 'File:' | sed s/title=// | cut -d'=' -f2 | sed s/'"\/\/'// | cut -d'"' -f1)
    for i in $(echo -e "$files")
    do
        wget $i &
        shift
    done
    wait

    if [ "$url" == "$2" ]
    then
        cutycapt --url=$url --out=$screenshot
    fi
fi
