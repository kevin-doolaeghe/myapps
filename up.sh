#!/bin/sh

if [ $# -ne 1 ]; then
 echo "Usage: ./up.sh <app>"
 exit 1
fi

app=$(echo "$1" | sed 's:/*$::')

file="$app/docker-compose.yml"
docker stack deploy -c $file -d $app

exit 0
