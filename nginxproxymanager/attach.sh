#!/bin/sh

if [ $# -ne 1 ]; then
 echo "Usage: ./attach.sh <app>"
 exit 1
fi

app=$(echo "$1" | sed 's:/*$::')

network="$app_local"
docker network connect $network nginxproxymanager

exit 0
