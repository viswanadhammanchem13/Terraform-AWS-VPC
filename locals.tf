locals {
  common_tags = {
      Project = var.project
      Environment = var.environment
      Terraform = "true"
   }

   ## We are using only 2 availability zones for this VPC, so we are slicing the first 2 availability zones from the list of available availability zones in the region.
   az-names = slice(data.aws_availability_zones.available.names,0,2)
}