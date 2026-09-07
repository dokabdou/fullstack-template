#!/bin/bash
set -e

# Copying the ssh key to Proxmox in order to more easily automate this script
# cat ~/.ssh/id_ed25519.pub | ssh root@192.168.1.55 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh"

# ------------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------------
PROJECT_NAME="-------------"          # <-- change per project
PROXMOX_HOST="root@192.168.1.55"
LXC_ID="----"                           # <-- change per project
REMOTE_DIR="/opt/${PROJECT_NAME}"
COMPOSE_FILE="docker-compose-dev.yml"  # <-- choose compose file here : docker-compose-prod.yml

# ------------------------------------------------------------------
# Step 0: Ensure remote directory exists on Proxmox host
# ------------------------------------------------------------------
echo "Step 0/5 :: 📁 Ensuring remote directory ${REMOTE_DIR} exists on Proxmox host..."
ssh ${PROXMOX_HOST} "mkdir -p ${REMOTE_DIR}"

# ------------------------------------------------------------------
# Step 1: Build & transfer frontend image
# ------------------------------------------------------------------
echo "Step 1/5 :: 🛠  Building frontend image..."
cd frontend
#docker build -f Dockerfile.dev -t ${PROJECT_NAME}-frontend:latest . #(dev)
docker build -t ${PROJECT_NAME}-frontend:latest .   # uses default Dockerfile (prod)
docker save ${PROJECT_NAME}-frontend:latest -o frontend.tar
scp frontend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
cd ..

# ------------------------------------------------------------------
# Step 2: Build & transfer backend image
# ------------------------------------------------------------------
echo "Step 2/5 :: 🛠  Building backend image..."
cd backend
#docker build -f Dockerfile.dev -t ${PROJECT_NAME}-backend:latest . # (dev)
docker build -t ${PROJECT_NAME}-backend:latest .    # uses default Dockerfile (prod)
docker save ${PROJECT_NAME}-backend:latest -o backend.tar
scp backend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
cd ..

# ------------------------------------------------------------------
# Step 3: Copy compose file and .env
# ------------------------------------------------------------------
echo "Step 3/4 :: 📄 Copying ${COMPOSE_FILE} and .env..."
scp ${COMPOSE_FILE} .env ${PROXMOX_HOST}:${REMOTE_DIR}/


# ------------------------------------------------------------------
# Step 4. Push files to LXC and deploy
# ------------------------------------------------------------------
echo "Step 5/5 :: 🚚 Pushing files into LXC ${LXC_ID}..."
ssh ${PROXMOX_HOST} <<EOF
  set -e
  pct exec ${LXC_ID} -- mkdir -p ${REMOTE_DIR}
  pct push ${LXC_ID} ${REMOTE_DIR}/frontend.tar ${REMOTE_DIR}/frontend.tar
  pct push ${LXC_ID} ${REMOTE_DIR}/backend.tar ${REMOTE_DIR}/backend.tar
  pct push ${LXC_ID} ${REMOTE_DIR}/${COMPOSE_FILE} ${REMOTE_DIR}/${COMPOSE_FILE}
  pct push ${LXC_ID} ${REMOTE_DIR}/.env ${REMOTE_DIR}/.env

  pct exec ${LXC_ID} -- bash -c '
    set -e
    cd ${REMOTE_DIR}

    # Ensure external network exists (create if missing)
    docker network inspect proxy-network >/dev/null 2>&1 || docker network create proxy-network

    docker compose -f ${COMPOSE_FILE} down || true
    docker load -i frontend.tar
    docker load -i backend.tar
    docker compose -f ${COMPOSE_FILE} up -d
  '
EOF

echo "✅ Redeployment complete!"
