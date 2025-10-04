#!/bin/bash

echo "=== ACS Policy GitOps Test Flow ==="

# Step 1: Check prerequisites
echo "Step 1: Checking prerequisites..."
if ! oc get deployment argocd-server -n argocd &>/dev/null; then
    echo "❌ ArgoCD not installed. Run: ./install-argocd.sh"
    exit 1
fi

if ! oc get secret acs-token -n stackrox &>/dev/null; then
    echo "❌ ACS token missing. Set ACS_TOKEN and run setup"
    exit 1
fi

# Step 2: Deploy ArgoCD applications
echo "Step 2: Deploying ArgoCD applications..."
oc apply -f argocd/
sleep 10

# Step 3: Check application status
echo "Step 3: Checking ArgoCD applications..."
oc get applications -n argocd

# Step 4: Test policy change
echo "Step 4: Testing policy change..."
echo "Making test change to policy description..."
sed -i 's/Alert on deployments/TEST-CHANGE Alert on deployments/' policies/dev/30-day-scan-age.yml

# Step 5: Commit and push
echo "Step 5: Pushing test change..."
git add .
git commit -m "Test: Policy sync verification"
git push origin master

# Step 6: Monitor ArgoCD sync
echo "Step 6: Monitoring ArgoCD sync (waiting 60 seconds)..."
sleep 60

echo "Checking sync status..."
oc get applications -n argocd -o custom-columns=NAME:.metadata.name,SYNC:.status.sync.status,HEALTH:.status.health.status

# Step 7: Check jobs
echo "Step 7: Checking policy sync jobs..."
oc get jobs -n stackrox | head -10

# Step 8: Revert test change
echo "Step 8: Reverting test change..."
sed -i 's/TEST-CHANGE Alert on deployments/Alert on deployments/' policies/dev/30-day-scan-age.yml
git add .
git commit -m "Revert: Test change"
git push origin master

echo "✅ Test flow completed!"
