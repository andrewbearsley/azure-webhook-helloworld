# Hello World Webhook hosted in Azure

## Purpose

This project is a proof of concept for hosting a web endpoint in Azure. It demonstrates how to create a simple Go web server, containerize it, and deploy it to Azure App Service using Terraform for infrastructure provisioning.

## Technology Stack

- Language: Go (Golang)
- Cloud Provider: Azure
- Infrastructure as Code (IaC): Terraform
- Container Registry: Azure Container Registry (ACR)

## Features

- Web endpoint that returns a simple "Hello World" message
- Health check endpoint at `/health`
- Containerized application using Docker
- Automated deployment using Terraform and shell script
- Azure App Service for hosting

## Prerequisites

- Azure account with active subscription
- Azure CLI installed and configured
- Terraform installed (v1.0.0+)
- Docker installed and running
- Go installed (v1.16+)

## Project Structure

```
.
├── src/                # Source code directory
│   └── app/            # Application code
│       ├── main.go     # Go application source code
│       └── go.mod      # Go module definition
├── docker/             # Docker configuration
│   └── Dockerfile      # Docker configuration for containerization
├── terraform/          # Terraform configuration files
│   ├── main.tf         # Main Terraform configuration
│   ├── variables.tf    # Variable definitions
│   └── outputs.tf      # Output definitions
├── scripts/            # Deployment scripts
│   ├── build.sh        # Script to build Docker image
│   ├── terraform-init.sh # Script to initialize Terraform
│   ├── terraform-apply.sh # Script to apply Terraform configuration
│   ├── terraform-destroy.sh # Script to destroy Terraform resources
│   └── deploy-image.sh # Script to deploy container image to Azure
├── deploy.sh           # Master deployment script
└── README.md           # Project documentation
```

## Infrastructure as Code (Terraform)

This project uses Terraform to provision and manage the following Azure resources:

1. **Azure Resource Group** - A logical container for all Azure resources
2. **Azure Container Registry (ACR)** - Stores and manages the Docker container images
   - Uses Basic SKU tier
   - Enables admin access for simplified deployment
3. **App Service Plan** - Defines the compute resources for the web app
   - Uses Linux OS
   - B1 (Basic) tier for cost-effective testing
4. **Azure Web App for Containers** - Hosts the containerized application
   - Configured to pull the container image from ACR
   - Includes necessary environment variables and connection settings

The Terraform configuration is organized into:
- `main.tf` - Main resource definitions
- `variables.tf` - Customizable input variables with defaults
- `outputs.tf` - Important information exported after deployment

## Setup and Deployment

### Local Development

1. Clone the repository
2. Run the Go application locally:
   ```
   cd src/app
   go run main.go
   ```
3. Access the application at http://localhost:8080

### Building with Docker

1. Build the Docker image:
   ```
   ./scripts/build.sh
   ```
   Or manually:
   ```
   docker build -t webhook:latest -f docker/Dockerfile .
   ```
2. Run the Docker container:
   ```
   docker run -p 8080:8080 webhook:latest
   ```
3. Access the application at http://localhost:8080

### Terraform Operations

The project includes separate scripts for each Terraform operation to allow for more control over the deployment process:

1. **Initialize Terraform** (sets up providers and modules):
   ```
   ./scripts/terraform-init.sh
   ```

2. **Apply Terraform** (create or update infrastructure):
   ```
   ./scripts/terraform-apply.sh
   ```
   - Add `-auto-approve` to skip confirmation prompt
   - Add other terraform apply parameters as needed

3. **Destroy Terraform** (remove all created infrastructure):
   ```
   ./scripts/terraform-destroy.sh
   ```
   - Add `-auto-approve` to skip confirmation prompt

4. **Deploy Container Image** (after infrastructure is created):
   ```
   ./scripts/deploy-image.sh
   ```

### Full Deployment

For a complete deployment in one step:

1. Ensure you have all prerequisites installed
2. Make sure you're logged in to Azure CLI:
   ```
   az login
   ```
3. Run the full deployment script:
   ```
   ./deploy.sh
   ```
4. The script will:
   - Build the Docker image
   - Initialize and apply Terraform configuration
   - Push the Docker image to Azure Container Registry
   - Deploy the application to Azure App Service
   - Output the URL of your deployed webhook

## Testing

Once deployed, you can test the webhook by sending a request to the provided URL:

```
curl https://your-app-service-name.azurewebsites.net
```

You should receive a "Hello World from Azure!" response.

## Getting Started with This Repository

This repository does not include the `variables.tf` file with actual configuration values, as it contains sensitive information like subscription IDs. Instead, we provide a template file that you can use to create your own configuration.

1. Copy the example variables file to create your own:
   ```bash
   cp terraform/variables.tf.example terraform/variables.tf
   ```

2. Edit the `terraform/variables.tf` file to update:
   - Your Azure subscription ID
   - Unique names for ACR and App Service (replace the `[YYYYMMDD]` placeholders with the current date or another unique string)
   - Any other configuration values you want to customize

3. The scripts have been updated to dynamically retrieve resource names from Terraform outputs, so you only need to modify the `variables.tf` file - all scripts will automatically use your custom resource names.

## Configuration for Different Azure Subscriptions

When setting up your `variables.tf` file, you'll need to configure the following:

### Required Configuration Changes

1. **Azure Subscription ID**:
   - Update the `subscription_id` variable in `terraform/variables.tf` with your own subscription ID
   - You can find your subscription ID by running `az account show --query id --output tsv`

2. **Resource Names**:
   - The Azure Container Registry (ACR) name must be globally unique across all of Azure
   - Update the `acr_name` variable in `terraform/variables.tf` with a unique name (e.g., add a timestamp or random string)
   - Similarly, the App Service name must be globally unique
   - Update the `app_service_name` variable with a unique name

3. **Region/Location**:
   - The default region is set to Australia East
   - You can change this by updating the `location` variable in `terraform/variables.tf`
   - Choose a region that has quota available for your subscription

4. **Service Plan Tier**:
   - The default tier is B1 (Basic)
   - You can change this by updating the `app_service_plan_sku` variable
   - Note that the Free (F1) tier does not support the `always_on` setting required by this application

### Platform-Specific Considerations

1. **Apple Silicon (ARM) Users**:
   - When building Docker images on Apple Silicon (M1/M2/M3) Macs, you must explicitly build for the AMD64 platform
   - The `build.sh` script has been configured to handle this cross-platform building
   - If you modify the Dockerfile, ensure it maintains the platform-specific build settings

2. **Windows Users**:
   - Ensure Docker Desktop is configured to use Linux containers
   - You may need to modify the shell scripts to work in your environment (e.g., Git Bash, WSL)

### Authentication and Permissions

1. **Azure CLI Authentication**:
   - Ensure you're logged in with `az login` before running any deployment scripts
   - Verify you have the necessary permissions in your subscription (Contributor role or equivalent)

2. **Service Principal (for CI/CD)**:
   - For automated deployments, consider creating a service principal:
     ```
     az ad sp create-for-rbac --name "webhook-app-sp" --role contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
     ```
   - Then configure Terraform to use these credentials

## Notes

- Make sure your ACR name is globally unique in Azure.
- The deployment scripts assume you have the Azure CLI, Terraform, and Docker installed and properly configured.