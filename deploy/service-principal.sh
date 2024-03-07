#!/bin/bash
# This script requires Azure CLI version 2.25.0 or later. Check version with `az --version`.

if [ -z "$ACR_NAME" ]; then
    echo "ACR_NAME is not set"
    exit 1
fi
if [ -z "$SERVICE_PRINCIPAL_NAME" ]; then
    echo "SERVICE_PRINCIPAL_NAME is not set"
    exit 1
fi
if [ -z "$SECRET_NAME" ]; then
    echo "SECRET_NAME is not set"
    exit 1
fi
if [ -z "$NAMESPACE" ]; then
    NAMESPACE="azure-iot-operations"
fi

# Setup the Environment Variables as described in Readme.md
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

echo "Kubernetes secret for ACR pull secrets is created: $SECRET_NAME"
