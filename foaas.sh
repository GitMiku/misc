#!/bin/bash
function help 
{
    echo "Provides a command line interface to Fuck off As A Service." 
    echo "http://foaas.herokuapp.com/"
    echo "Example: $0 /off/John/Dave"
    echo "Fuck off, John. - Dave"
}

response=$(curl -s --header '"Accept", "text/plain"' http://foaas.herokuapp.com$1)
if [ -z "$1"  ]
then
    help
    exit 1
fi
if [ $(echo -e "$response" | wc -l) -gt 1 ] 
then
    help
    exit 1
else
    echo $response
fi
