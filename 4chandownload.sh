#!/bin/bash
if [ -z "$1" ] #If no command line arguments
then
    echo "This script downloads all files (including webm) from a 4chan thread"
    echo "Usage: $0 URL"
    echo "Optionally you can take a screenshot of the thread too with (requires cutycapt to be installed):"
    echo "$0 -s URL"
    exit 1
else
    if [ "$1" == "-s" ] #If the first command line argument is "-s"
    then
        url=$2 #Then we set URL to the second command line argument
    else
        url=$1 #Otherwise we set it to the first command line argument
    fi
    #The outfile here. It should look like board-thread-threadnumber-threadname.png
    #Example g-thread-42195412-desktop-thread.png
    screenshot=$(echo $url | sed s/'http:\/\/'// | sed s/'boards.4chan.org'// | sed s/'\/'/-/g | cut -d'-' -f2-10).png
    #thread holds the html document
    thread=$(curl -s --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36" $url)
    #in files we extract the file URLs from $thread
    files=$(echo $thread | tr '>' '\n' | grep 'File:' | sed s/title=// | cut -d'=' -f2 | sed s/'"\/\/'// | cut -d'"' -f1)
    for i in $(echo -e "$files") 
    do
        wget $i & #Put the wget process in the background
        shift #And move on to the next
    done
    wait

    if [ "$url" == "$2" ]
    then
        cutycapt --url=$url --out=$screenshot 
    fi
fi
