#!/bin/bash

echo "=== Testing ACS Policy Sync ==="

# 1. Make a test change to policy
echo "1. Making test change to policy..."
sed -i 's/description: "Alert on deployments/description: "TEST - Alert on deployments/' policies/dev/30-day-scan-age.yml

# 2. Commit and push change
echo "2. Pushing test change to GitHub..."
git add policies/dev/30-day-scan-age.yml
git commit -m "Test: Update policy description"
git push origin master

# 3. Wait for ArgoCD to detect change
echo "3. Waiting for ArgoCD to sync (30 seconds)..."
sleep 30

# 4. Check ArgoCD sync status
echo "4. Checking ArgoCD sync status..."
oc get applications -n argocd -o custom-columns=NAME:.metadata.name,SYNC:.status.sync.status,HEALTH:.status.health.status

# 5. Check if policy sync job ran
echo "5. Checking policy sync jobs..."
oc get jobs -n stackrox | grep policy

# 6. Revert test change
echo "6. Reverting test change..."
sed -i 's/description: "TEST - Alert on deployments/description: "Alert on deployments/' policies/dev/30-day-scan-age.yml
git add policies/dev/30-day-scan-age.yml
git commit -m "Revert test change"
git push origin master

echo "✅ Policy sync test completed"
