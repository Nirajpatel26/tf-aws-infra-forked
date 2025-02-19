variable "profile" {
  description = "profile of aws dev/demo"
  type        = string
}


variable "region" {
  description = "region to deploy the resources in"
  type        = string
}

variable "cidr_block" {
  description = "cidr_block for vpc"
  type        = string
}

variable "vpc_name" {
  description = "tag name of vpc"
  type        = string
}

variable "public_subnet_count" {
  description = "number of subnet"
  type        = string
}

variable "public_cidrs" {
  description = "value of public cidrs"
  type = list(string)
}

variable "private_subnet_count" {
  description = "number of subnet"
  type        = string
}

variable "private_cidrs" {
  description = "value of private cidrs"
  type        = list(string)
}

variable "public_route_cidr" {
  description = "value of private cidrs"
  type        = string
}

data "aws_availability_zones" "available" {
  state = "available"
}