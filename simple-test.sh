#!/bin/bash

echo "=== Simple ACS Policy GitOps Test ==="

# 1. Check current status
echo "1. Current ArgoCD applications:"
oc get applications.argoproj.io -n argocd

# 2. Make a simple policy change
echo "2. Making test policy change..."
TIMESTAMP=$(date +%s)
sed -i "s/description: \"Alert on deployments/description: \"TEST-$TIMESTAMP Alert on deployments/" policies/dev/30-day-scan-age.yml

# 3. Commit and push
echo "3. Committing change to GitHub..."
git add policies/dev/30-day-scan-age.yml
git commit -m "Test policy sync - $TIMESTAMP"
git push origin master

# 4. Wait and check sync
echo "4. Waiting for ArgoCD to detect change (30 seconds)..."
sleep 30

echo "5. Checking sync status:"
oc get applications.argoproj.io -n argocd

# 6. Check if any jobs were created
echo "6. Checking for policy sync jobs:"
oc get jobs -n stackrox 2>/dev/null | grep -i policy || echo "No policy jobs found yet"

# 7. Revert change
echo "7. Reverting test change..."
sed -i "s/description: \"TEST-$TIMESTAMP Alert on deployments/description: \"Alert on deployments/" policies/dev/30-day-scan-age.yml
git add policies/dev/30-day-scan-age.yml
git commit -m "Revert test change - $TIMESTAMP"
git push origin master

echo "✅ Test completed! Check ArgoCD UI for detailed sync status."
echo "ArgoCD UI: https://$(oc get route argocd-server -n argocd -o jsonpath='{.spec.host}')"
