# Azure Webhook Hello World

![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Go](https://img.shields.io/badge/go-%2300ADD8.svg?style=for-the-badge&logo=go&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

A simple "Hello World" webhook application deployed to Azure using Terraform, Docker, and Go.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Deployment](#deployment)
- [Local Development](#local-development)
- [Configuration](#configuration)
- [Platform-Specific Notes](#platform-specific-notes)
- [Troubleshooting](#troubleshooting)

## Overview

This project demonstrates how to deploy a containerized Go web application to Azure using infrastructure as code. It creates:

- A simple Go web server with "Hello World" and health check endpoints
- Docker container for the application
- Azure infrastructure using Terraform:
  - Resource Group
  - Container Registry (ACR)
  - App Service Plan (B1 tier)
  - Web App for Containers

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/andrewbearsley/azure-webhook-helloworld.git
cd azure-webhook-helloworld

# 2. Set up your variables file
cp terraform/variables.tf.example terraform/variables.tf

# 3. Edit variables.tf with your subscription ID and unique resource names
# Replace [YYYYMMDD] placeholders with current date (e.g., 20250513)

# 4. Login to Azure
az login

# 5. Deploy everything
./deploy.sh

# 6. Test your webhook
curl https://your-app-name.azurewebsites.net
```

## Prerequisites

- **Azure Account** with active subscription
- **Azure CLI** installed and configured
- **Terraform** v1.0.0+
- **Docker** installed and running
- **Go** v1.16+ (only for local development)

## Project Structure

```
.
├── src/app/              # Go application code
├── docker/               # Docker configuration
├── terraform/            # Terraform IaC files
├── scripts/              # Deployment scripts
├── deploy.sh             # Master deployment script
└── README.md             # This documentation
```

## Deployment

### Option 1: Full Deployment (Recommended)

Run the master deployment script to handle everything in one go:

```bash
./deploy.sh
```

This will:
1. Build the Docker image
2. Initialize and apply Terraform
3. Push the image to ACR
4. Deploy to Azure App Service
5. Output the webhook URL

### Option 2: Step-by-Step Deployment

For more control, run each step individually:

```bash
# 1. Build Docker image
./scripts/build.sh

# 2. Initialize Terraform
./scripts/terraform-init.sh

# 3. Apply Terraform to create Azure resources
./scripts/terraform-apply.sh

# 4. Deploy container image to Azure
./scripts/deploy-image.sh
```

### Cleanup

To remove all Azure resources:

```bash
./scripts/terraform-destroy.sh
```

## Local Development

### Run with Go

```bash
cd src/app
go run main.go
```

### Run with Docker

```bash
# Build the image
./scripts/build.sh

# Run the container
docker run -p 8080:8080 webhook:latest
```

Access at http://localhost:8080

## Configuration

### Setting Up Your Variables

This repository uses a template for configuration. Before deploying:

1. Create your variables file:
   ```bash
   cp terraform/variables.tf.example terraform/variables.tf
   ```

2. Edit `terraform/variables.tf` to update:
   - Your Azure subscription ID
   - Unique names for ACR and App Service
   - Region and service tier if needed

### Required Configuration

| Variable | Description | How to Get/Set |
|----------|-------------|-------------|
| `subscription_id` | Your Azure subscription ID | Run `az account show --query id --output tsv` |
| `acr_name` | Container Registry name (globally unique) | Use format `webhookacr[YYYYMMDD]` |
| `app_service_name` | App Service name (globally unique) | Use format `webhook-app-[YYYYMMDD]` |
| `location` | Azure region | Default: `australiaeast` |
| `app_service_plan_sku` | App Service tier | Default: `B1` (Basic) |

## Platform-Specific Notes

### Apple Silicon (M1/M2/M3) Users

- The build script automatically handles cross-platform building for AMD64 (required for Azure)
- No manual configuration needed - the Dockerfile is configured for proper cross-compilation

### Windows Users

- Ensure Docker Desktop is using Linux containers
- Use Git Bash or WSL to run the shell scripts
- You may need to adjust file permissions: `chmod +x scripts/*.sh deploy.sh`

## Troubleshooting

### Common Issues

1. **Resource name conflicts**: 
   - Ensure ACR and App Service names are globally unique
   - Use current date in resource names to avoid conflicts

2. **Authentication errors**:
   - Run `az login` before deployment
   - Verify you have Contributor access to your subscription

3. **Deployment failures**:
   - Check Azure portal for specific error messages
   - Ensure your subscription has quota for the resources
   - The F1 (Free) tier does not support the `always_on` setting

4. **Container issues**:
   - If deploying from Apple Silicon, ensure cross-platform building is working
   - Check container logs in Azure portal

### Getting Help

If you encounter issues, check:
- Azure App Service logs in the portal
- Terraform state with `terraform state list`
- Docker build logs