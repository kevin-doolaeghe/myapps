#!/bin/bash

g_env_file="/etc/environment"
g_docker_user="dockeruser"

g_reboot_required=false

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

        # Trim spaces and new lines
        input=$(echo "$input" | xargs | tr -d '\n')

        # Check if the input is valid
        if [[ $input =~ $regex ]]; then
            # Return valid input
            echo "$input"
            return
        else
            echo "Invalid input. Please try again." >&2
        fi
    done
}

# Function to set environment variable
set_environment_variable() {
    local var_name="$1"
    local var_value="$2"
    local env_file="$g_env_file"

    # Check if the variable is already in file
    if grep -Eq "^[^#]*\b${var_name}=" "$env_file"; then
        # Update the value if it's different
        if [ "$(sudo grep -E "^[^#]*\b${var_name}=" "$env_file" | cut -d'=' -f2-)" != "$var_value" ]; then
            sudo sed -i "s#^${var_name}=.*#${var_name}=${var_value}#" "$env_file"
            echo "Updated $var_name in $env_file"
        else
            return
        fi
    else
        # Append the new variable
        echo "${var_name}=${var_value}" | sudo tee -a "$env_file" > /dev/null
        echo "Added $var_name to $env_file"
    fi

    # Export for parent session
    export "${var_name}=${var_value}"
    g_reboot_required=true
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
    printf "$secret_value" | sudo docker secret create "$secret_name" - || {
        echo -e "\033[0;35m✗\033[0m \033[1;31mFailed to create Docker secret '$secret_name'.\033[0m"
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

# Function to check permissions
check_permissions() {
    echo -e "\033[0;36m①\033[0m \033[1;36mPermissions\033[0m"

    # Check for permissions
    if ! sudo -v; then
        echo -e "\033[0;35m✗\033[0m \033[1;31mYou need sudo privileges to run Docker commands. Please ensure you have proper permissions.\033[0m"
        exit 1
    fi
    
    echo -e "\033[0;35m✓\033[0m \033[1;32mTask completed successfully.\033[0m"
}

# Function to install Docker
install_docker() {
    echo -e "\033[0;36m②\033[0m \033[1;36mDocker setup\033[0m"
    
    # Check if Docker is installed
    if ! command -v docker > /dev/null 2>&1; then
        # Install Docker
        echo "Docker is not installed. Installing Docker..."
        if ! curl -fsSL https://get.docker.com | sudo sh; then
            echo -e "\033[0;35m✗\033[0m \033[1;31mFailed to install Docker. Please check your system's configuration.\033[0m"
            exit 1
        fi
        echo "Docker has been installed."

        # Start Docker service
        if ! sudo systemctl is-active --quiet docker; then
            echo "Docker service is not running. Starting Docker..."
            sudo systemctl start docker || {
                echo -e "\033[0;35m✗\033[0m \033[1;31mFailed to start Docker service.\033[0m"
                exit 1
            }
        fi
        echo "Docker service is running."
    fi

    echo -e "\033[0;35m✓\033[0m \033[1;32mTask completed successfully.\033[0m"
}

# Function to initialize Docker Swarm
initialize_docker_swarm() {
    echo -e "\033[0;36m③\033[0m \033[1;36mDocker Swarm setup\033[0m"

    local default_addr_pool
    local advertise_addr

    # Check if Docker Swarm is initialized
    if sudo docker info 2>/dev/null | grep -iq "Swarm: inactive"; then
        echo "Docker Swarm is not initialized. Initializing Docker Swarm..."

        # Read the default address pool and advertise address for Docker Swarm
        default_addr_pool=$(read_with_regex "Enter the default address pool" "^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}\$" "10.10.0.0/16")
        advertise_addr=$(read_with_regex "Enter the advertise address" "^([0-9]{1,3}\.){3}[0-9]{1,3}\$" "10.0.0.252")

        # Initialize Docker Swarm
        sudo docker swarm init --default-addr-pool $default_addr_pool --advertise-addr $advertise_addr || {
            echo -e "\033[0;35m✗\033[0m \033[1;31mFailed to initialize Docker Swarm.\033[0m"
            exit 1
        }
        echo "Docker Swarm initialized."
    fi

    echo -e "\033[0;35m✓\033[0m \033[1;32mTask completed successfully.\033[0m"
}

# Function to create a system user for Docker
create_docker_user() {
    echo -e "\033[0;36m④\033[0m \033[1;36mDocker service user\033[0m"

    local docker_user="$g_docker_user"

    # Check if the system user exists
    if ! id -u $docker_user > /dev/null 2>&1; then
        # Create a new user
        echo "Creating system user '$docker_user'..."
        sudo useradd -r -M -N -s /bin/bash $docker_user || {
            echo -e "\033[0;35m✗\033[0m \033[1;31mFailed to create user '$docker_user'.\033[0m"
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

    # Check if the user belongs to the 'docker' group
    if ! groups $docker_user | grep -q "\bdocker\b"; then
        # Add the user to the 'docker' group
        echo "User '$docker_user' is not in the 'docker' group. Adding user to the 'docker' group..."
        sudo usermod -aG docker $docker_user
        echo "User '$docker_user' added to the 'docker' group."
        
        # Set the 'DOCKER_PGID' environment variable
        echo "Updating DOCKER_PGID environment variable..."
        set_environment_variable_with_command "DOCKER_PGID" "$(getent group docker | cut -d: -f3)"
    fi

    echo -e "\033[0;35m✓\033[0m \033[1;32mTask completed successfully.\033[0m"
}

# Function to initialize Docker secrets
initialize_docker_secrets() {
    echo -e "\033[0;36m⑤\033[0m \033[1;36mDocker secrets\033[0m"

    local username
    local password
    local wireguard_password_hash
    local basicauth_password_hash

    set_docker_secret_with_prompt_and_regex "duckdns_token" "Enter the Duck DNS token" "[a-zA-Z0-9-]+"

    if ! sudo docker secret ls | grep -w "username" > /dev/null 2>&1; then
        username=$(read_with_regex "Enter the username" "^[a-zA-Z0-9]{4,}\$")
        
        set_docker_secret "username" "$username"
        set_environment_variable "BASICAUTH_USERNAME" "$username"
    fi

    if ! sudo docker secret ls | grep -w "password" > /dev/null 2>&1; then
        password=$(read_with_regex "Enter the password" "^[A-Za-z0-9@\$!%*?&]{6,}\$")
        wireguard_password_hash=$(docker run --rm -it ghcr.io/wg-easy/wg-easy wgpw "$password" | grep -oP "PASSWORD_HASH='.*'" | sed "s/PASSWORD_HASH='//;s/'$//")
        basicauth_password_hash=$(docker run --rm --name apache httpd:alpine htpasswd -nb admin $password | cut -d: -f2)

        set_docker_secret "password" "$password"
        set_environment_variable "WIREGUARD_PASSWORD_HASH" "$wireguard_password_hash"
        set_environment_variable "BASICAUTH_PASSWORD_HASH" "$basicauth_password_hash"
    fi

    echo -e "\033[0;35m✓\033[0m \033[1;32mTask completed successfully.\033[0m"
}

# Function to set environment variables for Docker
set_docker_environment_variables() {
    echo -e "\033[0;36m⑥\033[0m \033[1;36mDocker environment variables\033[0m"

    set_environment_variable_with_command "DOCKER_TZ" "$(cat /etc/timezone 2>/dev/null || timedatectl | grep "Time zone" | awk '{print $3}')"

    set_environment_variable_with_prompt_and_regex "WIREGUARD_DOMAIN_NAME" "Enter the domain name used for WireGuard VPN" "^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$"
    set_environment_variable_with_prompt_and_regex "TRAEFIK_DOMAIN_NAME" "Enter the domain name used for Traefik reverse-proxy" "^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$"
    set_environment_variable_with_prompt_and_regex "DUCKDNS_EMAIL" "Enter the Duck DNS email address" "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$"
    
    echo -e "\033[0;35m✓\033[0m \033[1;32mTask completed successfully.\033[0m"
}

# Function to create the Docker network
create_docker_network() {
    echo -e "\033[0;36m⑦\033[0m \033[1;36mDocker network\033[0m"

    local docker_network="docker_network"
    
    # Check if the Docker network exists
    if ! sudo docker network inspect $docker_network > /dev/null 2>&1; then
        # Create the Docker network
        echo "Creating $docker_network network..."
        sudo docker network create --driver overlay --attachable $docker_network || {
            echo -e "\033[0;35m✗\033[0m \033[1;31mFailed to create Docker network '$docker_network'.\033[0m"
            exit 1
        }
        echo "$docker_network network created."

        # Set the 'DOCKER_NETWORK' environment variable
        echo "Updating DOCKER_NETWORK environment variable..."
        set_environment_variable "DOCKER_NETWORK" "$docker_network"
    fi

    echo -e "\033[0;35m✓\033[0m \033[1;32mTask completed successfully.\033[0m"
}

# Function to ask the user to reboot the system if required
reboot_system() {
    if [ "$g_reboot_required" = true ]; then
        echo -e "\033[0;33mYou need to restart the system to apply the changes.\033[0m"
        read -p "Do you want to reboot now? [y/N]: " answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            sudo reboot
            exit 0
        fi
        echo -e "\033[0;35m✗\033[0m \033[1;33mPlease reboot your system before restarting the installation process.\033[0m"
        exit 1
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
reboot_system
