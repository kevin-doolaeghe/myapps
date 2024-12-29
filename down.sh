#!/bin/bash

# Check if exactly one argument is provided
if [[ "$#" -ne 1 ]]; then
    echo "\033[1;33mUsage:\033[0m \033[0;36m./down.sh\033[0m \033[1;36m<stack>\033[0m"
    exit 1
fi

# Trim trailing slashes from the stack name
stack="${1%/}"

# Stop the stack if it is running
if docker stack ls | grep -qw "$stack"; then
    if docker stack rm "$stack"; then
        echo -e "\033[1;32m✓ Stack $stack stopped.\033[0m"
        exit 0
    else
        echo -e "\033[1;31m✗ Failed to stop stack $stack.\033[0m"
        exit 1
    fi
else
    echo -e "\033[1;32m✓ The stack $stack is not running.\033[0m"
    exit 0
fi
