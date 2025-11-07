#!/bin/bash

# Custom deployment script for Azure App Service
# This ensures the app uses the compiled dist folder

echo "=== Azure Custom Deployment Script ==="
echo "Working directory: $(pwd)"
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"

# Set deployment variables
DEPLOYMENT_SOURCE="${DEPLOYMENT_SOURCE:-$PWD}"
DEPLOYMENT_TARGET="${DEPLOYMENT_TARGET:-$DEPLOYMENT_SOURCE}"

echo "Deployment source: $DEPLOYMENT_SOURCE"
echo "Deployment target: $DEPLOYMENT_TARGET"

# Ensure we're in the correct directory
cd "$DEPLOYMENT_SOURCE"

# Check if dist folder exists
if [ ! -d "dist" ]; then
  echo "ERROR: dist folder not found!"
  echo "The application must be built before deploying to Azure."
  echo "Make sure the dist folder is committed to the repository."
  exit 1
fi

# Check if dist/main.js exists
if [ ! -f "dist/main.js" ]; then
  echo "ERROR: dist/main.js not found!"
  exit 1
fi

echo "✓ dist folder found with compiled code"
echo "✓ dist/main.js exists"

# Copy files to deployment target if different
if [ "$DEPLOYMENT_SOURCE" != "$DEPLOYMENT_TARGET" ]; then
  echo "Copying files to deployment target..."
  rsync -av --exclude=node_modules --exclude=.git "$DEPLOYMENT_SOURCE/" "$DEPLOYMENT_TARGET/"
fi

# Install production dependencies only
echo "Installing production dependencies..."
cd "$DEPLOYMENT_TARGET"
npm ci --only=production --no-audit --no-fund

echo "=== Deployment completed successfully ==="
