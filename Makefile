.MAKEFLAGS += --warn-undifined-variables --no-print-directory
.SHELLFALGS := -ue -o pipfail -c

all: help
.PHONY: all

# Use bash for inline if-statements
SHELL:=bash
APP_NAME=$(shell basename "`pwd`")
DOCKER_REPOSITORY=local
export SOURCE_IMAGE = $(DOCKER_REPOSITORY)/$(APP_NAME)

# Platform specific
export DOCKER_DEFAULT_PLATFORM := linux/amd64

# Branch specific
export BRANCH_NAME ?= $(shell git branch --show-current)
export IMAGE_TAG := $(shell echo $(BRANCH_NAME) | sed 's/\//-/')

##@ Helpers
help: ## display this help
	@echo "$(APP_NAME)"
	@echo "============================="
	@awk 'BEGIN {FS = ":.*##"; printf "\033[36m\033[0m"} /^[a-zA-Z0-9_%\/-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@printf "\n"

##@ Build image(s)
build: DARGS?=--load
build: ## build project images
	docker buildx bake -f docker-compose.yml $(DARGS) --set *.platform=$(DOCKER_DEFAULT_PLATFORM)

##@ Run image
run: DARGS=?=-e JUPYTER_ENABLE_LAB=yes
run: ## run image
	docker compose up


