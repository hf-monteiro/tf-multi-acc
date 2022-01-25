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

/*## VPC ##

variable "cidr_vpc" {
    default = "10.1.0.0/16"
}

variable "az" {
    default = "us-east-1c"
}

variable "cidr_sub" {
    default = "10.1.1.0/24"
}

variable "instance_tenancy" {
    default = "default"
}

#variable "vpc_id" {
#    type = string 
#}*/