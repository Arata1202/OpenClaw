<div align="right">

![GitHub License](https://img.shields.io/github/license/Arata1202/ClawdBot)

</div>

## Getting Started

### Prepare Repository

```bash
# Local and VM

# Clone repository
git clone git@github.com:Arata1202/ClawdBot.git
cd ClawdBot

# Initialize submodules
git submodule update --init --recursive

# Install dependencies
npm install
```

### Create Resources with Terraform

```bash
# Local

# Move to repository
cd ClawdBot/terraform

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
cd ClawdBot

# Prepare and edit .envrc file
cp .envrc.example .envrc
vi .envrc

# Allow direnv to load variables
direnv allow .

# Connect to AWS EC2 via SSM
make ssm

# Switch to ubuntu user and move to repository
sudo -iu ubuntu
cd ~/ClawdBot
```

```env
# Required
export EC2_INSTANCE_ID=<EC2_INSTANCE_ID>
```

### Set Up ClawdBot Server

```bash
# VM

# Set up Ubuntu
./ubuntu/setup.sh

# Move to repository
cd ClawdBot

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
mkdir -p ~/.clawdbot ~/clawd
sudo chown -R 1000:1000 ~/.clawdbot ~/clawd

# Add swap
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Build and onboard
make build
make onboard

# Change user permissions
sudo chown -R 1000:1000 ~/.clawdbot ~/clawd

# Start server
make up-f
```

```env
# Required
CLAWDBOT_GATEWAY_TOKEN=<UNIQUE_RANDOM_64_HEX>
GOG_KEYRING_PASSWORD=<UNIQUE_RANDOM_64_HEX>
```
