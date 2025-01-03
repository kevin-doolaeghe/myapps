#!/bin/bash

env_file="/etc/environment"

# Function to reload environment variables
reload_environment_variables() {
    # Check if the file exists
    if [ -f "$env_file" ]; then
        echo "Reloading environment variables from $env_file"
        
        # Read the environment file line by line
        while IFS= read -r line; do
            # Skip comments and empty lines
            if [[ "$line" =~ ^# || -z "$line" ]]; then
                continue
            fi
            # Export valid KEY=VALUE pairs
            export "$line"
        done < "$env_file"
    else
        echo "Environment file not found: $env_file"
    fi
}

# Call the function
reload_environment_variables
