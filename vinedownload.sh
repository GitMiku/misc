#!/bin/bash
#Downloads vine videos. Pretty damn self explanatory 
if [ -z "$1"]
then
    echo "Usage: $0 URL-to-vine-vid filename"
    echo "Example: $0 https://vine.co/v/MHQPKT6Y7de"
    echo "Example: $0 https://vine.co/v/MHQPKT6Y7de babyporcupine.mp4"
else
    URL=$(curl -s $1)
    if [ -z "$2" ]
    then
        wget $(echo -e "$URL"| grep twitter:player:stream  | head -1 | sed s/'<meta property="twitter:player:stream" content="'// | sed s/'">'//)
    else
        wget $(echo -e "$URL"| grep twitter:player:stream  | head -1 | sed s/'<meta property="twitter:player:stream" content="'// | sed s/'">'//) --output-document=$2
    fi
fi
