#!/bin/bash
set -e

echo "Deploying to PROD"

PROD_DIR="$WORKSPACE/prod-app"
echo "Using PROD directory: $PROD_DIR"

mkdir -p "$PROD_DIR"

rsync -av --delete \
  --exclude prod-app \
  --exclude .git \
  ./ "$PROD_DIR/"

cd "$PROD_DIR"

npm install

export PORT=3000
nohup node index.js > prod.log 2>&1 &

# Kill anything already using port 3001 (VERY IMPORTANT)
fuser -k 3000/tcp || true

# Start app
nohup node index.js > prod.log 2>&1 &

# Give app time to boot
sleep 10

echo "---- Application log ----"
cat prod.log || true
echo "--------------------------"

# Verify app
curl -f http://44.211.24.224:3000

echo "Deploy to PROD SUCCESSFUL"




# #!/bin/bash
# set -e

# echo "Deploying to Prod"

# PROD_DIR="$WORKSPACE/prod-app"

# echo "Using DEV directory: $PROD_DIR"

# rm -rf "$PROD_DIR"
# mkdir -p "$PROD_DIR"
# cp -r . "$PROD_DIR"
# cd "$PROD_DIR"

# npm install

# export PORT=3000
# nohup node index.js > prod.log 2>&1 &

# sleep 5
# curl -f http://localhost:3000

# echo "Deploying to Prod is Successfully"
