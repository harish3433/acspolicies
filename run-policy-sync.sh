#!/bin/bash

ENV=${1:-dev}
ACS_TOKEN=${ACS_TOKEN:-$(oc get secret central-htpasswd -n stackrox -o jsonpath='{.data.password}' | base64 -d)}

# Test policies first
ansible-playbook -i inventory.ini policy-test.yml -e "environment=$ENV" -e "acs_token=$ACS_TOKEN"

if [ $? -eq 0 ]; then
    # Apply policies
    ansible-playbook -i inventory.ini acs-policy-gitops.yml -e "environment=$ENV" -e "acs_token=$ACS_TOKEN"
else
    echo "Policy tests failed. Deployment aborted."
    exit 1
fi
