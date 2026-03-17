data "aws_availability_zones" "available" {
  state = "available"
}


##TO CHECK THE AVAILABILITY ZONES IN THE REGION
# output "azs_info" {
#   value = data.aws_availability_zones.available
# }