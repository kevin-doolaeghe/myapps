#!/bin/sh

if [ $# -ne 1 ]; then
 echo "Usage: ./down.sh <stack>"
 exit 0
fi

stack=$(echo "$1" | sed 's:/*$::')

if docker stack ls | grep -w $stack > /dev/null; then
    docker stack rm $stack && echo "Stack $stack stopped."
else
    echo "The stack $stack is not running."
fi
exit 1
