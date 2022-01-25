variable "terraform_state_bucket" {
    default = ""
}

variable "terraform_state_bucket_region" {
    default = ""
}

variable "aws_default_region" {
    default = ""
}

variable "org_name" {
    default = ""
}

variable "developer_role_name" {
    default = "Developer"
}

variable "developer_default_arn" {
    default = "arn:aws:iam::aws:policy/PowerUserAccess"
}
