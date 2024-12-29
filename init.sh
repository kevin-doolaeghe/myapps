#!/bin/bash

# Function to check permissions
check_permissions() {
    if ! sudo -v; then
        echo "You need sudo privileges to run Docker commands. Please ensure you have proper permissions."
        exit 1
    fi
}

# Function to read input with regex validation
read_with_regex() {
    local prompt="$1"
    local regex="$2"
    local default="$3"
    local input

    while true; do
        # Read user input
        if [[ -n $default ]]; then
            read -p "$prompt (default: $default): " input
            # Use default if input is empty
            input="${input:-$default}"
        else
            read -p "$prompt: " input
        fi

        # Trim spaces from both ends
        input = $(echo "$input" | xargs)

        # Check if the input is valid
        if [[ $input =~ $regex ]]; then
            # Return valid input
            echo "$input"
            return
        else
            echo "Invalid input. Please try again."
        fi
    done
}

# Function to set environment variable
set_environment_variable() {
    local var_name="$1"
    local var_value="$2"
    local env_file="/etc/environment"

    # Check if the variable is already in file
    if grep -Eq "^[^#]*\b${var_name}=" "$env_file"; then
        # Update the value if it's different
        if [ "$(sudo grep -E "^[^#]*\b${var_name}=" "$env_file" | cut -d'=' -f2-)" != "$var_value" ]; then
            sudo sed -i "s#^${var_name}=.*#${var_name}=${var_value}#" "$env_file"
            echo "Updated $var_name in $env_file"
        fi
    else
        # Append the new variable
        echo "${var_name}=${var_value}" | sudo tee -a "$env_file" > /dev/null
        echo "Added $var_name to $env_file"
    fi

    # Export for current session
    export "${var_name}=${var_value}"
}

# Function to set environment variable with command
set_environment_variable_with_command() {
    local var_name="$1"
    local command="$2"
    local var_value

    # Check if the variable is already set
    if [ -z "${!var_name}" ]; then
        var_value="${command}"
        set_environment_variable "$var_name" "$var_value"
    fi
}

# Function to set environment variable with prompt and regex
set_environment_variable_with_prompt_and_regex() {
    local var_name="$1"
    local prompt="$2"
    local regex="$3"
    local default="$4"
    local var_value

    # Check if the variable is already set
    if [ -z "${!var_name}" ]; then
        var_value=$(read_with_regex "$prompt" "$regex" "$default")
        set_environment_variable "$var_name" "$var_value"
    fi
}

# Function to set Docker secret
set_docker_secret() {
    local secret_name="$1"
    local secret_value="$2"

    # Create the Docker secret
    echo "$secret_value" | sudo docker secret create "$secret_name" - || {
        echo "Failed to create Docker secret '$secret_name'."
        exit 1
    }
    echo "Docker secret '$secret_name' created."
}

# Function to set Docker secret with prompt and regex
set_docker_secret_with_prompt_and_regex() {
    local secret_name="$1"
    local prompt="$2"
    local regex="$3"
    local default="$4"
    local secret_value

    # Check if the secret is already set
    if ! sudo docker secret ls | grep -w "$secret_name" > /dev/null 2>&1; then
        secret_value=$(read_with_regex "$prompt" "$regex" "$default")
        set_docker_secret "$secret_name" "$secret_value"
    fi
}

# Function to install Docker
install_docker() {
    # Check if Docker is installed
    command -v docker > /dev/null 2>&1 || {
        # Install Docker
        echo "Docker is not installed. Installing Docker..."
        if ! curl -fsSL https://get.docker.com | sudo sh; then
            echo "Failed to install Docker. Please check your system's configuration."
            exit 1
        fi
        echo "Docker has been installed."

        # Start Docker service
        if ! sudo systemctl is-active --quiet docker; then
            echo "Docker service is not running. Starting Docker..."
            sudo systemctl start docker || {
                echo "Failed to start Docker service."
                exit 1
            }
        fi
        echo "Docker service is running."
    }
}

# Function to initialize Docker Swarm
initialize_docker_swarm() {
    local default_addr_pool
    local advertise_addr

    # Check if Docker Swarm is initialized
    sudo docker info | grep -i swarm > /dev/null 2>&1 || {
        echo "Docker Swarm is not initialized. Initializing Docker Swarm..."

        # Read the default address pool and advertise address for Docker Swarm
        default_addr_pool=$(read_with_regex "Enter the default address pool" "^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}\$" "10.10.0.0/16")
        advertise_addr=$(read_with_regex "Enter the advertise address" "^([0-9]{1,3}\.){3}[0-9]{1,3}\$" "10.0.0.252")

        # Initialize Docker Swarm
        sudo docker swarm init --default-addr-pool $default_addr_pool --advertise-addr $advertise_addr || {
            echo "Failed to initialize Docker Swarm."
            exit 1
        }
        echo "Docker Swarm initialized."
    }
}

# Function to create a system user for Docker
create_docker_user() {
    local docker_user="dockeruser"

    # Check if the system user exists
    if ! id -u $docker_user > /dev/null 2>&1; then
        # Create a new user
        echo "Creating system user '$docker_user'..."
        sudo useradd -m -s /bin/bash $docker_user || {
            echo "Failed to create user '$docker_user'."
            exit 1
        }
        echo "User '$docker_user' created."

        # Set a password for the user
        echo "Set a password for '$docker_user':"
        sudo passwd $docker_user

        # Set the 'DOCKER_PUID' environment variable
        echo "Updating DOCKER_PUID environment variable..."
        set_environment_variable_with_command "DOCKER_PUID" "$(id -u dockeruser)"
    fi

    # Check if the user is in the 'docker' group
    if ! groups $docker_user | grep -q "\bdocker\b"; then
        # Add the user to the 'docker' group
        echo "User '$docker_user' is not in the 'docker' group. Adding user to the 'docker' group..."
        sudo usermod -aG docker $docker_user
        echo "User '$docker_user' added to the 'docker' group."
        
        # Set the 'DOCKER_PGID' environment variable
        echo "Updating DOCKER_PGID environment variable..."
        set_environment_variable_with_command "DOCKER_PGID" "$(getent group docker | cut -d: -f3)"
    fi
}

# Function to initialize Docker secrets
initialize_docker_secrets() {
    echo "Checking for existing Docker secrets..."

    set_docker_secret_with_prompt_and_regex "duckdns_token" "Enter the Duck DNS token" "^[a-zA-Z0-9]{32}\$"
    set_docker_secret_with_prompt_and_regex "username" "Enter the username" "^[a-zA-Z0-9]{4,}\$"
    set_docker_secret_with_prompt_and_regex "password" "Enter the password" "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{8,20}\$"
}

# Function to set environment variables for Docker
set_docker_environment_variables() {
    echo "Checking for Docker environment variables..."

    set_environment_variable_with_command "DOCKER_TZ" "$(cat /etc/timezone 2>/dev/null || timedatectl | grep "Time zone" | awk '{print $3}')"

    set_environment_variable_with_prompt_and_regex "WIREGUARD_DOMAIN_NAME" "Enter the domain name used for WireGuard VPN" "^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$"
    set_environment_variable_with_prompt_and_regex "TRAEFIK_DOMAIN_NAME" "Enter the domain name used for Traefik reverse-proxy" "^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$"
    set_environment_variable_with_prompt_and_regex "DUCKDNS_EMAIL" "Enter the Duck DNS email address" "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$"
}

# Function to create the Docker network
create_docker_network() {
    local docker_network="docker_network"
    
    # Check if the Docker network exists
    if ! sudo docker network inspect $docker_network > /dev/null 2>&1; then
        # Create the Docker network
        echo "Creating $docker_network network..."
        sudo docker network create --driver overlay --attachable $docker_network || {
            echo "Failed to create Docker network '$docker_network'."
            exit 1
        }
        echo "$docker_network network created."

        # Set the 'DOCKER_NETWORK' environment variable
        echo "Updating DOCKER_NETWORK environment variable..."
        set_environment_variable "DOCKER_NETWORK" "$docker_network"
    fi
}

# Main script execution
check_permissions
install_docker
initialize_docker_swarm
create_docker_user
initialize_docker_secrets
set_docker_environment_variables
create_docker_network
