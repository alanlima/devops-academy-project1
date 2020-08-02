DOCKER_RUN?=docker-compose run --rm

docs-terraform: $(TERRAFORM_MODULES)
	@scripts/update-terraform-docs.sh
.PHONY:docs-terraform

