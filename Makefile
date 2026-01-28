DR := npx dotenvx run --

# SSM

ssm:
	@aws ssm start-session --target ${EC2_INSTANCE_ID}

# Git

pull:
	@git pull
	@git submodule update --remote --recursive

# Dotenvx

encrypt:
	@npx dotenvx encrypt

decrypt:
	@npx dotenvx decrypt

# ClawdBot

cb-setup:
	${DR} ./scripts/setup.sh

cb-start:
	${DR} ./scripts/start.sh

cb-update:
	${DR} docker compose build
	${DR} docker compose up -d --force-recreate clawdbot-gateway

# Terraform

tf-init:
	@cd terraform && terraform init

tf-plan:
	@cd terraform && terraform plan

tf-apply:
	@cd terraform && terraform apply

tf-destroy:
	@cd terraform && terraform destroy

.PHONY: ssm pull encrypt decrypt cb-setup cb-start cb-update tf-init tf-plan tf-apply tf-destroy
