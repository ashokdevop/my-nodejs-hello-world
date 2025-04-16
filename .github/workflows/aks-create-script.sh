#!/bin/sh

# This is the shell script for creating AKS cluster, ACR Repo and a namespace

#Create Resource Group

AKS_RESOURCE_GROUP=githubdemoacr-rg1

AKS_REGION=ukSouth

# Set Cluster Name

AKS_CLUSTER=aksdemocluster1

VM_SIZE="Standard_B2s"

# set ACR name

ACR_NAME=githubactionacr2

echo $AKS_RESOURCE_GROUP, $AKS_REGION, $AKS_CLUSTER, $ACR_NAME

# Create Resource Group

az group create --location ${AKS_REGION} --name ${AKS_RESOURCE_GROUP}

# Create AKS cluster with two worker nodes

az aks create --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --node-vm-size $VM_SIZE --node-count 1 --generate-ssh-keys


# Create Azure Container Registry

az acr create --resource-group ${AKS_RESOURCE_GROUP} \

                     --name ${ACR_NAME} \

                     --sku Standard \

                     --location ${AKS_REGION} 

#Providing required permission for downloading Docker image from ACR into AKS Cluster

az aks update -n ${AKS_CLUSTER} -g ${AKS_RESOURCE_GROUP} --attach-acr ${ACR_NAME}

# Configure Kube Credentials

az aks get-credentials --name ${AKS_CLUSTER}  --resource-group ${AKS_RESOURCE_GROUP}



# Create a namespace in AKS cluster for deployment

kubectl create namespace demo-deployment2
