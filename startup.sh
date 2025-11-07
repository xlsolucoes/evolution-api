#!/bin/bash

# Startup script for Azure Web App
echo "=== Azure Web App startup script ==="

# Set environment
export NODE_ENV=production
export DATABASE_PROVIDER=postgresql

# Check if we have the dist folder (built application)
if [ ! -d "dist" ]; then
  echo "ERROR: dist folder not found. Build may have failed."
  exit 1
fi

# Check if main.js exists
if [ ! -f "dist/main.js" ]; then
  echo "ERROR: dist/main.js not found. Build may have failed."
  exit 1
fi

# Generate Prisma client if needed
echo "Checking Prisma client..."
if [ ! -d "node_modules/@prisma/client" ] || [ ! -f "node_modules/@prisma/client/index.js" ]; then
  echo "Generating Prisma client..."
  npm run db:generate
fi

# Run database migrations
echo "Running database migrations..."
npm run db:deploy

# Start the application
echo "Starting Evolution API..."
echo "Current directory: $(pwd)"
echo "Files in dist: $(ls -la dist/ | head -5)"
node dist/main.js