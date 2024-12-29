#!/bin/bash

# Check if exactly one argument is provided
if [[ "$#" -ne 1 ]]; then
    echo "\033[1;33mUsage:\033[0m \033[0;36m./up.sh\033[0m \033[1;36m<stack>\033[0m"
    exit 1
fi

# Trim trailing slashes from the stack name
stack="${1%/}"
compose_file="$stack/docker-compose.yml"

# Start the stack if the docker-compose.yml file exists
if [[ -f "$compose_file" ]]; then
    if docker stack deploy -c "$compose_file" --detach "$stack"; then
        echo -e "\033[1;32m✓ Started $stack stack.\033[0m"
        exit 0
    else
        echo -e "\033[1;31m✗ Failed to start $stack stack.\033[0m"
        exit 1
    fi
else
    echo -e "\033[1;30m✗ No docker-compose.yml file found for $stack. Skipping...\033[0m"
    exit 0
fi
