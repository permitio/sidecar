.PHONY: help

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build -t authorizon/sidecar --build-arg READ_ONLY_GITHUB_TOKEN=$(READ_ONLY_GITHUB_TOKEN) .

run: ## Run the container locally
	@docker run -it \
		-e "OPAL_SERVER_URL=http://host.docker.internal:7002" \
		-e "HORIZON_BACKEND_SERVICE_URL=http://host.docker.internal:8000" \
		-e "HORIZON_CLIENT_TOKEN=$(DEV_MODE_CLIENT_TOKEN)" \
		-p 7000:7000 \
		-p 8181:8181 \
		authorizon/sidecar

run-prod: ## Run the container against prod
	@docker run -it \
		-p 7000:7000 \
		-p 8181:8181 \
		authorizon/sidecar
