#!/bin/bash
set -e  # stop on any error

# ------------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------------
PROJECT_NAME="-------"                     # <-- change this per project
PROXMOX_HOST="root@192.168.1.55"
LXC_ID="113" # <-- change this per project
REMOTE_DIR="/opt/${PROJECT_NAME}"

# ------------------------------------------------------------------
# Step 0: Ensure remote directory exists on Proxmox host
# ------------------------------------------------------------------
echo "📁 Ensuring remote directory ${REMOTE_DIR} exists on Proxmox host..."
ssh ${PROXMOX_HOST} "mkdir -p ${REMOTE_DIR}"

# ------------------------------------------------------------------
# Step 1: Build & transfer frontend image
# ------------------------------------------------------------------
echo "🛠  Building frontend image..."
cd frontend
docker build -t ${PROJECT_NAME}-frontend:latest .
docker save ${PROJECT_NAME}-frontend:latest -o frontend.tar
echo "📤 Uploading frontend.tar to Proxmox host..."
scp frontend.tar ${PROXMOX_HOST}:${REMOTE_DIR}/
cd ..

# ------------------------------------------------------------------
# Step 2: Build & transfer backend image
# ------------------------------------------------------------------
echo "🛠  Building backend image..."
cd backend
docker build -t ${PROJECT_NAME}-backend:latest .
docker save ${PROJECT_NAME}-backend:latest -o backend.tar
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
  # Ensure the destination directory exists inside the LXC
  pct exec ${LXC_ID} -- mkdir -p ${REMOTE_DIR}

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
