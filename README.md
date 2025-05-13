# Azure Webhook Hello World

A simple "Hello World" webhook application deployed to Azure using Go, Terraform, and Docker.

## Overview

This project demonstrates deploying a containerized Go web application to Azure App Service using Terraform for infrastructure as code. The application provides a basic webhook endpoint that returns "Hello World from Azure!" and a health check endpoint.

## Quick Start

```bash
# Clone and prepare
git clone https://github.com/andrewbearsley/azure-webhook-helloworld.git
cd azure-webhook-helloworld
cp terraform/variables.tf.example terraform/variables.tf

# Edit variables.tf with your Azure subscription ID and unique resource names
# Replace [YYYYMMDD] placeholders with current date (e.g., 20250513)

# Deploy
az login
./deploy.sh

# Test
curl https://your-app-name.azurewebsites.net
```

## Prerequisites

- Azure account with active subscription
- Azure CLI, Terraform, and Docker installed

## Project Structure

- `src/app/` - Go application code
- `docker/` - Dockerfile for containerization
- `terraform/` - Infrastructure as code
- `scripts/` - Deployment scripts
- `deploy.sh` - Master deployment script

## Deployment Options

### Full Deployment

```bash
./deploy.sh  # Handles everything in one step
```

### Individual Steps

```bash
./scripts/build.sh           # Build Docker image
./scripts/terraform-init.sh   # Initialize Terraform
./scripts/terraform-apply.sh  # Create Azure resources
./scripts/deploy-image.sh     # Deploy container to Azure
```

### Cleanup

```bash
./scripts/terraform-destroy.sh
```

## Configuration

Before deployment, update `terraform/variables.tf` with:

- Your Azure subscription ID (`subscription_id`)
- Unique Container Registry name (`acr_name`)
- Unique App Service name (`app_service_name`)

## Notes

- **Apple Silicon users**: The build script handles cross-platform building for AMD64
- **Resource names**: ACR and App Service names must be globally unique
- **App Service Plan**: Uses B1 (Basic) tier by default; F1 (Free) tier doesn't support `always_on`

For troubleshooting, check Azure Portal logs or run `terraform state list` to verify resource creation.