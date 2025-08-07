# README

This project includes Docker Compose configuration for running in containers with PostgreSQL.

Tested and executed with podman-compose however both follow the same specification and should work with docker-compose

## Prerequisites

- Docker or Podman
- Docker Compose or Podman Compose

## How to run

### Using Makefile (Recommended):
```bash
# Start services with build
make build

# Or just start services
make up
```

### Using Docker Compose:
```bash
docker-compose up --build
```

### Using Podman Compose:
```bash
podman-compose up --build
```

## Included services

- **app**: Rails application running on port 3000
- **db**: PostgreSQL 16 running on port 5432

## Environment variables

The `docker-compose.yml` file is already configured with the following variables:

- `DATABASE_HOST=db`
- `DATABASE_PORT=5432`
- `DATABASE_USERNAME=postgres`
- `DATABASE_PASSWORD=postgres`
- `RAILS_ENV=development`

## Volumes

- `postgres_data`: Persists PostgreSQL data
- `bundle_cache`: Ruby gems cache
- `.:/rails`: Source code mount for development

## Useful commands

### Using Makefile (Recommended):
```bash
# View all available commands
make help

# Start services
make up

# Start services with build
make build

# Stop services
make down

# View logs
make logs        # Application logs
make logs-db     # Database logs

# Open shell in app container
make shell

# Reset database
make reset-db

# Run all tests
make test

# Run specific test file
make test-specific FILE=spec/models/circle_spec.rb

# Run tests interactively (when app is running)
make test-interactive

# Clean rebuild
make clean-rebuild
```

### Manual commands:

### Stop services:
```bash
# Using Podman Compose:
podman-compose down

# Using Docker Compose:
docker-compose down
```

### Execute commands in the application:
```bash
# Using Podman Compose:
podman-compose exec app bash

# Using Docker Compose:
docker-compose exec app bash
```

### View logs:
```bash
# Using Podman Compose:
podman-compose logs app
podman-compose logs db

# Using Docker Compose:
docker-compose logs app
docker-compose logs db
```

### Reset database:
```bash
# Using Podman Compose:
podman-compose exec app rails db:drop db:create db:migrate db:seed

# Using Docker Compose:
docker-compose exec app rails db:drop db:create db:migrate db:seed
```

### Run tests:

```sh
# Using Podman Compose:
podman-compose -f docker-compose.test.yml up --abort-on-container-exit
podman-compose -f docker-compose.test.yml down

# Using Docker Compose:
docker-compose -f docker-compose.test.yml up --abort-on-container-exit
docker-compose -f docker-compose.test.yml down
```

### Run specific test file:
```sh
# Using Podman Compose:
podman-compose -f docker-compose.test.yml up -d db
podman-compose -f docker-compose.test.yml run --rm test bash -c "bundle exec rspec spec/models/circle_spec.rb"
podman-compose -f docker-compose.test.yml down

# Using Docker Compose:
docker-compose -f docker-compose.test.yml up -d db
docker-compose -f docker-compose.test.yml run --rm test bash -c "bundle exec rspec spec/models/circle_spec.rb"
docker-compose -f docker-compose.test.yml down
```

### Run tests interactively (when app is running):
```bash
# Using Podman Compose:
podman-compose exec app bundle exec rspec

# Using Docker Compose:
docker-compose exec app bundle exec rspec
```

## Access
- Swagger docs: http://localhost:3000/api-docs/index.html
- Application: http://localhost:3000
- PostgreSQL: localhost:5432

## Troubleshooting

If there are permission issues, make sure the user has permission to write to the mounted directories.

To completely rebuild the containers:
```bash
# Using Podman Compose:
podman-compose down
podman-compose build --no-cache
podman-compose up

# Using Docker Compose:
docker-compose down
docker-compose build --no-cache
docker-compose up
```
