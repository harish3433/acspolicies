# Complete ACS Policy GitOps Setup

## Prerequisites
- OpenShift cluster access with cluster-admin privileges
- ACS/StackRox installed on the cluster
- ACS Central API token

## Quick Setup

### 1. Get your ACS token
```bash
# Option 1: From ACS Central UI
# Go to Platform Configuration > Integrations > API Token > Generate Token

# Option 2: From OpenShift (if using default setup)
export ACS_TOKEN=$(oc get secret central-htpasswd -n stackrox -o jsonpath='{.data.password}' | base64 -d)
```

### 2. Run complete setup
```bash
# Set your ACS token
export ACS_TOKEN="your-acs-central-token"

# Run the complete setup
./complete-setup.sh
```

## What the setup does:

1. **Installs ArgoCD** - Deploys ArgoCD operator and instance on OpenShift
2. **Creates ACS secret** - Stores your ACS token securely in Kubernetes
3. **Deploys ArgoCD apps** - Creates applications to monitor your GitHub repo
4. **Enables GitOps** - ArgoCD automatically syncs policy changes from Git

## After Setup:

- **ArgoCD UI**: Access via the URL provided in setup output
- **Policy Changes**: Push to GitHub repo to trigger automatic deployment
- **Monitoring**: Check ArgoCD UI to see sync status

## Manual Steps (if needed):

### Install ArgoCD only:
```bash
./install-argocd.sh
```

### Deploy ACS policy apps only:
```bash
export ACS_TOKEN="your-token"
oc create secret generic acs-token --from-literal=token=$ACS_TOKEN -n stackrox
oc apply -f argocd/
```

## Verification:
```bash
# Check ArgoCD applications
oc get applications -n argocd

# Check ACS policy sync jobs
oc get jobs -n stackrox

# View ArgoCD logs
oc logs -f deployment/argocd-server -n argocd
```
