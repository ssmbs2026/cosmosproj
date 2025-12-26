# Azure Cosmos DB Infrastructure Setup

This repository contains the infrastructure-as-code (IAC) to deploy an Azure Cosmos DB (MongoDB API) account using Azure Bicep and GitHub Actions.

## Prerequisites

1.  **Azure Subscription**: You need an Azure subscription (Free Trial is valid).
2.  **GitHub Repository**: This code must be pushed to your GitHub repository.

## Setup Steps

### 1. Create an Azure Resource Group
You must manually create a Resource Group in Azure for this project.
1.  Log in to the [Azure Portal](https://portal.azure.com).
2.  Search for "Resource groups" and click **Create**.
3.  Name it (e.g., `cosmos-app-rg`) and select a region (e.g., `East US`).
4.  Click **Review + create** -> **Create**.

### 2. Create Service Principal
You need a Service Principal to allow GitHub Actions to deploy to your Azure subscription. Run the following command in Azure Cloud Shell (click the terminal icon in the portal header):

```bash
# Replace <subscription-id> with your actual Subscription ID
# Replace <resource-group-name> with the name you chose above (e.g., cosmos-app-rg)
az ad sp create-for-rbac --name "cosmos-deploy-sp" --role contributor --scopes /subscriptions/<subscription-id>/resourceGroups/<resource-group-name> --sdk-auth
```

This command will output a JSON object. **Copy completely**.

### 3. Configure GitHub Secrets
1.  Go to your GitHub Repository -> **Settings** -> **Secrets and variables** -> **Actions**.
2.  Click **New repository secret**.
3.  **Name**: `AZURE_CREDENTIALS`
4.  **Value**: Paste the entire JSON output from Step 2.
5.  Click **Add secret**.
6.  Create another secret:
    *   **Name**: `AZURE_RESOURCE_GROUP`
    *   **Value**: The name of your resource group (e.g., `cosmos-app-rg`).

## Running the Pipeline

1.  Go to the **Actions** tab in your GitHub repository.
2.  Select **Deploy Cosmos DB Infrastructure** from the left sidebar.
3.  Click the **Run workflow** dropdown and hit **Run workflow**.

The pipeline will:
1.  Log in to Azure.
2.  Deploy the Bicep template.
3.  Create a Free Tier Cosmos DB account (if available).
