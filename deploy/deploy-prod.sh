#!/bin/bash
set -e

echo "Deploying to Prod"

rm -rf /opt/prod-app
mkdir -p /opt/prod-app
cp -r . /opt/prod-app
cd /opt/prod-app

npm install

export PORT=3000
nohup node index.js > dev.log 2>&1 &

sleep 5
curl -f http://localhost:3000

echo "Deploying to Prod is Successfully"
