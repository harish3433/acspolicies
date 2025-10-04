#!/bin/bash

echo "=== Quick Cleanup (GitOps only) ==="

# Delete ArgoCD applications only
oc delete applications.argoproj.io acs-policies -n argocd --ignore-not-found
oc delete applications.argoproj.io acs-policy-precheck -n argocd --ignore-not-found

# Delete policy jobs
oc delete jobs -n stackrox -l app=acs-policy-sync --ignore-not-found

# Delete ACS secret
oc delete secret acs-token -n stackrox --ignore-not-found

echo "✅ GitOps components removed (ArgoCD installation kept)"
