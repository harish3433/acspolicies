#!/bin/bash

# 1. Create ACS token secret
echo "Creating ACS token secret..."
kubectl create secret generic acs-token \
  --from-literal=token=$ACS_TOKEN \
  -n stackrox

# 2. Deploy ArgoCD applications
echo "Deploying ArgoCD applications..."
kubectl apply -f argocd/

# 3. Verify deployment
echo "Checking ArgoCD applications..."
kubectl get applications -n argocd

echo "Setup complete. ArgoCD will now sync policies from Git."
