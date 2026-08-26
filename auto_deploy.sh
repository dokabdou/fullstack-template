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
echo "🛠  Building frontend image..."
cd frontend
docker build -t boycott-list-frontend:latest .
docker save boycott-list-frontend:latest -o frontend.tar
echo "📤 Uploading frontend.tar to Proxmox host..."
scp frontend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
cd ..

# ------------------------------------------------------------------
# Step 2: Build & transfer backend image
# ------------------------------------------------------------------
echo "🛠  Building backend image..."
cd backend
docker build -t boycott-list-backend:latest .
docker save boycott-list-backend:latest -o backend.tar
echo "📤 Uploading backend.tar to Proxmox host..."
scp backend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
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
  pct push ${LXC_ID} ${REMOTE_DIR}/backend.tar ${REMOTE_DIR}/backend.tar
  pct push ${LXC_ID} ${REMOTE_DIR}/frontend.tar ${REMOTE_DIR}/frontend.tar
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
  docker load -i frontend.tar
  docker-compose -f docker-compose-prod.yml up -d frontend
  docker load -i backend.tar
  docker-compose -f docker-compose-prod.yml up -d backend
'"

echo "✅ Redeployment complete!"