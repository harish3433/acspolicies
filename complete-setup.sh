#!/bin/bash

echo "=== Complete ACS Policy GitOps Setup ==="

# Step 1: Install ArgoCD
echo "Step 1: Installing ArgoCD..."
./install-argocd.sh

# Step 2: Wait for ArgoCD to be fully ready
echo "Step 2: Waiting for ArgoCD to be fully operational..."
sleep 60

# Step 3: Create ACS token secret (you need to set ACS_TOKEN env var)
if [ -z "$ACS_TOKEN" ]; then
    echo "ERROR: Please set ACS_TOKEN environment variable"
    echo "export ACS_TOKEN='your-acs-token'"
    exit 1
fi

echo "Step 3: Creating ACS token secret..."
oc create secret generic acs-token \
  --from-literal=token=$ACS_TOKEN \
  -n stackrox --dry-run=client -o yaml | oc apply -f -

# Step 4: Deploy ArgoCD applications
echo "Step 4: Deploying ArgoCD applications..."
oc apply -f argocd/

# Step 5: Verify deployment
echo "Step 5: Verifying deployment..."
sleep 10
oc get applications -n argocd

echo ""
echo "=== Setup Complete! ==="
echo "ArgoCD URL: https://$(oc get route argocd-server -n argocd -o jsonpath='{.spec.host}')"
echo "Username: admin"
echo "Password: $(oc get secret argocd-cluster -n argocd -o jsonpath='{.data.admin\.password}' | base64 -d)"
echo ""
echo "ArgoCD is now monitoring your GitHub repo for ACS policy changes."
