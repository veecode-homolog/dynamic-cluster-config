#!/bin/bash

# Verifica se o namespace vkpr existe e cria se não existir
kubectl get namespace vkpr || kubectl create namespace vkpr

# Aplica os arquivos YAML usando os caminhos corretos
kubectl apply -f ./k8s-service-account/cluster-role.yaml
kubectl apply -f ./k8s-service-account/service-account.yaml
kubectl apply -f ./k8s-service-account/cluster-role-binding.yaml

# Extrai o nome e o namespace da Service Account dos arquivos YAML
SERVICE_ACCOUNT_NAME=$(cat ./k8s-service-account/service-account.yaml | yq -e '.metadata.name')
SERVICE_ACCOUNT_NAMESPACE=$(cat ./k8s-service-account/service-account.yaml | yq -e '.metadata.namespace // "default"')

echo "Generating token for $SERVICE_ACCOUNT_NAME namespace $SERVICE_ACCOUNT_NAMESPACE"
SERVICE_ACCOUNT_TOKEN=$(kubectl create token ${SERVICE_ACCOUNT_NAME} -n ${SERVICE_ACCOUNT_NAMESPACE})

# Obtém o certificado de autoridade atual do servidor
K8S_SERVER_CERTIFICATE=$(cat ~/.kube/config | yq -r ".clusters[] | select(.name == \"$(cat ~/.kube/config | yq -r '.current-context')\").cluster.certificate-authority-data")
K8S_SERVER_HOST=$(cat ~/.kube/config | yq -r ".clusters[] | select(.name == \"$(cat ~/.kube/config | yq -r '.current-context')\").cluster.server")

echo "-----------------------------------"
echo "K8S Server Host: $K8S_SERVER_HOST"
echo "-----------------------------------"
echo "Service Account Token: $SERVICE_ACCOUNT_TOKEN"
echo "-----------------------------------"
echo "K8S Certificate Authority Data: $K8S_SERVER_CERTIFICATE" 
echo "-----------------------------------"
