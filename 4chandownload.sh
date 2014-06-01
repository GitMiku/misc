#!/bin/bash
numberofargs=$# 
eval "url=${!numberofargs}" #URL is the last argument
usage() 
{
    cat <<- EOF
    This script downloads all files (including webm) from a 4chan thread
    Usage: $0 [options] URL

    Options:
    -s --screenshot            Saves a screenshot of the thread with cutycapt (apt-get install cutycapt)
    -m --html                  Saves the HTML page of the thread
    -h --help                  Shows this help
    
    Examples:

    Save a screenshot, the HTML, and the files of this battlestation thread
    $0 -s -h http://boards.4chan.org/g/thread/42228653/battlestations
    
    Save a screenshot and the files of the thread
    $0 --screenshot http://boards.4chan.org/g/thread/42228653/battlestations
    
    Save the HTML and the files of the thread
    $0 --html http://boards.4chan.org/g/thread/42228653/battlestations
EOF
}

if [ -z "$1" ] #If no command line arguments
then
    usage
fi

for i in $(seq 1 $numberofargs)
do
    eval "currentarg=${!i}" #Holds the current argument
    if [[ "$currentarg" == "-s" ]] || [[ "$currentarg" == "--screenshot" ]]
    then
        #screenshot=board-thread-threadID-title.png
        screenshot=$(echo $url | sed s/'http:\/\/'// | sed s/'boards.4chan.org'// | sed s/'\/'/-/g | cut -d'-' -f2-10).png
        cutycapt --url=$url --out=$screenshot #Screenshot the page
    fi
    
    if [[ "$currentarg" == "-m" ]] || [[ "$currentarg" == "--html" ]]
    then
        #html=board-thread-threadID-title.html
        html=$(echo $url | sed s/'http:\/\/'// | sed s/'boards.4chan.org'// | sed s/'\/'/-/g | cut -d'-' -f2-10).html
        curl -s $url | sed s/'="\/\/'/'="http:\/\/'/g > $html #Find and fix all links on the page then write to $html
    fi

    if [[ "$currentarg" == "-h" ]] || [[ "$currentarg" == "--help" ]]
    then
        usage
    fi
done

#thread holds the html document
thread=$(curl -s --user-agent "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36" $url)
    
#in files we extract the file URLs from $thread
files=$(echo $thread | tr '>' '\n' | grep 'File:' | sed s/title=// | cut -d'=' -f2 | sed s/'"\/\/'// | cut -d'"' -f1)
    
for i in $(echo -e "$files")
do
    wget --no-verbose $i & #Put the wget process in the background
    shift #And move on to the next
done
wait
exit 0




