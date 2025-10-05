# ACS Policy GitOps Ansible Automation

Ansible playbooks for complete ACS Policy GitOps pipeline management.

## Prerequisites

```bash
# Install Ansible and collections
pip install ansible kubernetes
ansible-galaxy collection install -r requirements.yml

# Set ACS token
export ACS_TOKEN="your-acs-token"
```

## Usage

### 1. Setup Policies Folder
```bash
cd ansible/
ansible-playbook setup-policies-folder.yml
```

### 2. Complete Pipeline Setup
```bash
# Quick setup (recommended)
ansible-playbook setup-gitops-pipeline-quick.yml

# Full setup with validation
ansible-playbook setup-gitops-pipeline.yml
```

### 3. Show ArgoCD Login Details
```bash
ansible-playbook show-argocd-login.yml
```

### 4. Create New Policy
```bash
# Basic policy
ansible-playbook create-new-policy.yml -e policy_name="My Security Policy"

# Advanced policy
ansible-playbook create-new-policy.yml \
  -e policy_name="No Root Containers" \
  -e policy_description="Block containers running as root" \
  -e policy_severity="CRITICAL_SEVERITY" \
  -e field_name="Container Security Context" \
  -e field_values='["runAsNonRoot=false"]'
```

### 5. Cleanup Everything
```bash
ansible-playbook cleanup-gitops-pipeline.yml -e confirm_cleanup=yes
```

## Complete Workflow

```bash
# 1. Setup everything
export ACS_TOKEN="your-token"
ansible-playbook setup-policies-folder.yml
ansible-playbook setup-gitops-pipeline-quick.yml

# 2. Get login details
ansible-playbook show-argocd-login.yml

# 3. Create new policies as needed
ansible-playbook create-new-policy.yml -e policy_name="My Policy"
```

## Policy Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `policy_name` | new-security-policy | Policy display name |
| `policy_description` | Auto-generated | Policy description |
| `policy_severity` | HIGH_SEVERITY | CRITICAL/HIGH/MEDIUM/LOW_SEVERITY |
| `policy_lifecycle` | ["DEPLOY"] | BUILD/DEPLOY/RUNTIME |
| `policy_categories` | ["Security Best Practices"] | Policy categories |
| `field_name` | Container Security Context | Policy field to check |
| `field_values` | ["runAsNonRoot=false"] | Values to match |

## Examples

### Container Security Policy
```bash
ansible-playbook create-new-policy.yml \
  -e policy_name="Container Security Standards" \
  -e policy_description="Enforce container security best practices" \
  -e field_name="Container Security Context" \
  -e field_values='["runAsNonRoot=false","readOnlyRootFilesystem=false"]'
```

### Image Registry Policy  
```bash
ansible-playbook create-new-policy.yml \
  -e policy_name="Approved Registry Only" \
  -e policy_description="Only allow images from approved registries" \
  -e field_name="Image Remote" \
  -e field_values='["registry-1.docker.io/untrusted"]'
```

### Privileged Container Policy
```bash
ansible-playbook create-new-policy.yml \
  -e policy_name="No Privileged Containers" \
  -e policy_description="Block privileged container access" \
  -e policy_severity="CRITICAL_SEVERITY" \
  -e field_name="Privileged Container" \
  -e field_values='["true"]'
```
