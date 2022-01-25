# USERS
module "example_admin" {
  source    = "../../infrastructure-modules/iam-user-group"
  user_name = "ExampleAdmin"

  user_groups = [
    aws_iam_group.all_iam_users.name,
    aws_iam_group.security_admins.name,
    aws_iam_group.prod_admins.name,
    aws_iam_group.stage_admins.name,
    aws_iam_group.dev_admins.name,
  ]
}

module "example_developer" {
  source    = "../../infrastructure-modules/iam-user-group"
  user_name = "ExampleDeveloper"

  user_groups = [
    aws_iam_group.all_iam_users.name,
    aws_iam_group.prod_developers.name,
    aws_iam_group.stage_developers.name,
    aws_iam_group.dev_developers.name,
  ]
}

module "example_billing" {
  source    = "../../infrastructure-modules/iam-user-group"
  user_name = "ExampleBilling"

  user_groups = [
    aws_iam_group.all_iam_users.name,
    aws_iam_group.master_billing.name,
  ]
}
