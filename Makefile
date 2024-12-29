# Docker environment deployment Makefile

# Makefile variables
STACKS := duckdns traefik portainer wireguard homepage

.PHONY: all init start stop clean status

all: start

# Initialize Docker environment
init:
	@printf "\033[1;33mInitializing Docker environment...\033[0m\n"
	@bash init.sh
	@printf "\033[1;33m\n► Initialization complete.\n\033[0m\n"

# Start Docker stacks
start: init
	@printf "\033[1;33mStarting Docker stacks...\n\033[0m\n"
	@for stack in $(STACKS); do \
		bash up.sh $$stack; \
	done
	@printf "\033[1;33m\n► Starting complete.\n\033[0m\n"

# Stop Docker stacks
stop:
	@printf "\033[1;33mStopping Docker stacks...\n\033[0m\n"
	@for stack in $(STACKS); do \
		bash down.sh $$stack; \
	done
	@printf "\033[1;33m\n► Stopping complete.\n\033[0m\n"

# Clean Docker environment
clean: stop
	@printf "\033[1;33mCleaning Docker environment...\033[0m\n"
	@echo "\nRemoving unused networks..."
	@docker network prune -f
	@echo "\nRemoving unused images..."
	@docker image prune -f
	@printf "\033[1;33m\n► Cleaning complete.\n\033[0m\n"

# Print Docker environment status
status:
	@printf "\033[1;33mDocker environment status:\033[0m\n"
	@printf "\n\033[1;33m· Stacks:\033[0m"
	@docker stack ls
	@printf "\n\033[1;33m· Services:\033[0m"
	@docker service ls
	@printf "\n\033[1;33m· Secrets:\033[0m"
	@docker secret ls
	@printf "\n\033[1;33m· Volumes:\033[0m"
	@docker volume ls
	@printf "\n\033[1;33m· Networks:\033[0m"
	@docker network ls
