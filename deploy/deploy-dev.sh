#!/bin/bash
set -e

echo "Deploying to DEV"

DEV_DIR="$WORKSPACE/dev-app"
echo "Using DEV directory: $DEV_DIR"

mkdir -p "$DEV_DIR"

rsync -av --delete \
  --exclude dev-app \
  --exclude .git \
  ./ "$DEV_DIR/"

cd "$DEV_DIR"

npm install

export PORT=3001
echo "Starting app on port $PORT"

# Kill anything already using port 3001 (VERY IMPORTANT)
fuser -k 3001/tcp || true

# Start app
nohup node index.js > dev.log 2>&1 &

# Give app time to boot
sleep 10

echo "---- Application log ----"
cat dev.log || true
echo "--------------------------"

# Verify app
curl -f http://localhost:3001

echo "Deploy to DEV SUCCESSFUL"
