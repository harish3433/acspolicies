# ACS Policy GitOps

Automated ACS security policy management using ArgoCD and GitOps workflow.

## Repository Structure
```
├── ansible/                # Ansible automation scripts
├── argocd/                 # ArgoCD applications
├── policies/               # ACS security policies
│   ├── docker-policy.yml
│   ├── policy-sync-job.yml
│   └── kustomization.yml
├── precheck/              # Policy validation
└── cleanup-all.sh         # Cleanup script
```

## Quick Start with Ansible (Recommended)
```bash
# Install dependencies
pip install ansible kubernetes
cd ansible/
ansible-galaxy collection install -r requirements.yml

# Complete setup in one command
export ACS_TOKEN="your-acs-token"
ansible-playbook setup-complete-gitops.yml
```

## Manual Setup (Alternative)
```bash
export ACS_TOKEN="your-acs-token"
./complete-setup.sh
```

## Policies Managed
- **Docker Registry Policy**: Block specific registry images

## GitOps Workflow
1. Edit policies in `policies/` folder
2. Push to GitHub master branch
3. ArgoCD automatically syncs within 3 minutes
4. Policies appear in ACS Central

## Ansible Scripts
- `setup-complete-gitops.yml` - Complete pipeline setup
- `create-new-policy.yml` - Create new policies
- `show-argocd-login.yml` - Show ArgoCD UI details
- `cleanup-gitops-pipeline.yml` - Full cleanup

See `ansible/README.md` for detailed documentation.
