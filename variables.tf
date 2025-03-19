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
  type        = list(string)
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


variable "ami" {
  description = "machine image number"
  type        = string
}

variable "instance_type" {
  description = "type of instance in ec2"
  type        = string
}

variable "volume_size" {
  description = "EBS volume size"
  type        = number
}

variable "key_pair_name" {
  description = "SSH key for EC2"
  type        = string
}

variable "app_port" {
  description = "value of port of webapp"
  type        = number
  default     = 3000
}

variable "project_name" {
  description = "name of the project"
  type        = string
}


variable "db_port" {
  type    = number
  default = 5432
}

variable "db_password" {
  description = "password of db"
  type        = string
}



