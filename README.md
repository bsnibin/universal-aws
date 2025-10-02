# universal-aws

**Multi-account AWS Terraform Pipeline Orchestrator**

This repo contains:
- The GitHub Actions workflow for your multi-account Terraform pipeline
- Scripts for assuming roles and running Terraform in each account

## Structure

- `.github/workflows/terraform-multi-account.yml`: Main pipeline workflow
- `scripts/assume_and_apply.sh`: Helper script for role assumption and Terraform plan/apply

## How it works

- The pipeline reads the `aws-map` repo to determine which accounts and roles to target.
- For each account, it assumes the specified role and applies the baseline/platform modules using account-specific tfvars.
- Remote state is centralized in the `core-shared-services` account via S3 and DynamoDB.

## Prerequisites

- All secrets for the `terraform-svc` role must be set in GitHub Secrets.
- All referenced repos (`aws-landing-zone`, `aws-accounts-baseline`, `aws-map`) must also be present under your GitHub account.
