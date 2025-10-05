# ACS Policy GitOps Ansible Automation

Single comprehensive Ansible script for complete ACS Policy GitOps pipeline management.

## Prerequisites

```bash
# Install Ansible and collections
pip install ansible kubernetes
ansible-galaxy collection install -r requirements.yml

# Set ACS token
export ACS_TOKEN="your-acs-token"
```

## Complete Setup (One Command)

```bash
cd ansible/
export ACS_TOKEN="your-token"
ansible-playbook setup-complete-gitops.yml
```

This single script will:
- ✅ Create required namespaces
- ✅ Install ArgoCD (if not exists)
- ✅ Configure ACS token secret
- ✅ Setup GitOps application
- ✅ Show ArgoCD login details

## Additional Scripts

### Create New Policy
```bash
ansible-playbook create-new-policy.yml -e policy_name="My Security Policy"
```

### Show ArgoCD Login
```bash
ansible-playbook show-argocd-login.yml
```

### Complete Cleanup
```bash
ansible-playbook cleanup-gitops-pipeline.yml -e confirm_cleanup=yes
```

## Policies Location

📁 **Policies are in**: `../policies/` folder (workspace level)
- `docker-policy.yml` - Sample policy
- `policy-sync-job.yml` - Sync job
- `kustomization.yml` - Kustomize config

## GitOps Workflow

1. **Edit policies** in `policies/` folder
2. **Git commit and push** to master branch
3. **ArgoCD auto-syncs** within 3 minutes
4. **Policies appear** in ACS Central

## Example Usage

```bash
# Complete setup
export ACS_TOKEN="eyJhbGciOiJSUzI1NiIs..."
cd ansible/
ansible-playbook setup-complete-gitops.yml

# Edit policy
vim ../policies/docker-policy.yml

# Commit changes
cd ..
git add . && git commit -m "Update policy" && git push

# Check ArgoCD UI (auto-provided after setup)
```
