#!/bin/bash
set -e

# Configuration
IMAGE_NAME="webhook"
IMAGE_TAG="latest"

# Get resource names from Terraform outputs
cd terraform
RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name)
ACR_NAME=$(terraform output -raw acr_admin_username) # ACR name is the same as admin username
cd ..

# Get ACR login server
echo "Getting ACR information..."
cd terraform
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
ACR_USERNAME=$(terraform output -raw acr_admin_username)
ACR_PASSWORD=$(terraform output -raw acr_admin_password)
cd ..

# Login to ACR
echo "Logging in to Azure Container Registry..."
az acr login --name $ACR_NAME

# Tag the image for ACR
echo "Tagging Docker image for ACR..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}

# Push the image to ACR
echo "Pushing Docker image to ACR..."
docker push ${ACR_LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}

# Restart the web app to pick up the new image
echo "Restarting the web app..."
cd terraform
WEBAPP_NAME=$(terraform output -raw app_service_name)
cd ..
az webapp restart --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP_NAME

# Get the webhook URL
cd terraform
WEBHOOK_URL=$(terraform output -raw webhook_url)
cd ..
echo "Deployment complete! Your webhook is available at: $WEBHOOK_URL"
