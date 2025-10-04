#!/bin/bash

echo "=== ACS Policy GitOps Setup Verification ==="

# 1. Check ArgoCD installation
echo "1. Checking ArgoCD installation..."
if oc get deployment argocd-server -n argocd &>/dev/null; then
    echo "✅ ArgoCD server deployed"
    echo "   Status: $(oc get deployment argocd-server -n argocd -o jsonpath='{.status.conditions[0].type}')"
else
    echo "❌ ArgoCD server not found"
fi

# 2. Check ArgoCD route
echo "2. Checking ArgoCD access..."
ARGOCD_URL=$(oc get route argocd-server -n argocd -o jsonpath='{.spec.host}' 2>/dev/null)
if [ -n "$ARGOCD_URL" ]; then
    echo "✅ ArgoCD URL: https://$ARGOCD_URL"
else
    echo "❌ ArgoCD route not found"
fi

# 3. Check ACS token secret
echo "3. Checking ACS token secret..."
if oc get secret acs-token -n stackrox &>/dev/null; then
    echo "✅ ACS token secret exists"
else
    echo "❌ ACS token secret missing"
fi

# 4. Check ArgoCD applications
echo "4. Checking ArgoCD applications..."
APPS=$(oc get applications -n argocd --no-headers 2>/dev/null | wc -l)
if [ "$APPS" -gt 0 ]; then
    echo "✅ ArgoCD applications found: $APPS"
    oc get applications -n argocd -o custom-columns=NAME:.metadata.name,SYNC:.status.sync.status,HEALTH:.status.health.status
else
    echo "❌ No ArgoCD applications found"
fi

# 5. Check policy sync jobs
echo "5. Checking policy sync jobs..."
JOBS=$(oc get jobs -n stackrox --no-headers 2>/dev/null | grep -c policy)
if [ "$JOBS" -gt 0 ]; then
    echo "✅ Policy sync jobs found: $JOBS"
else
    echo "ℹ️  No policy sync jobs (normal if not synced yet)"
fi

# 6. Test ACS connectivity
echo "6. Testing ACS Central connectivity..."
ACS_URL=$(oc get route central -n stackrox -o jsonpath='{.spec.host}' 2>/dev/null)
if [ -n "$ACS_URL" ]; then
    echo "✅ ACS Central URL: https://$ACS_URL"
    if curl -k -s "https://$ACS_URL/v1/ping" &>/dev/null; then
        echo "✅ ACS Central is accessible"
    else
        echo "⚠️  ACS Central may not be ready"
    fi
else
    echo "❌ ACS Central route not found"
fi

# 7. Check GitHub repo sync
echo "7. Checking GitHub repository sync..."
if git remote get-url origin &>/dev/null; then
    REPO_URL=$(git remote get-url origin)
    echo "✅ Git repo: $REPO_URL"
    if git status --porcelain | grep -q .; then
        echo "⚠️  Uncommitted changes found"
    else
        echo "✅ Repository is clean"
    fi
else
    echo "❌ Git repository not configured"
fi

echo ""
echo "=== Summary ==="
echo "ArgoCD URL: https://$ARGOCD_URL"
echo "ACS Central: https://$ACS_URL"
echo "GitHub Repo: $(git remote get-url origin 2>/dev/null || echo 'Not configured')"
