# Workspace stack. The bin/coder hooks drive these targets.
COMPOSE ?= docker compose
WAIT_TIMEOUT ?= 180
SERVICES := db web

.PHONY: up down wait status seed load logs clean

up: ## start the stack in the background
	$(COMPOSE) up -d

down: ## stop the stack, keeping data volumes
	$(COMPOSE) stop

wait: ## block until every service reports healthy
	@end=$$(( $$(date +%s) + $(WAIT_TIMEOUT) )); \
	for s in $(SERVICES); do \
	  until [ "$$(docker inspect -f '{{.State.Health.Status}}' $$($(COMPOSE) ps -q $$s) 2>/dev/null)" = healthy ]; do \
	    if [ $$(date +%s) -ge $$end ]; then echo "timed out waiting for $$s"; $(COMPOSE) ps; exit 1; fi; \
	    sleep 2; \
	  done; \
	  echo "$$s healthy"; \
	done

status: ## show service state
	$(COMPOSE) ps

seed: ## small fixture data set
	$(COMPOSE) exec -T db psql -v ON_ERROR_STOP=1 -U demo -d demo < db/seed.sql

load: seed ## seed, then a larger generated data load
	$(COMPOSE) exec -T db psql -v ON_ERROR_STOP=1 -U demo -d demo < db/load.sql

logs:
	$(COMPOSE) logs --tail=100

clean: ## remove containers and volumes
	$(COMPOSE) down -v
