<div align="right">

![GitHub License](https://img.shields.io/github/license/Arata1202/OpenClaw)

</div>

## Getting Started

### Prepare Repository

```bash
# Local and VM

# Clone repository
git clone git@github.com:Arata1202/OpenClaw.git
cd OpenClaw

# Initialize submodules
git submodule update --init --recursive

# Install dependencies
npm install
```

### Create Resources with Terraform

```bash
# Local

# Move to repository
cd OpenClaw/terraform

# Prepare and edit variables file
cp variables.tf.example variables.tf
vi variables.tf

# Create resources
terraform init
terraform plan
terraform apply
```

### Connect AWS EC2 with SSM

```bash
# Local

# Move to repository
cd OpenClaw

# Prepare and edit .envrc file
cp .envrc.example .envrc
vi .envrc

# Allow direnv to load variables
direnv allow .

# Connect to AWS EC2 via SSM
make ssm

# Switch to ubuntu user
sudo -iu ubuntu
```

```env
# Required
export EC2_INSTANCE_ID=<EC2_INSTANCE_ID>
```

### Set Up OpenClaw Server

```bash
# VM

# Set up Ubuntu
./ubuntu/setup.sh

# Move to repository
cd OpenClaw

# Remove existing .env file
rm -f .env

# Generate random strings for .env values
openssl rand -hex 32

# Prepare and edit .env file
cp .env.example .env
vi .env

# Encrypt .env file
make encrypt

# Create permanent directories
mkdir -p ~/.openclaw ~/openclaw
sudo chown -R 1000:1000 ~/.openclaw ~/openclaw

# Add swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Build and onboard
make build
make onboard

# Change user permissions
sudo chown -R 1000:1000 ~/.openclaw ~/openclaw

# Start server
make up-f
```

```env
# Required
OPENCLAW_GATEWAY_TOKEN=<UNIQUE_RANDOM_64_HEX>
GOG_KEYRING_PASSWORD=<UNIQUE_RANDOM_64_HEX>
```

### Set Up GitHub CLI

```bash
# Create persistent directories for GitHub CLI config
mkdir -p ~/.openclaw/gh
sudo chown -R 1000:1000 ~/.openclaw/gh

# Switch build to gh/Dockerfile (adds GitHub CLI)
sed -i 's|build: ./openclaw|build:\n      context: .\n      dockerfile: skills/gh/Dockerfile|g' docker-compose.yaml

# Build
make build

# Start server
make up-f

# Authenticate GitHub CLI in the container
echo "<GITHUB_PERSONAL_ACCESS_TOKEN>" | npx dotenvx run -- docker compose exec -T openclaw-gateway gh auth login --with-token

# Verify authentication status
npx dotenvx run -- docker compose exec openclaw-gateway gh auth status
```

### Set Up Obsidian CLI

```bash
# Create persistent directories for Obsidian CLI config
mkdir -p ~/.openclaw/obsidian-cli
sudo chown -R 1000:1000 ~/.openclaw/obsidian-cli

# Switch build to obsidian-cli/Dockerfile (adds obsidian-cli)
sed -i 's|build: ./openclaw|build:\n      context: .\n      dockerfile: skills/obsidian-cli/Dockerfile|g' docker-compose.yaml

# Build
make build

# Start server
make up-f

# Verify obsidian-cli in the container
npx dotenvx run -- docker compose exec openclaw-gateway obsidian-cli --help
```

### Update OpenClaw Settings

```bash
# Launch the configuration tool
make oc-config
```
