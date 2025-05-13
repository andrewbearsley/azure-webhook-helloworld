#!/bin/bash
set -e

# Get resource group name from Terraform outputs
cd terraform 2>/dev/null
if [ $? -eq 0 ]; then
  RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name 2>/dev/null)
  cd ..
else
  # Fallback if terraform directory doesn't exist or terraform isn't initialized
  echo "Warning: Could not get resource group name from Terraform outputs. Using default."
  RESOURCE_GROUP_NAME="webhook-rg"
fi

# Check if resource group exists
echo "Checking if resource group ${RESOURCE_GROUP_NAME} exists..."
if az group show --name ${RESOURCE_GROUP_NAME} &> /dev/null; then
  echo "Resource group ${RESOURCE_GROUP_NAME} exists. Deleting..."
  
  # Force delete the resource group and all resources within it
  az group delete --name ${RESOURCE_GROUP_NAME} --yes --no-wait
  
  echo "Resource group deletion initiated. This will happen in the background."
  echo "You can check the status with: az group show --name ${RESOURCE_GROUP_NAME}"
else
  echo "Resource group ${RESOURCE_GROUP_NAME} does not exist."
fi

echo "Cleanup process initiated."
