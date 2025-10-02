#!/bin/bash
set -e

ACCOUNT=$1
ACCOUNT_ID=$2
ASSUME_ROLE_ARN=$3
TFVARS_PATH=$4
MODULE_PATH=$5

# Assume role
CREDS=$(aws sts assume-role \
  --role-arn "$ASSUME_ROLE_ARN" \
  --role-session-name "TerraformPipeline" \
  --output json)

export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r .Credentials.SessionToken)

cd $MODULE_PATH

terraform init -backend-config="key=envs/${ACCOUNT}/baseline/terraform.tfstate" \
               -backend-config="bucket=terraform-remote-state-bucket" \
               -backend-config="dynamodb_table=terraform-lock-table" \
               -backend-config="region=us-east-1"

terraform plan -var-file="$TFVARS_PATH"
terraform apply -auto-approve -var-file="$TFVARS_PATH"
