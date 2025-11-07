#!/bin/bash

# Startup script for Azure Web App
echo "Azure Web App startup script"

# Set environment
export NODE_ENV=production
export DATABASE_PROVIDER=postgresql

# Generate Prisma client if needed
if [ ! -d "node_modules/@prisma/client" ]; then
  echo "Generating Prisma client..."
  npm run db:generate
fi

# Run database migrations
echo "Running database migrations..."
npm run db:deploy

# Start the application
echo "Starting Evolution API..."
npm run start:prod