#!/bin/bash

# Azure deployment script for Evolution API
echo "Starting Azure deployment..."

# Set environment variables
export NODE_ENV=production

# Install dependencies
echo "Installing dependencies..."
npm ci --production

# Set DATABASE_PROVIDER
export DATABASE_PROVIDER=postgresql

# Generate Prisma client
echo "Generating Prisma client..."
npm run db:generate

# Build the application
echo "Building application..."
npm run build

# Deploy database migrations
echo "Deploying database migrations..."
npm run db:deploy

echo "Deployment completed!"