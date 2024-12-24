#!/bin/sh

if [ $# -ne 1 ]; then
 echo "Usage: ./down.sh <app>"
 exit 1
fi

app=$(echo "$1" | sed 's:/*$::')

docker stack rm $app

exit 0
