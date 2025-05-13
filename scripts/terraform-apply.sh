#!/bin/bash
set -e

# Apply Terraform to create Azure resources
echo "Applying Terraform configuration..."
cd terraform
terraform apply $@

echo "Terraform apply completed."
