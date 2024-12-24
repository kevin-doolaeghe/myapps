#!/bin/sh

if [ $# -ne 1 ]; then
 echo "Usage: ./detach.sh <app>"
 exit 1
fi

app=$(echo "$1" | sed 's:/*$::')

network="$app_local"
docker network disconnect $network nginxproxymanager

exit 0
