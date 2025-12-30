#!/bin/bash
set -e

echo "Deploying to DEV"

DEV_DIR="$WORKSPACE/dev-app"

echo "Using DEV directory: $DEV_DIR"

rm -rf "$DEV_DIR"
mkdir -p "$DEV_DIR"
# cp -r ../ "$DEV_DIR"
# Copy project files EXCEPT $DEV_DIR
rsync -av --delete \
  --exclude dev-app \
  --exclude .git \
  ./ "$DEV_DIR/"

cd "$DEV_DIR"

npm install

export PORT=3001
nohup node app.js > dev.log 2>&1 &

sleep 5
curl -f http://localhost:3001

echo "Deploying to Dev is Successfully"
