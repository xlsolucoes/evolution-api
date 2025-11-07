#!/bin/bash

# Startup script for Azure Web App
echo "=== Evolution API - Azure Startup ==="
echo "Current directory: $(pwd)"
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"

# Set environment
export NODE_ENV=production

# Check if DATABASE_PROVIDER is set, default to mysql if not
if [ -z "$DATABASE_PROVIDER" ]; then
  echo "WARNING: DATABASE_PROVIDER not set, defaulting to mysql"
  export DATABASE_PROVIDER=mysql
fi

echo "Database provider: $DATABASE_PROVIDER"

# Check if we have the dist folder (built application)
if [ ! -d "dist" ]; then
  echo "ERROR: dist folder not found. Make sure to build locally and deploy the dist folder."
  echo "Run 'npm run build' locally before deploying to Azure."
  exit 1
fi

# Check if main.js exists
if [ ! -f "dist/main.js" ]; then
  echo "ERROR: dist/main.js not found. Build may have failed."
  echo "Contents of dist folder:"
  ls -la dist/ || echo "Could not list dist folder"
  exit 1
fi

# Generate Prisma client if needed
echo "Checking Prisma client..."
if [ ! -d "node_modules/@prisma/client" ] || [ ! -f "node_modules/.prisma/client/index.js" ]; then
  echo "Prisma client not found, generating..."
  
  # Set DATABASE_PROVIDER if not set
  if [ -z "$DATABASE_PROVIDER" ]; then
    echo "WARNING: DATABASE_PROVIDER not set, defaulting to mysql"
    export DATABASE_PROVIDER=mysql
  fi
  
  echo "Using DATABASE_PROVIDER: $DATABASE_PROVIDER"
  
  # Generate Prisma client
  if [ -f "prisma/${DATABASE_PROVIDER}-schema.prisma" ]; then
    npx prisma generate --schema "prisma/${DATABASE_PROVIDER}-schema.prisma" || {
      echo "ERROR: Failed to generate Prisma client"
      exit 1
    }
    echo "✓ Prisma client generated"
  else
    echo "ERROR: Schema file not found: prisma/${DATABASE_PROVIDER}-schema.prisma"
    exit 1
  fi
else
  echo "✓ Prisma client already exists"
fi

# Run database migrations
echo "Running database migrations..."
npm run db:deploy || {
  echo "WARNING: Database migrations failed, but continuing..."
  echo "You may need to run migrations manually"
}

# Start the application
echo "Starting Evolution API..."
echo "Files in dist:"
ls -la dist/ | head -10

# Use PORT from Azure or default to 8080
export PORT=${PORT:-8080}
echo "Starting on port: $PORT"

node dist/main.js
