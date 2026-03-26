data "aws_availability_zones" "available" {
  state = "available"
}
## For Peering Connection gettting default VPC ID
data "aws_vpc" "default" {
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



