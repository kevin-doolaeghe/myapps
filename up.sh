#!/bin/sh

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: ./up.sh <stack>"
    exit 1
fi

# Trim trailing slashes from the stack name
stack=$(echo "$1" | sed 's:/*$::')
compose_file="$stack/docker-compose.yml"

# Start the stack if the docker-compose.yml file exists
if [ -f "$compose_file" ]; then
    if docker stack deploy -c "$compose_file" "$stack"; then
        echo "Started $stack stack."
        exit 0
    else
        echo "Failed to start $stack stack."
        exit 1
    fi
else
    echo "No docker-compose.yml file found for $stack."
    exit 1
fi
