#!/bin/bash

# Install ArgoCD on OpenShift
echo "Installing ArgoCD..."

# Create ArgoCD namespace
oc new-project argocd

# Install ArgoCD operator
cat <<EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: argocd-operator
  namespace: argocd
spec:
  channel: alpha
  name: argocd-operator
  source: community-operators
  sourceNamespace: openshift-marketplace
EOF

# Wait for operator to be ready
echo "Waiting for ArgoCD operator..."
sleep 30

# Create ArgoCD instance
cat <<EOF | oc apply -f -
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: argocd
  namespace: argocd
spec:
  server:
    route:
      enabled: true
EOF

# Wait for ArgoCD to be ready
echo "Waiting for ArgoCD to be ready..."
oc wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# Get ArgoCD route
echo "ArgoCD installed successfully!"
echo "ArgoCD URL: https://$(oc get route argocd-server -n argocd -o jsonpath='{.spec.host}')"
echo "Username: admin"
echo "Password: $(oc get secret argocd-cluster -n argocd -o jsonpath='{.data.admin\.password}' | base64 -d)"
