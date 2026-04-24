
##to get availability zones in the region
data "aws_availability_zones" "available" {
  state = "available"
}
## For Peering Connection gettting default VPC ID
data "aws_vpc" "default" {
  ##We are using the default VPC in the region for peering connection, so we are getting the default VPC ID using data source.
  default = true
}

## For Peering Connection gettting default route table ID
data "aws_route_table" "main" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "association.main"
    values = ["true"]
  }
}



