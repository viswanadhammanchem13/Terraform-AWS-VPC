variable "cidr_block" {
  type = string
}

variable "project" {
    type=string
}

variable "environment" {
    type=string
   }

variable "public_subnet_cidrs" {
    type = list(string)
  
}

variable "private_subnet_cidrs" {
    type = list(string)
  
}

variable "database_subnet_cidrs" {
    type = list(string)
  
}

variable "vpc_tags" {
    type = map(string)
    default = {}
  
}
variable "igw_tags" {
    type = map(string)
    default = {}
  
}

variable "Public_subnet_tags" {
    type = map(string)
    default = {}
  
}

variable "private_subnet_tags" {
    type = map(string)
    default = {}
  
}

variable "database_subnet_tags" {
    type = map(string)
    default = {}
  
}

variable "eip_gateway_tags" {
    type = map(string)
    default = {}
  
}

variable "nat_gateway_tags" {
    type = map(string)
    default = {}
  
}

variable "Public_route_table" {
    type = map(string)
    default = {}
  
}
variable "private_route_table" {
    type = map(string)
    default = {}
  
}

variable "database_route_table" {
    type = map(string)
    default = {}
  
}



