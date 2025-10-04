# ACS Policy GitOps

Automated ACS security policy management using ArgoCD and GitOps workflow.

## Repository Structure
```
├── argocd/                 # ArgoCD applications
├── policies/               # ACS security policies
│   ├── dev/               # Development policies
│   └── prod/              # Production policies (stricter)
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
- **30-Day Scan Age**: Image scan freshness
- **No Privileged Containers**: Block privileged access
- **No Latest Image Tags**: Enforce specific tags
