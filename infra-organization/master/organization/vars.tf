variable "terraform_init_user_name" {
  default = "terraform-init"
}

variable "administrator_default_arn" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}

variable "billing_default_arn" {
  default = "arn:aws:iam::aws:policy/job-function/Billing"
}

variable "aws_default_region" {
    default = "us-east-1"
}

variable "org_name" {
    default = "mp-teste5-kxc"
}

variable "terraform_state_bucket" {
    default = "mp-teste5-kxc"
}
variable "terraform_state_dynamodb_table" {
    default = "mp-teste5-kxc"
}

variable "security_acct_email" {
    default = "security_acct4@kxc.com.br"
}

variable "prod_acct_email" {
    default = "prod_acct4@kxc.com.br"
}

variable "stage_acct_email" {
    default = "stage_acct4@kxc.com.br"
}

variable "dev_acct_email" {
    default = "dev_acct4@kxc.com.br"
}

variable "shared_acct_email" {
    default = "shared_acct5@kxc.com.br"
}

