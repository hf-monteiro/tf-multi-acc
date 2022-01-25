output "account_alias" {
  value = aws_iam_account_alias.alias.account_alias
}



## AWS Transti Gateway
output "transit_gateway_arn" {
  value       = module.transit_gateway.transit_gateway_arn
  description = "Transit Gateway ARN"
}

output "transit_gateway_id" {
  value       = module.transit_gateway.transit_gateway_id
  description = "Transit Gateway ID"
}

output "transit_gateway_route_table_id" {
  value       = module.transit_gateway.transit_gateway_route_table_id
  description = "Transit Gateway route table ID"
}