# Docker environment deployment Makefile

# Makefile variables
STACKS := duckdns traefik portainer wireguard homepage

.PHONY: all init start stop clean status

all: start

# Initialize Docker environment
init:
	@printf "\033[0;33mⓘ\033[0m \033[1;33mInitializing Docker environment...\033[0m\n"
	@source /etc/environment
	@bash init.sh
	@source /etc/environment
	@printf "\n\033[0;33m► Initialization completed successfully.\033[0m\n"

# Start Docker stacks
start: init
	@printf "\n\033[0;33mⓘ\033[0m \033[1;33mStarting Docker stacks...\033[0m\n"
	@for stack in $(STACKS); do \
		bash up.sh $$stack; \
	done
	@printf "\n\033[0;33m► Starting completed successfully.\033[0m\n"

# Stop Docker stacks
stop:
	@printf "\033[0;33mⓘ\033[0m \033[1;33mStopping Docker stacks...\033[0m\n"
	@for stack in $(STACKS); do \
		bash down.sh $$stack; \
	done
	@printf "\n\033[0;33m► Stopping completed successfully.\033[0m\n"

# Clean Docker environment
clean: stop
	@printf "\n\033[0;33mⓘ\033[0m \033[1;33mCleaning Docker environment...\033[0m"
	@printf "\n\033[1;30mRemoving unused networks...\033[0m\n"
	@docker network prune -f
	@printf "\n\033[1;30mRemoving unused images...\033[0m\n"
	@docker image prune -f
	@printf "\n\033[0;33m► Cleaning completed successfully.\033[0m\n"

# Print Docker environment status
status:
	@printf "\033[0;33mⓘ\033[0m \033[1;33mPrinting Docker environment status:\033[0m\n"
	@printf "\033[0;33m· Stacks:\033[0m\n"
	@docker stack ls
	@printf "\033[0;33m· Services:\033[0m\n"
	@docker service ls
	@printf "\033[0;33m· Secrets:\033[0m\n"
	@docker secret ls
	@printf "\033[0;33m· Volumes:\033[0m\n"
	@docker volume ls
	@printf "\033[0;33m· Networks:\033[0m\n"
	@docker network ls
