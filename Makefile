DOCKER_COMPOSE_FILE ?= docker-compose.yml

# Well documented Makefiles
DEFAULT_GOAL := help

help:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-40s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ [Run Firsttime]
# config: ## Install default config e
#	cp etc/config/config.yml.dist etc/config/config.yml

compile: ## Compile server
	sh utils/git.sh; \ 
	docker compose -f $(DOCKER_COMPOSE_FILE) up compile; \
	docker rm skyfire-compile

##@ [Docker]
up: ## Build and start all containers
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

start: ## Start all containers
	docker compose -f $(DOCKER_COMPOSE_FILE) start

stop: ## Stop all containers
	docker compose -f $(DOCKER_COMPOSE_FILE) stop

restart: ## Restart all containers
	docker compose -f $(DOCKER_COMPOSE_FILE) restart

down: ## Stop and remove containers
	docker compose -f $(DOCKER_COMPOSE_FILE) down

build: ## Just build all docker images
	docker compose -f $(DOCKER_COMPOSE_FILE) build

connect: ## Connect to container. usage: make connect <container>
	docker exec -it $(filter-out $@,$(MAKECMDGOALS)) /bin/sh

list: ## List all runnning containers
	docker ps -a --format="table {{.Names}}\t{{.Image}}\t{{.Status}}"

##@ [Logs]
log: ## show one contaienr log. usage: make log <container>
	docker logs $(filter-out $@,$(MAKECMDGOALS)) -f

all-logs: ## Show all containers logs
	docker compose logs -f