#!/bin/bash
set -e  # stop on any error

# ------------------------------------------------------------------
# CONFIGURATION TODO FIRST
# ------------------------------------------------------------------
PROXMOX_HOST="root@192.168.1.55"
LXC_ID="LXC_ID"
REMOTE_DIR="/opt/CONTAINTER_NAME"

# ------------------------------------------------------------------
# Step 1: Build & transfer frontend image
# ------------------------------------------------------------------
echo "🛠  Building {PROJECT_NAME}-frontend image..."
cd {PROJECT_NAME}-frontend
docker build -t {PROJECT_NAME}-list-frontend:latest .
docker save {PROJECT_NAME}-list-frontend:latest -o {PROJECT_NAME}-frontend.tar
echo "📤 Uploading {PROJECT_NAME}-frontend.tar to Proxmox host..."
scp {PROJECT_NAME}-frontend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
cd ..

# ------------------------------------------------------------------
# Step 2: Build & transfer backend image
# ------------------------------------------------------------------
echo "🛠  Building {PROJECT_NAME}-backend image..."
cd {PROJECT_NAME}-backend
docker build -t {PROJECT_NAME}-list-backend:latest .
docker save {PROJECT_NAME}-list-backend:latest -o {PROJECT_NAME}-backend.tar
echo "📤 Uploading {PROJECT_NAME}-backend.tar to Proxmox host..."
scp {PROJECT_NAME}-backend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
cd ..

# ------------------------------------------------------------------
# Step 3: Copy Docker Compose files
# ------------------------------------------------------------------
echo "📄 Copying docker-compose files..."
scp docker-compose-prod.yml ${PROXMOX_HOST}:${REMOTE_DIR}/

# ------------------------------------------------------------------
# Step 4: Push files from Proxmox host to LXC container
# ------------------------------------------------------------------
echo "🚚 Pushing files into LXC ${LXC_ID}..."
ssh ${PROXMOX_HOST} <<EOF
  pct push ${LXC_ID} ${REMOTE_DIR}/{PROJECT_NAME}-backend.tar ${REMOTE_DIR}/{PROJECT_NAME}-backend.tar
  pct push ${LXC_ID} ${REMOTE_DIR}/{PROJECT_NAME}-frontend.tar ${REMOTE_DIR}/{PROJECT_NAME}-frontend.tar
  pct push ${LXC_ID} ${REMOTE_DIR}/docker-compose.yml ${REMOTE_DIR}/docker-compose.yml
  pct push ${LXC_ID} ${REMOTE_DIR}/docker-compose-prod.yml ${REMOTE_DIR}/docker-compose-prod.yml
EOF

# ------------------------------------------------------------------
# Step 5: Deploy inside LXC
# ------------------------------------------------------------------
echo "🚀 Deploying new images inside LXC ${LXC_ID}..."
ssh ${PROXMOX_HOST} "pct exec ${LXC_ID} -- bash -c '
  cd ${REMOTE_DIR}
  docker-compose -f docker-compose-prod.yml down
  docker load -i {PROJECT_NAME}-frontend.tar
  docker-compose -f docker-compose-prod.yml up -d {PROJECT_NAME}-frontend
  docker load -i {PROJECT_NAME}-backend.tar
  docker-compose -f docker-compose-prod.yml up -d {PROJECT_NAME}-backend
'"

echo "✅ Redeployment complete!"