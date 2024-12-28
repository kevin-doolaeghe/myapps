#!/bin/sh

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: ./down.sh <stack>"
    exit 1
fi

# Trim trailing slashes from the stack name
stack=$(echo "$1" | sed 's:/*$::')

# Stop the stack if it is running
if docker stack ls | grep -qw "$stack"; then
    if docker stack rm "$stack"; then
        echo "Stack $stack stopped."
        exit 0
    else
        echo "Failed to stop stack $stack."
        exit 1
    fi
else
    echo "The stack $stack is not running."
    exit 1
fi
