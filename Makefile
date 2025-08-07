# Makefile for API Frame Circles project
# Using podman-compose commands

.PHONY: help up down build logs reset-db test test-specific shell

# Default target
help:
	@echo "Available commands:"
	@echo "  make up           - Start all services"
	@echo "  make down         - Stop all services"
	@echo "  make build        - Build and start services"
	@echo "  make logs         - View application logs"
	@echo "  make logs-db      - View database logs"
	@echo "  make shell        - Open bash shell in app container"
	@echo "  make reset-db     - Reset database (drop, create, migrate, seed)"
	@echo "  make test         - Run all tests"
	@echo ""

# Start services
up:
	podman-compose up

# Start services with build
build:
	podman-compose up --build

# Stop services
down:
	podman-compose down

# View application logs
logs:
	podman-compose logs app

# View database logs
logs-db:
	podman-compose logs db

# Open shell in app container (must be running)
shell:
	podman-compose exec app bash

# Reset database
reset-db:
	podman-compose exec app rails db:drop db:create db:migrate db:seed

# Run all tests
test:
	podman-compose -f docker-compose.test.yml up --abort-on-container-exit
	podman-compose -f docker-compose.test.yml down

# Clean up everything and rebuild
clean-rebuild:
	podman-compose down
	podman-compose build --no-cache
	podman-compose up
