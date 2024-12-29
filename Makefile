# Docker environment deployment Makefile

# Makefile variables
STACKS := duckdns traefik portainer wireguard homepage

.PHONY: all init start stop clean status

all: start

# Initialize Docker environment
init:
	@printf "\033[1;33mInitializing Docker environment...\033[0m\n"
	@bash init.sh
	@printf "\n\033[1;33m► Initialization complete.\033[0m\n\n"

# Start Docker stacks
start: init
	@printf "\033[1;33mStarting Docker stacks...\033[0m\n\n"
	@for stack in $(STACKS); do \
		bash up.sh $$stack; \
	done
	@printf "\n\033[1;33m► Starting complete.\033[0m\n\n"

# Stop Docker stacks
stop:
	@printf "\033[1;33mStopping Docker stacks...\033[0m\n\n"
	@for stack in $(STACKS); do \
		bash down.sh $$stack; \
	done
	@printf "\n\033[1;33m► Stopping complete.\033[0m\n\n"

# Clean Docker environment
clean: stop
	@printf "\033[1;33mCleaning Docker environment...\033[0m\n"
	@echo "\nRemoving unused networks..."
	@docker network prune -f
	@echo "\nRemoving unused images..."
	@docker image prune -f
	@printf "\n\033[1;33m► Cleaning complete.\033[0m\n\n"

# Print Docker environment status
status:
	@printf "\033[1;33mDocker environment status:\033[0m\n"
	@printf "\n\033[1;33m· Stacks:\033[0m\n"
	@docker stack ls
	@printf "\n\033[1;33m· Services:\033[0m\n"
	@docker service ls
	@printf "\n\033[1;33m· Secrets:\033[0m\n"
	@docker secret ls
	@printf "\n\033[1;33m· Volumes:\033[0m\n"
	@docker volume ls
	@printf "\n\033[1;33m· Networks:\033[0m\n"
	@docker network ls
