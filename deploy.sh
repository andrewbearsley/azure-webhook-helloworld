#!/bin/bash
set -e

# Master deployment script that runs all steps in sequence

# Login to Azure
echo "Logging in to Azure..."
az login

# Step 1: Build the Docker image
echo "Step 1: Building Docker image..."
./scripts/build.sh

# Step 2: Initialize Terraform
echo "Step 2: Initializing Terraform..."
./scripts/terraform-init.sh

# Step 3: Apply Terraform to create Azure resources
echo "Step 3: Applying Terraform configuration..."
./scripts/terraform-apply.sh -auto-approve

# Step 4: Deploy the container image to Azure
echo "Step 4: Deploying container image to Azure..."
./scripts/deploy-image.sh

echo "Full deployment completed successfully!"
echo "To destroy the infrastructure, run: ./scripts/terraform-destroy.sh"
