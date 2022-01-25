output "master_acct_id" {
  value = data.aws_caller_identity.current.account_id
}

output "account_alias" {
  value = aws_iam_account_alias.alias.account_alias
}

output "security_acct_id" {
  value = aws_organizations_account.security.id
}

output "prod_acct_id" {
  value = aws_organizations_account.prod.id
}

output "stage_acct_id" {
  value = aws_organizations_account.stage.id
}

output "dev_acct_id" {
  value = aws_organizations_account.dev.id
}

output "shared_acct_id" {
  value = aws_organizations_account.shared.id
}

output "crossaccount_assume_from_security_policy_json" {
  value = data.aws_iam_policy_document.crossaccount_assume_from_security.json
}

output "master_billing_role_policy_arn" {
  value = module.assume_role_policy_master_billing.policy_arn
}

output "security_admin_role_policy_arn" {
  value = module.assume_role_policy_security_admin.policy_arn
}

output "prod_admin_role_policy_arn" {
  value = module.assume_role_policy_prod_admin.policy_arn
}

output "stage_admin_role_policy_arn" {
  value = module.assume_role_policy_stage_admin.policy_arn
}

output "dev_admin_role_policy_arn" {
  value = module.assume_role_policy_dev_admin.policy_arn
}

output "shared_admin_role_policy_arn" {
  value = module.assume_role_policy_shared_admin.policy_arn
}

output "terragrunt_admin_role_policy_arn" {
  value = module.assume_role_policy_terragrunt_admin.policy_arn
}

output "terragrunt_reader_role_policy_arn" {
  value = module.assume_role_policy_terragrunt_reader.policy_arn
}


