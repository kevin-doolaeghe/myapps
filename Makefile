# Docker environment deployment Makefile

# Makefile variables
STACKS := duckdns traefik portainer wireguard homepage

.PHONY: all init start stop clean status

all: start

# Initialize Docker environment
init:
	@echo "Initializing Docker environment..."
	@bash init.sh
	@echo "\nInitialization complete.\n"

# Start Docker stacks
start: init
	@echo "Starting Docker stacks..."
	@for stack in $(STACKS); do \
		bash up.sh $$stack; \
	done
	@echo "\nStarting complete.\n"

# Stop Docker stacks
stop:
	@echo "Stopping Docker stacks..."
	@for stack in $(STACKS); do \
		bash down.sh $$stack; \
	done
	@echo "\nStopping complete.\n"

# Clean Docker environment
clean: stop
	@echo "Cleaning Docker environment..."
	@echo "\nRemoving unused networks..."
	@docker network prune -f
	@echo "\nRemoving unused images..."
	@docker image prune -f
	@echo "\nCleaning complete.\n"

# Print Docker environment status
status:
	@echo "Docker status:"
	@echo "\n- stacks:"
	@docker stack ls
	@echo "\n- services:"
	@docker service ls
	@echo "\n- networks:"
	@docker network ls
	@echo "\n- volumes:"
	@docker volume ls
	@echo "\n"
