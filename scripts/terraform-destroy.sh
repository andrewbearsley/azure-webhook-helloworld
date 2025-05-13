#!/bin/bash
set -e

# Destroy Azure resources created by Terraform
echo "Destroying Azure resources..."
cd terraform
terraform destroy $@

echo "Terraform destroy completed."
