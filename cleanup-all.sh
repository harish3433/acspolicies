#!/bin/bash

echo "=== ACS Policy GitOps Cleanup ==="
echo "⚠️  This will destroy ALL GitOps setup and policies!"
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

# 1. Delete ArgoCD applications
echo "1. Deleting ArgoCD applications..."
oc delete applications.argoproj.io acs-policies -n argocd --ignore-not-found
oc delete applications.argoproj.io acs-policy-precheck -n argocd --ignore-not-found

# 2. Delete policy sync jobs
echo "2. Deleting policy sync jobs..."
oc delete jobs -n stackrox -l app=acs-policy-sync --ignore-not-found

# 3. Delete ACS token secret
echo "3. Deleting ACS token secret..."
oc delete secret acs-token -n stackrox --ignore-not-found

# 4. Delete policies from ACS Central (if accessible)
echo "4. Attempting to delete policies from ACS Central..."
ACS_URL=$(oc get route central -n stackrox -o jsonpath='{.spec.host}' 2>/dev/null)
if [ -n "$ACS_URL" ] && [ -n "$ACS_TOKEN" ]; then
    curl -k -X DELETE \
      -H "Authorization: Bearer $ACS_TOKEN" \
      "https://$ACS_URL/v1/policies/a3eb6dbe-e9ca-451a-919b-216cf7ee11f5" 2>/dev/null
    echo "Policy deletion attempted"
else
    echo "⚠️  Cannot delete ACS policies - ACS_TOKEN not set or ACS not accessible"
fi

# 5. Delete ArgoCD (optional)
read -p "Delete entire ArgoCD installation? (yes/no): " delete_argocd
if [ "$delete_argocd" = "yes" ]; then
    echo "5. Deleting ArgoCD installation..."
    oc delete argocd argocd -n argocd --ignore-not-found
    oc delete subscription argocd-operator -n argocd --ignore-not-found
    oc delete project argocd --ignore-not-found
else
    echo "5. Keeping ArgoCD installation"
fi

# 6. Clean local Git repo (optional)
read -p "Remove local Git configuration? (yes/no): " clean_git
if [ "$clean_git" = "yes" ]; then
    echo "6. Cleaning Git configuration..."
    rm -rf .git
    echo "Git history removed"
else
    echo "6. Keeping Git configuration"
fi

echo ""
echo "✅ Cleanup completed!"
echo "Destroyed components:"
echo "- ArgoCD applications"
echo "- Policy sync jobs"
echo "- ACS token secret"
echo "- ACS policies (if accessible)"
if [ "$delete_argocd" = "yes" ]; then
    echo "- ArgoCD installation"
fi
if [ "$clean_git" = "yes" ]; then
    echo "- Git configuration"
fi
