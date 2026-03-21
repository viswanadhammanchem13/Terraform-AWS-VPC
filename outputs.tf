output "vpc_id" {
    value = aws_vpc.main.id
  
}

output "public_subnet_ids" {
    value = aws_subnet.public[*].ids
  
}

# output "private_subnet_ids" {
#     value = aws_vpc.private_subnets[*].id
  
# }

# output "database_subnet_ids" {
#     value = aws_vpc.database_subnets[*].id
  
# }