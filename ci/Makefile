-include .env

AWS_ACCOUNT_ID ?= $(shell aws sts get-caller-identity --query "Account" --output text)
COMMIT_SHA ?= $(shell git rev-parse --short HEAD)
DOCKER_RUNNER?=docker-compose run --rm
DOCKER_REPOSITORY?=devops-wordpress
DOCKER_REGISTRY_URL ?= ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

ecr-login:
	@echo "\n === 🔐 Login to ECR docker registry: ${C_GREEN}${DOCKER_REGISTRY_URL}${C_RESET}\n"

	@$(DOCKER_RUNNER) aws ecr get-login-password \
		--region ${AWS_DEFAULT_REGION} \
		| docker login \
		--username AWS \
		--password-stdin ${DOCKER_REGISTRY_URL}

	@echo "\n === ✅ Done"
.PHONY:ecr_login

build-wp:
	@cd ../src/docker \
		&& $(MAKE) build \
		DOCKER_REPOSITORY=${DOCKER_REPOSITORY}
.PHONY:build-wp

push-wp:
	@cd ../src/docker \
		&& $(MAKE) push \
		DOCKER_REPOSITORY=${DOCKER_REPOSITORY} \
		AWS_REGION=${AWS_DEFAULT_REGION}
.PHONY:push-wp

build-push-wp: ecr-login build-wp push-wp
.PHONY:build-push-wp

deploy-wp:
	@echo "=== 🧯🧯🧯 SIMULATION ==="
	@echo "SHOULD DEPLOY USING SHA:"
	@$(DOCKER_RUNNER) aws ecr describe-images \
		--repository-name ${DOCKER_REPOSITORY} \
		--query 'reverse(sort_by(imageDetails,& imagePushedAt))[0].imageTags[-1]' \
		--output text
.PHONY:deploy

tf-ci-plan:
	@$(DOCKER_RUNNER) ci-terraform init
	@$(DOCKER_RUNNER) ci-terraform plan
.PHONY:tf-ci-plan

test-aws:
	$(DOCKER_RUNNER) aws sts get-caller-identity --output json
.PHONY:test-aws