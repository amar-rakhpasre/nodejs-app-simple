#!/bin/bash
set -e

echo "Deploying to Prod"

PROD_DIR="$WORKSPACE/prod-app"

echo "Using DEV directory: $PROD_DIR"

rm -rf "$PROD_DIR"
mkdir -p "$PROD_DIR"
cp -r . "$PROD_DIR"
cd "$PROD_DIR"

npm install

export PORT=3000
nohup node index.js > dev.log 2>&1 &

sleep 5
curl -f http://localhost:3000

echo "Deploying to Prod is Successfully"
