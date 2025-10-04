#!/bin/bash

echo "=== Quick ACS Policy Test ==="

# Test 1: Deploy ArgoCD apps
echo "1. Deploying ArgoCD applications..."
oc apply -f argocd/

# Test 2: Check if apps are created
echo "2. Checking applications..."
sleep 5
oc get applications -n argocd

# Test 3: Manual sync trigger
echo "3. Triggering manual sync..."
oc patch application acs-policies -n argocd --type merge -p '{"operation":{"sync":{}}}'

# Test 4: Watch sync status
echo "4. Watching sync status..."
for i in {1..6}; do
    echo "Check $i/6:"
    oc get applications -n argocd -o custom-columns=NAME:.metadata.name,SYNC:.status.sync.status
    sleep 10
done

echo "✅ Quick test completed!"
