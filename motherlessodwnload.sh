#!/bin/bash
if [ -z "$1"]
then
    echo "Usage: $0 link-motherless-vid filename"
else
    URL=$(curl -s $1)
    TIDYURL=$(echo -e "$URL" | grep '"file"' | grep motherlessmedia | tr -d ' ' | sed s/'"file":"'// | sed s/'",'//)
    if [ -z "$2" ]
    then
        wget --referer=motherless.com --user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36" $TIDYURL
    else
        wget --referer=motherless.com --user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36" $TIDYURL --output-document=$2
    fi
fi
