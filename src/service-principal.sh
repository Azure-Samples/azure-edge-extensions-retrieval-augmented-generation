#!/bin/bash
# This script requires Azure CLI version 2.25.0 or later. Check version with `az --version`.

# Modify for your environment.
# ACR_NAME: The name of your Azure Container Registry
# SERVICE_PRINCIPAL_NAME: Must be unique within your AD tenant
ACR_NAME= <your-acr-name>
SERVICE_PRINCIPAL_NAME= <input-a-service-principle-name>
SECRET_NAME= <input-a-secret-name-for-your-cluster>
NAMESPACE= <namespace-should-be-the-same-as-AIO-components-you-deployed>
# Obtain the full registry ID
ACR_REGISTRY_ID=$(az acr show --name $ACR_NAME --query "id" --output tsv)
echo $ACR_REGISTRY_ID

# Create the service principal with rights scoped to the registry.
# Default permissions are for docker pull access. Modify the '--role'
# argument value as desired:
# acrpull:     pull only
# acrpush:     push and pull
# owner:       push, pull, and assign roles
PASSWORD=$(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role acrpull --query "password" --output tsv)
USER_NAME=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query "[].appId" --output tsv)

# Output the service principal's credentials; use these in your services and
# applications to authenticate to the container registry.
echo "Service principal ID: $USER_NAME"
echo "Service principal password: $PASSWORD"

#create secret
kubectl create secret docker-registry $SECRET_NAME \
   --docker-server=$ACR_NAME.azurecr.io \
   --docker-username=$USER_NAME \
   --docker-password=$PASSWORD \
   --namespace=$NAMESPACE

echo "acr aksee secret is created: $SECRET_NAME"
