
remote_state {
  backend = "s3"
  config = {

    bucket         = "put info here"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::${get_env("TG_AWS_ACCT", "${get_aws_account_id()}")}:role/TerragruntAdministrator"
    encrypt        = true
    dynamodb_table = "put info here"
    s3_bucket_tags = {
      owner = "terragrunt"
      name  = "Terraform state storage"
    }
    dynamodb_table_tags = {
      owner = "terragrunt"
      name  = "Terraform lock table"
    }
  }
}

terraform {
  extra_arguments "shared_vars" {
    commands = get_terraform_commands_that_need_vars()
    optional_var_files = [
      "${get_terragrunt_dir()}/${find_in_parent_folders("shared.hcl", "ignore")}"
    ]
  }
}