
variable "vpc_cidr_block" {
  type = string
  description = "passing the vpc cidr block"
  default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    description = "enabling dns hostname for vpc"
    default = true
}

variable "enable_dns_support" {
    type = bool
    description = "enabling dns support for vpc"
    default = true
}

variable "component" {
    type = string
    description = "component name for environment"
    default = "sbx"
}

variable "public_subnet_cidr_block" {
  type = list
  description = "passing the public subnet cidr block"
  # For easy editing, choose related numbe rgroups such as odds or evens for list
  default = ["10.0.1.0/24","10.0.3.0/24"] 

}

variable "private_subnet_cidr_block" {
  type = list
  description = "passing the private subnet cidr block"
  default = ["10.0.0.0/24","10.0.2.0/24"] 

}

variable "database_subnet_cidr_block" {
  type = list
  description = "passing the database subnet cidr block"
  default = ["10.0.50.0/24","10.0.51.0/24"] 

}

