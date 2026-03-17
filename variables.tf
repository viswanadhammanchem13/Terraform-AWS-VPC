variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "project" {
    type=string
    default = "roboshop"
}

variable "environment" {
    type=string
    default = "dev"
}

variable "public_subnet_cidrs" {
    type = list(string)
  
}

