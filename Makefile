# Docker environment deployment Makefile

# Makefile variables
STACKS := duckdns traefik portainer wireguard homepage

.PHONY: all init start stop clean

all: start

# Initialize Docker environment
init:
	@echo "Initializing Docker environment..."
	@bash init.sh

# Start Docker stacks
start: init
	@echo "Starting Docker stacks..."
	@for stack in $(STACKS); do \
		sh up.sh $$stack \
	done

# Stop Docker stacks
stop:
	@echo "Stopping Docker stacks..."
	@for stack in $(STACKS); do \
		sh down.sh $$stack \
	done

# Clean Docker environment
clean: stop
	@echo "Cleaning Docker environment..."
	@echo "Removing unused networks..."
	docker network prune -f
	@echo "Removing unused images..."
	docker image prune -a -f
	@echo "Cleaning complete."
