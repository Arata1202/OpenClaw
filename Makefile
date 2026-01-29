DR := npx dotenvx run --

# SSM

ssm:
	@aws ssm start-session --target ${EC2_INSTANCE_ID}

# Dotenvx

encrypt:
	@npx dotenvx encrypt

decrypt:
	@npx dotenvx decrypt

# Docker

DC := docker compose

build:
	${DR} ${DC} build

up-f:
	${DR} ${DC} up -d --force-recreate clawdbot-gateway

onboard:
	${DR} ${DC} run --rm clawdbot-cli onboard

# Terraform

tf-init:
	@cd terraform && terraform init

tf-plan:
	@cd terraform && terraform plan

tf-apply:
	@cd terraform && terraform apply

tf-destroy:
	@cd terraform && terraform destroy

.PHONY: ssm encrypt decrypt build up-f onboard tf-init tf-plan tf-apply tf-destroy
