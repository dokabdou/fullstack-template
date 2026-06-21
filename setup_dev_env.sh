#!/bin/bash

# >/dev/null 2>&1 hides installation outputs
# can add the needed dependencies to list 

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

log() {
  echo -e "${GREEN}[INFO]${RESET} $1"
}

warn() {
  echo -e "${YELLOW}[WARN]${RESET} $1"
}

fail() {
  echo -e "${RED}[ERROR]${RESET} $1"
  exit 1
}

error_handler() {
  fail "Command failed: '$BASH_COMMAND' (line $1)"
}

trap 'error_handler $LINENO' ERR

set -e  # stop script if a command fails

log "Updating system packages..."
apt update -y >/dev/null 2>&1
apt upgrade -y >/dev/null 2>&1

log "Installing Git..."
apt install -y git >/dev/null 2>&1

log "Installing Python 3 and pip..."
apt install -y python3 python3-pip python3-venv >/dev/null 2>&1

log "Installing C/C++ compiler and build tools (gcc, make)..."
apt install -y build-essential >/dev/null 2>&1

log "Installing Java (OpenJDK 25) and Maven..."
apt install -y openjdk-25-jdk maven >/dev/null 2>&1

log "Installing curl and ca-certificates..."
apt install -y curl ca-certificates >/dev/null 2>&1

log "Installing Node.js (LTS) and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - >/dev/null 2>&1
apt install -y nodejs >/dev/null 2>&1

log "Installing Angular CLI..."
npm install -g @angular/cli >/dev/null 2>&1

log "Installing tmux..."
apt install -y tmux >/dev/null 2>&1

# --- DOCKER INSTALLATION ---
log "Adding Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg >/dev/null 2>&1
chmod a+r /etc/apt/keyrings/docker.gpg

log "Adding Docker repository..."
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list >/dev/null

log "Installing Docker Engine & Docker Compose..."
apt update -y >/dev/null 2>&1
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1

log "Starting and enabling Docker..."
systemctl start docker >/dev/null 2>&1
systemctl enable docker >/dev/null 2>&1
# ---------------------------

log "Installing prerequisites for MongoDB..."
apt install -y gnupg >/dev/null 2>&1

log "Adding MongoDB repository..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg >/dev/null 2>&1

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" \
| tee /etc/apt/sources.list.d/mongodb-org-7.0.list >/dev/null

log "Installing MongoDB..."
apt update -y >/dev/null 2>&1
apt install -y mongodb-org >/dev/null 2>&1

log "Starting MongoDB..."
systemctl start mongod >/dev/null 2>&1
systemctl enable mongod >/dev/null 2>&1

echo ""
log "MongoDB status: active (running) means its all good"
systemctl status mongod --no-pager
# --no-pager prevents systemctl status from opening the pager (q exit screen)

echo ""
log "Installed versions:"
java -version
echo ""
mvn -version
echo ""
python3 --version
pip3 --version
echo ""
gcc --version | head -n 1
echo ""
node -v
npm -v
echo ""
ng version
echo ""
docker -v
docker compose version

echo ""
log "Setup completed."

echo ""
warn "To run this script:"
echo -e "${YELLOW}chmod +x setup_dev_env.sh${RESET}"
echo -e "${YELLOW}sudo ./setup_dev_env.sh${RESET}"