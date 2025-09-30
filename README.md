# ACS Policy GitOps

## Repository Structure
```
policies/
├── dev/                    # Development environment policies
│   ├── 30-day-scan-age.yml
│   └── policy-states.yml
└── prod/                   # Production environment policies
    ├── 30-day-scan-age.yml
    └── policy-states.yml
```

## Usage
1. Add policies as YAML files in environment directories
2. Update policy-states.yml to enable/disable policies
3. Push to trigger automated deployment

## GitHub Secrets Required
- `ACS_TOKEN`: ACS Central API token
