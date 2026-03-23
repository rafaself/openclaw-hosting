SHELL := /bin/bash

STACK_DIRS := stacks/gcp/prod stacks/aws/prod

.PHONY: fmt validate shellcheck-lite bash-syntax tree

fmt:
	@if command -v tofu >/dev/null 2>&1; then \
		tofu fmt -recursive; \
	elif command -v terraform >/dev/null 2>&1; then \
		terraform fmt -recursive; \
	else \
		echo "Neither tofu nor terraform is installed."; \
		exit 1; \
	fi

validate:
	@set -euo pipefail; \
	for dir in $(STACK_DIRS); do \
		echo "Validating $$dir"; \
		if command -v tofu >/dev/null 2>&1; then \
			(cd $$dir && tofu init -backend=false >/dev/null && tofu validate); \
		elif command -v terraform >/dev/null 2>&1; then \
			(cd $$dir && terraform init -backend=false >/dev/null && terraform validate); \
		else \
			echo "Neither tofu nor terraform is installed."; \
			exit 1; \
		fi; \
	done

bash-syntax:
	@set -euo pipefail; \
	while IFS= read -r -d '' file; do \
		echo "Checking $$file"; \
		bash -n "$$file"; \
	done < <(find bootstrap modules -type f -name '*.sh' -print0)

shellcheck-lite: bash-syntax

tree:
	@find . -maxdepth 4 -type f | sort
