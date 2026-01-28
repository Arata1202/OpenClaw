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

up:
	${DR} ${DC} up -d --force-recreate clawdbot-gateway

onboard:
	${DR} ${DC} run --rm clawdbot-cli onboard

# ClawdBot

cb-setup:
	${DR} ./scripts/setup.sh

cb-start:
	${DR} ./scripts/start.sh

# Terraform

tf-init:
	@cd terraform && terraform init

tf-plan:
	@cd terraform && terraform plan

tf-apply:
	@cd terraform && terraform apply

tf-destroy:
	@cd terraform && terraform destroy

.PHONY: ssm encrypt decrypt build up onboard cb-setup cb-start tf-init tf-plan tf-apply tf-destroy
