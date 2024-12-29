# Docker environment deployment Makefile

# Makefile variables
STACKS := duckdns traefik portainer wireguard homepage

.PHONY: all init start stop clean status

all: start

# Initialize Docker environment
init:
	@echo "Initializing Docker environment...\n"
	@bash init.sh
	@echo "\n► Initialization complete.\n"

# Start Docker stacks
start: init
	@echo "Starting Docker stacks...\n"
	@for stack in $(STACKS); do \
		bash up.sh $$stack; \
	done
	@echo "\n► Starting complete.\n"

# Stop Docker stacks
stop:
	@echo "Stopping Docker stacks...\n"
	@for stack in $(STACKS); do \
		bash down.sh $$stack; \
	done
	@echo "\n► Stopping complete.\n"

# Clean Docker environment
clean: stop
	@echo "Cleaning Docker environment..."
	@echo "\nRemoving unused networks..."
	@docker network prune -f
	@echo "\nRemoving unused images..."
	@docker image prune -f
	@echo "\n► Cleaning complete.\n"

# Print Docker environment status
status:
	@echo "Printing Docker environment status:"
	@echo "\n· Stacks:"
	@docker stack ls
	@echo "\n· Services:"
	@docker service ls
	@echo "\n· Secrets:"
	@docker secret ls
	@echo "\n· Volumes:"
	@docker volume ls
	@echo "\n· Networks:"
	@docker network ls
