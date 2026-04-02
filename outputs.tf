#TO CHECK THE AVAILABILITY ZONES IN THE REGION

output "azs_info" {
  value = data.aws_availability_zones.available
}

output "vpc_id" {
    value = aws_vpc.main.id
  
}

output "public_subnet_ids" {
    ## We are using splat expression to get the IDs of all the public subnets and storing them in a list.
    value = aws_subnet.public[*].id  
}

output "private_subnet_ids" {
    ## We are using splat expression to get the IDs of all the private subnets and storing them in a list.
    value = aws_subnet.private[*].id
  
}

output "database_subnet_ids" {
    ##We are using splat expression to get the IDs of all the database subnets and storing them in a list.
    value = aws_subnet.database[*].id
  
}