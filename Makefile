DR := npx dotenvx run -f .env -fk ../.env.keys --

# Dotenvx

encrypt:
	@npx dotenvx encrypt -f clawdbot/.env -fk .env.keys

decrypt:
	@npx dotenvx decrypt -f clawdbot/.env -fk .env.keys

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

.PHONY: encrypt decrypt cb-setup cb-start tf-init tf-plan tf-apply tf-destroy
