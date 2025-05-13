#!/bin/bash
set -e

# Initialize Terraform
echo "Initializing Terraform..."
cd terraform
terraform init

echo "Terraform initialized successfully."
