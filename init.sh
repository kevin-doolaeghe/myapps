#!/bin/bash

# Function to check if Docker is running with proper permissions
check_docker_permissions() {
    if ! sudo -v; then
        echo "You need sudo privileges to run Docker commands. Please ensure you have proper permissions."
        exit 1
    fi

    if ! groups $(whoami) | grep -q "\bdocker\b"; then
        echo "You are not in the Docker group. Adding you to the Docker group..."
        sudo usermod -aG docker $(whoami)
        echo "You have been added to the Docker group. Please log out and log back in, or run 'newgrp docker' to apply changes."
        exit 1
    fi
}

# Function to install Docker
setup_docker() {
    command -v docker > /dev/null 2>&1 || {
        echo "Docker is not installed. Installing Docker..."

        if ! curl -fsSL https://get.docker.com | sudo sh; then
            echo "Failed to install Docker. Please check your system's configuration."
            exit 1
        fi

        if ! sudo systemctl is-active --quiet docker; then
            echo "Docker service is not running. Starting Docker..."
            sudo systemctl start docker || {
                echo "Failed to start Docker service."
                exit 1
            }
        fi

        echo "Docker has been installed."
    }
}

# Function to initialize Docker Swarm
initialize_docker_swarm() {
    sudo docker info | grep -i swarm > /dev/null 2>&1 || {
        echo "Docker Swarm is not initialized. Initializing Docker Swarm..."

        while true; do
            read -p "Enter the default address pool (e.g., 10.10.0.0/16): " default_addr_pool
            if [[ $default_addr_pool =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$ ]]; then
                break
            else
                echo "Invalid address pool. Please try again."
            fi
        done

        while true; do
            read -p "Enter the advertise address (e.g., 10.0.0.252): " advertise_addr
            if [[ $advertise_addr =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
                break
            else
                echo "Invalid IP address. Please try again."
            fi
        done

        sudo docker swarm init --default-addr-pool $default_addr_pool --advertise-addr $advertise_addr || {
            echo "Failed to initialize Docker Swarm."
            exit 1
        }
        echo "Docker Swarm initialized."
    }
}

# Function to create a system user for Docker
create_docker_user() {
    docker_user="dockeruser"
    if ! id -u $docker_user > /dev/null 2>&1; then
        echo "Creating system user '$docker_user'..."

        sudo useradd -m -s /bin/bash $docker_user || {
            echo "Failed to create user '$docker_user'."
            exit 1
        }

        echo "Set a password for '$docker_user':"
        sudo passwd $docker_user

        if ! groups $docker_user | grep -q "\bdocker\b"; then
            sudo usermod -aG docker $docker_user
        fi
        
        echo "User '$docker_user' created and added to the 'docker' group."
    fi
}

# Function to initialize Docker secrets
initialize_docker_secrets() {
    initializing_secrets=false

    declare -A secrets=( 
        ["duckdns_token"]="Duck DNS token"
        ["username"]="username"
        ["password"]="password"
    )

    for secret in "${!secrets[@]}"; do
        if ! sudo docker secret ls | grep -w "$secret" > /dev/null 2>&1; then
            if ! $initializing_secrets; then
                echo "Initializing Docker secrets..."
                initializing_secrets=true
            fi

            while true; do
                read -s -p "Enter the ${secrets[$secret]}: " secret_value
                if [ -n "$secret_value" ]; then
                    echo "$secret_value" | sudo docker secret create "$secret" - || {
                        echo "Failed to create Docker secret '$secret'."
                        exit 1
                    }
                    echo "Docker secret '$secret' created."
                    break
                else
                    echo "${secrets[$secret]} cannot be empty. Please try again."
                fi
            done
        fi
    done

    if $initializing_secrets; then
        echo "Docker secrets initialized."
    fi
}

# Function to set environment variables for Docker
set_docker_environment_variables() {
    initializing_env_vars=false

    declare -A env_vars_1=( 
        [DOCKER_PUID]=$(id -u dockeruser)
        [DOCKER_PGID]=$(getent group docker | cut -d: -f3)
        [DOCKER_TZ]=$(cat /etc/timezone 2>/dev/null || timedatectl | grep "Time zone" | awk '{print $3}')
    )

    for var in "${!env_vars_1[@]}"; do
        if [ -z "${!var}" ]; then
            if ! $initializing_env_vars; then
                echo "Initializing Docker environment variables..."
                initializing_env_vars=true
            fi

            echo "Setting $var environment variable..."
            env_var_value="${env_vars_1[$var]}"
            export "$var"="$env_var_value"
            if ! grep -q "^export $var=" ~/.bashrc; then
                echo "export $var=$env_var_value" >> ~/.bashrc
            fi

            echo "$var set to ${!var}."
        fi
    done

    declare -A env_vars_2=( 
        [WIREGUARD_DOMAIN_NAME]="domain name used for WireGuard VPN"
        [TRAEFIK_DOMAIN_NAME]="domain name used for Traefik reverse-proxy"
    )

    for var in "${!env_vars_2[@]}"; do
        if [ -z "${!var}" ]; then
            if ! $initializing_env_vars; then
                echo "Initializing Docker environment variables..."
                initializing_env_vars=true
            fi

            while true; do
                read -p "Enter the ${env_vars_2[$var]}: " env_var_value
                if [[ "$env_var_value" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                    echo "Setting $var environment variable..."
                    export "$var"="$env_var_value"
                    if ! grep -q "^export $var=" ~/.bashrc; then
                        echo "export $var=$env_var_value" >> ~/.bashrc
                    fi
                    echo "$var set to ${!var}."
                    break
                else
                    echo "Invalid domain format. Please try again."
                fi
            done
        fi
    done
    
    declare -A env_vars_3=( 
        [DUCKDNS_EMAIL]="Duck DNS email address"
    )

    for var in "${!env_vars_3[@]}"; do
        if [ -z "${!var}" ]; then
            if ! $initializing_env_vars; then
                echo "Initializing Docker environment variables..."
                initializing_env_vars=true
            fi

            while true; do
                read -p "Enter the ${env_vars_3[$var]}: " env_var_value
                if [[ "$env_var_value" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
                    echo "Setting $var environment variable..."
                    export "$var"="$env_var_value"
                    if ! grep -q "^export $var=" ~/.bashrc; then
                        echo "export $var=$env_var_value" >> ~/.bashrc
                    fi
                    echo "$var set to ${!var}."
                    break
                else
                    echo "Invalid email address format. Please try again."
                fi
            done
        fi
    done

    if $initializing_env_vars; then
        echo "Docker environment variables initialized."
    fi
}

# Function to create the Docker network
create_docker_network() {
    DOCKER_NETWORK="docker_network"
    if ! sudo docker network inspect $DOCKER_NETWORK > /dev/null 2>&1; then
        echo "Creating $DOCKER_NETWORK network..."
        sudo docker network create --driver overlay --attachable $DOCKER_NETWORK || {
            echo "Failed to create Docker network '$DOCKER_NETWORK'."
            exit 1
        }
        echo "$DOCKER_NETWORK network created."

        echo "Setting DOCKER_NETWORK environment variable..."
        export DOCKER_NETWORK
        echo "export DOCKER_NETWORK=$DOCKER_NETWORK" >> ~/.bashrc
        echo "DOCKER_NETWORK set to $DOCKER_NETWORK."
    fi
}

# Main script execution
check_docker_permissions
setup_docker
initialize_docker_swarm
create_docker_user
initialize_docker_secrets
set_docker_environment_variables
create_docker_network
