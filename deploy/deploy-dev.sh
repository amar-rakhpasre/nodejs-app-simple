#!/bin/bash
set -e

echo "Deploying to DEV"

rm -rf /opt/dev-app
mkdir -p /opt/dev-app
cp -r . /opt/dev-app
cd /opt/dev-app

npm install

export PORT=3001
nohup node app.js > dev.log 2>&1 &

sleep 5
curl -f http://localhost:3001

echo "Deploying to Dev is Successfully"
