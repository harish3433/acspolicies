# ACS Policy GitOps

Automated ACS security policy management using ArgoCD and GitOps workflow.

## Repository Structure
```
├── argocd/                 # ArgoCD applications
├── policies/               # ACS security policies
│   ├── container-security-policy.yml
│   ├── privileged-container-policy.yml
│   ├── policy-sync-job.yml
│   └── kustomization.yml
├── precheck/              # Policy validation
├── install-argocd.sh      # ArgoCD installation
├── complete-setup.sh      # Full setup script
└── cleanup-all.sh         # Cleanup script
```

## Quick Start
```bash
export ACS_TOKEN="your-acs-token"
./complete-setup.sh
```

## Policies Managed
- **Container Security Best Practices**: No root user, read-only filesystem
- **No Privileged Containers**: Block privileged access

## GitOps Workflow
1. Make changes to policies in `policies/` folder
2. Push to GitHub master branch
3. ArgoCD automatically syncs to Kubernetes
4. Policy sync job pushes changes to ACS Central

## Ansible Automation

Complete automation for ACS Policy GitOps pipeline management.

### Quick Start with Ansible
```bash
# Install dependencies
pip install ansible kubernetes
cd ansible/
ansible-galaxy collection install -r requirements.yml

# Set ACS token and run complete setup
export ACS_TOKEN="your-acs-token"
ansible-playbook setup-gitops-pipeline.yml
```

### Create New Policies
```bash
# Basic policy
ansible-playbook create-new-policy.yml -e policy_name="My Security Policy"

# Advanced policy with custom settings
ansible-playbook create-new-policy.yml \
  -e policy_name="No Root Containers" \
  -e policy_severity="CRITICAL_SEVERITY" \
  -e field_values='["runAsNonRoot=false"]'
```

### Cleanup Everything
```bash
ansible-playbook cleanup-gitops-pipeline.yml -e confirm_cleanup=yes
```

See `ansible/README.md` for detailed documentation.
