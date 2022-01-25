terraform {
  backend "local" {}
}

data "terraform_remote_state" "organization" {
  backend = "s3"

  config = {
    bucket   = var.terraform_state_bucket
    key      = "master/organization/terraform.tfstate"
    region   = var.terraform_state_bucket_region
    role_arn = "arn:aws:iam::${var.security_acct_id}:role/TerragruntReader"
  }
}

provider "aws" {
  alias = "assume_security"

  assume_role {
    role_arn = "arn:aws:iam::${data.terraform_remote_state.organization.outputs.security_acct_id}:role/OrganizationAccountAccessRole"
  }

  region = var.aws_default_region
}

provider "aws" {
  alias = "assume_prod"


  assume_role {
    role_arn = "arn:aws:iam::${data.terraform_remote_state.organization.outputs.prod_acct_id}:role/OrganizationAccountAccessRole"
  }

  region = var.aws_default_region
}

provider "aws" {
  alias = "assume_stage"

  assume_role {
    role_arn = "arn:aws:iam::${data.terraform_remote_state.organization.outputs.stage_acct_id}:role/OrganizationAccountAccessRole"
  }

  region = var.aws_default_region
}

provider "aws" {
  alias = "assume_dev"

  assume_role {
    role_arn = "arn:aws:iam::${data.terraform_remote_state.organization.outputs.dev_acct_id}:role/OrganizationAccountAccessRole"
  }

  region = var.aws_default_region
}

provider "aws" {
  alias = "assume_shared"

  assume_role {
    role_arn = "arn:aws:iam::${data.terraform_remote_state.organization.outputs.shared_acct_id}:role/OrganizationAccountAccessRole"
  }

  region = var.aws_default_region
}

resource "aws_iam_user" "temp_admin" {
  name          = "temp-admin"
  force_destroy = true
  provider      = aws.assume_security
}

resource "aws_iam_user_policy_attachment" "assume_role_security_admin" {
  user       = aws_iam_user.temp_admin.name
  policy_arn = data.terraform_remote_state.organization.outputs.security_admin_role_policy_arn
  provider   = aws.assume_security
}

resource "aws_iam_user_policy_attachment" "assume_role_prod_admin" {
  user       = aws_iam_user.temp_admin.name
  policy_arn = data.terraform_remote_state.organization.outputs.prod_admin_role_policy_arn
  provider   = aws.assume_security
}

resource "aws_iam_user_policy_attachment" "assume_role_stage_admin" {
  user       = aws_iam_user.temp_admin.name
  policy_arn = data.terraform_remote_state.organization.outputs.stage_admin_role_policy_arn
  provider   = aws.assume_security
}

resource "aws_iam_user_policy_attachment" "assume_role_dev_admin" {
  user       = aws_iam_user.temp_admin.name
  policy_arn = data.terraform_remote_state.organization.outputs.dev_admin_role_policy_arn
  provider   = aws.assume_security
}

resource "aws_iam_user_policy_attachment" "assume_role_shared_admin" {
  user       = aws_iam_user.temp_admin.name
  policy_arn = data.terraform_remote_state.organization.outputs.shared_admin_role_policy_arn
  provider   = aws.assume_security
}


resource "aws_iam_user_policy_attachment" "assume_role_terragrunt_admin" {
  user       = aws_iam_user.temp_admin.name
  policy_arn = data.terraform_remote_state.organization.outputs.terragrunt_admin_role_policy_arn
  provider   = aws.assume_security
}

resource "aws_iam_user_policy_attachment" "assume_role_terragrunt_reader" {
  user       = aws_iam_user.temp_admin.name
  policy_arn = data.terraform_remote_state.organization.outputs.terragrunt_reader_role_policy_arn
  provider   = aws.assume_security
}

resource "aws_iam_access_key" "temp_admin" {
  user     = aws_iam_user.temp_admin.name
  pgp_key  = "keybase:${var.keybase}"
  provider = aws.assume_security
}
