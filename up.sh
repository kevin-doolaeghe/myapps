#!/bin/sh

if [ $# -ne 1 ]; then
 echo "Usage: ./up.sh <stack>"
 exit 0
fi

stack=$(echo "$1" | sed 's:/*$::')
compose_file="$stack/docker-compose.yml"

if [ -f $compose_file ]; then
    docker stack deploy -c $compose_file $stack && echo "Started $stack stack."
else
    echo "No docker-compose.yml file found for $stack."
fi
exit 1
