# must match the terragrunt.remote_state.config in terraform.tfvars
terraform_state_bucket          = "put info here!"
terraform_state_bucket_region   = "us-east-1"
terraform_state_dynamodb_table  = "put info here!"
cloudtrail_bucket_name          = "put info here!"

aws_default_region         = "us-east-1"
org_name                   = "put info here!"

security_acct_email        = "security@aaa.com"
prod_acct_email            = "prod@aaa.com"
stage_acct_email           = "stage@aaa.com"
dev_acct_email             = "dev@aaa.com"
shared_acct_email          = "shared@aaa.com"

administrator_default_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
developer_default_arn     = "arn:aws:iam::aws:policy/PowerUserAccess"
billing_default_arn       = "arn:aws:iam::aws:policy/job-function/Billing"
developer_role_name       = "Developer"
