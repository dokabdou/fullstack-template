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
COMPOSE_FILE="docker-compose-dev.yml"  # <-- choose compose file here : docker-compose-prod.yml | docker-compose-pre-prod.yml

# ------------------------------------------------------------------
# Parse command line argument
# run both => sh params_auto_deploy_script.sh
# run frontend solo => sh params_auto_deploy_script.sh frontend
# run backend solo => sh params_auto_deploy_script.sh backend
# ------------------------------------------------------------------
DEPLOY_TARGET="${1:-both}"   # allowed: frontend, backend, both

if [[ "$DEPLOY_TARGET" != "frontend" && "$DEPLOY_TARGET" != "backend" && "$DEPLOY_TARGET" != "both" ]]; then
    echo "Usage: $0 [frontend|backend|both]"
    exit 1
fi

echo "Deployment target: $DEPLOY_TARGET"

# ------------------------------------------------------------------
# Step 0: Ensure remote directory exists on Proxmox host
# ------------------------------------------------------------------
echo "Step 0/4 :: 📁 Ensuring remote directory ${REMOTE_DIR} exists on Proxmox host..."
ssh ${PROXMOX_HOST} "mkdir -p ${REMOTE_DIR}"

# ------------------------------------------------------------------
# Step 1: Build & transfer frontend image (if needed)
# ------------------------------------------------------------------
if [[ "$DEPLOY_TARGET" == "frontend" || "$DEPLOY_TARGET" == "both" ]]; then
    echo "Step 1/4 :: 🛠  Building frontend image..."
    cd frontend
    #docker build --no-cache -f Dockerfile.dev -t ${PROJECT_NAME}-frontend:latest . #(dev)
    docker build --no-cache -t ${PROJECT_NAME}-frontend:latest .   # uses default Dockerfile (prod)
    docker save ${PROJECT_NAME}-frontend:latest -o frontend.tar
    scp frontend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
    cd ..
else
    echo "Step 1/4 :: ⏭️  Skipping frontend build."
fi

# ------------------------------------------------------------------
# Step 2: Build & transfer backend image (if needed)
# ------------------------------------------------------------------
if [[ "$DEPLOY_TARGET" == "backend" || "$DEPLOY_TARGET" == "both" ]]; then
    echo "Step 2/4 :: 🛠  Building backend image..."
    cd ugop-formation-backend
    #docker build -f Dockerfile.dev -t ${PROJECT_NAME}-backend:latest . # (dev)
    docker build -t ${PROJECT_NAME}-backend:latest .    # uses default Dockerfile (prod)
    docker save ${PROJECT_NAME}-backend:latest -o backend.tar
    scp backend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
    cd ..
else
    echo "Step 2/4 :: ⏭️  Skipping backend build."
fi

# ------------------------------------------------------------------
# Step 3: Copy compose file and .env (always)
# ------------------------------------------------------------------
echo "Step 3/4 :: 📄 Copying ${COMPOSE_FILE} and .env..."
scp ${COMPOSE_FILE} .env ${PROXMOX_HOST}:${REMOTE_DIR}/

# ------------------------------------------------------------------
# Step 4: Push files to LXC and deploy
# ------------------------------------------------------------------
echo "Step 4/4 :: 🚚 Pushing files into LXC ${LXC_ID}..."

# Build remote command dynamically
REMOTE_CMD=""
if [[ "$DEPLOY_TARGET" == "both" ]]; then
    REMOTE_CMD="
        pct push ${LXC_ID} ${REMOTE_DIR}/frontend.tar ${REMOTE_DIR}/frontend.tar
        pct push ${LXC_ID} ${REMOTE_DIR}/backend.tar ${REMOTE_DIR}/backend.tar
        pct push ${LXC_ID} ${REMOTE_DIR}/${COMPOSE_FILE} ${REMOTE_DIR}/${COMPOSE_FILE}
        pct push ${LXC_ID} ${REMOTE_DIR}/.env ${REMOTE_DIR}/.env

        pct exec ${LXC_ID} -- bash -c '
            set -e
            cd ${REMOTE_DIR}
            docker network inspect proxy-network >/dev/null 2>&1 || docker network create proxy-network
            docker compose -f ${COMPOSE_FILE} down || true
            docker load -i frontend.tar
            docker load -i backend.tar
            docker compose -f ${COMPOSE_FILE} up -d
        '
    "
elif [[ "$DEPLOY_TARGET" == "frontend" ]]; then
    REMOTE_CMD="
        pct push ${LXC_ID} ${REMOTE_DIR}/frontend.tar ${REMOTE_DIR}/frontend.tar
        pct push ${LXC_ID} ${REMOTE_DIR}/${COMPOSE_FILE} ${REMOTE_DIR}/${COMPOSE_FILE}
        pct push ${LXC_ID} ${REMOTE_DIR}/.env ${REMOTE_DIR}/.env

        pct exec ${LXC_ID} -- bash -c '
            set -e
            cd ${REMOTE_DIR}
            docker network inspect proxy-network >/dev/null 2>&1 || docker network create proxy-network
            docker compose -f ${COMPOSE_FILE} down frontend || true
            docker load -i frontend.tar
            docker compose -f ${COMPOSE_FILE} up -d --no-deps frontend
        '
    "
elif [[ "$DEPLOY_TARGET" == "backend" ]]; then
    REMOTE_CMD="
        pct push ${LXC_ID} ${REMOTE_DIR}/backend.tar ${REMOTE_DIR}/backend.tar
        pct push ${LXC_ID} ${REMOTE_DIR}/${COMPOSE_FILE} ${REMOTE_DIR}/${COMPOSE_FILE}
        pct push ${LXC_ID} ${REMOTE_DIR}/.env ${REMOTE_DIR}/.env

        pct exec ${LXC_ID} -- bash -c '
            set -e
            cd ${REMOTE_DIR}
            docker network inspect proxy-network >/dev/null 2>&1 || docker network create proxy-network
            docker compose -f ${COMPOSE_FILE} down backend || true
            docker load -i backend.tar
            docker compose -f ${COMPOSE_FILE} up -d --no-deps backend
        '
    "
fi

# Execute remote commands
ssh ${PROXMOX_HOST} <<EOF
  set -e
  pct exec ${LXC_ID} -- mkdir -p ${REMOTE_DIR}
  ${REMOTE_CMD}
EOF

echo "✅ Redeployment of $DEPLOY_TARGET complete!"
