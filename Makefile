DOCKER_RUN?=docker-compose run --rm

docs-terraform: $(TERRAFORM_MODULES)
	@scripts/update-terraform-docs.sh
.PHONY:docs-terraform

ga-act-pr:
	act pull_request --secret-file ./ci/env -P ubuntu-latest=flemay/musketeers
.PHONY:ga-act-pr

ga-act-push:
	act push --secret-file ./ci/env -P ubuntu-latest=flemay/musketeers
.PHONY:ga-act-pr