#!/bin/bash

# Check if exactly one argument is provided
if [[ "$#" -ne 1 ]]; then
    echo -e "\033[1;33mUsage:\033[0m \033[0;36m./\033[1m\033[1;36mup\033[0;36m.\033[1msh\033[0m \033[0;36m<\033[0m\033[1;36mstack\033[0m\033[0;36m>\033[0m"
    exit 1
fi

# Trim trailing slashes from the stack name
stack="${1%/}"
compose_file="$stack/docker-compose.yml"

# Start the stack if the docker-compose.yml file exists
if [[ -f "$compose_file" ]]; then
    if docker stack deploy -c "$compose_file" --detach "$stack"; then
        echo -e "\033[0;35m✓\033[0m \033[1;32mStarted $stack stack.\033[0m"
        exit 0
    else
        echo -e "\033[0;35m✗\033[0m \033[1;31mFailed to start $stack stack.\033[0m"
        exit 1
    fi
else
    echo -e "\033[0;35m✗\033[0m \033[1;30mNo\033[0m \033[1;36mdocker-compose\033[0m\033[0;36m.\033[0m\033[1;36myml\033[0m \033[1;30mfile found for $stack.\033[0m Skipping..."
    exit 0
fi
