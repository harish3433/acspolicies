# ACS Policy GitOps - Complete Setup Guide

## What This Setup Does

### 1. **Policy as Code Management**
- Stores ACS security policies as YAML files in Git
- Enables version control, peer review, and audit trails for security policies
- Supports environment-specific configurations (dev vs prod)

### 2. **Automated Policy Validation**
- Tests policy syntax before deployment
- Validates policies against ACS API using dry-run
- Prevents broken policies from being deployed

### 3. **GitOps Deployment**
- ArgoCD monitors Git repository for policy changes
- Automatically syncs policies to ACS Central when changes are pushed
- Provides declarative policy state management

### 4. **Environment Lifecycle Management**
- Different policy configurations per environment
- Automated enable/disable of policies based on environment
- Stricter policies for production (shorter scan age, enforcement enabled)

## How to Run

### Prerequisites
```bash
# Set your ACS token
export ACS_TOKEN="your-acs-central-api-token"

# Ensure you have access to OpenShift cluster with:
# - ArgoCD installed
# - ACS/StackRox installed
```

### Step 1: Initial Setup
```bash
# Run the setup script
./setup.sh
```

### Step 2: Push to Git Repository
```bash
# Initialize git repo and push to GitHub
git init
git add .
git commit -m "Initial ACS policy setup"
git remote add origin https://github.com/your-org/acs-policies.git
git push -u origin main
```

### Step 3: Monitor Deployment
```bash
# Check ArgoCD applications
kubectl get applications -n argocd

# Check policy sync jobs
kubectl get jobs -n stackrox

# View ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## What Happens When You Push Changes

1. **Git Push** → Policy files updated in repository
2. **ArgoCD Detection** → ArgoCD detects changes automatically
3. **Pre-Validation** → Validation job runs (sync-wave -1)
4. **Policy Deployment** → Policies applied to Kubernetes as ConfigMaps
5. **ACS Sync** → Post-sync job pushes policies to ACS Central API
6. **Policy Activation** → Policies become active in ACS Central

## File Structure Explained

```
├── policies/
│   ├── dev/                    # Development policies
│   │   ├── 30-day-scan-age.yml    # Policy definition
│   │   └── policy-states.yml      # Enable/disable states
│   ├── prod/                   # Production policies (stricter)
│   │   ├── 30-day-scan-age.yml    # 15-day scan age + enforcement
│   │   └── policy-states.yml      # Policy states
│   ├── kustomization.yml       # Kustomize config for K8s deployment
│   └── policy-sync-job.yml     # Job that syncs to ACS Central
├── argocd/
│   ├── acs-policy-app.yml      # Main ArgoCD application
│   └── acs-policy-precheck.yml # Pre-validation application
└── precheck/
    └── policy-validation-job.yml # Policy validation job
```

## Benefits

- **Audit Trail**: All policy changes tracked in Git
- **Peer Review**: Use pull requests for policy changes
- **Automated Testing**: Policies validated before deployment
- **Environment Consistency**: Same process for dev/prod
- **Rollback Capability**: Git-based rollback of policy changes
- **Compliance**: Immutable policy deployment history
