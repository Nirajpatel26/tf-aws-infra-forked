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

# variable "db_password" {
#   description = "password of db"
#   type        = string
# }

variable "min_size_autosacling_group" {
  description = "min isntances for web application"
  type        = number
  default     = 3
}

variable "max_size_autosacling_group" {
  description = "max isntances for web application"
  type        = number
  default     = 5
}

variable "desired_capacity_autosacling_group" {
  description = "max isntances for web application"
  type        = number
  default     = 3
}

variable "health_check_grace_period" {
  description = "max isntances for web application"
  type        = number
  default     = 180
}

variable "no_of_instnaces_scaling_up" {
  description = "no of isntances to scale up"
  type        = number
  default     = 1
}

variable "cooldown_period_of_an_instnaces" {
  description = "cooldown_period_of_an_instnaces in sec"
  type        = number
  default     = 60
}

variable "no_of_instnaces_scaling_down" {
  description = "no of isntances to scale up"
  type        = number
  default     = -1
}

variable "evaluation_periods" {
  description = "evaluation periods"
  type        = number
  default     = 2
}

variable "high_threshold" {
  description = "high threshold"
  type        = number
  default     = 5
}

variable "low_threshold" {
  description = "low threshold"
  type        = number
  default     = 3
}

variable "domain_name" {
  description = "domain_name"
  type        = string
}

variable "alias_ebs_key" {
  description = "Alias for EC2 EBS KMS key"
  default     = "csye6225-ebs-key"
}

variable "alias_rds_key" {
  description = "Alias for RDS KMS key"
  default     = "csye6225-rds-key"
}

variable "alias_s3_key" {
  description = "Alias for S3 KMS key"
  default     = "csye6225-s3-key"
}

variable "alias_secret_manager_key" {
  description = "Alias for Secrets Manager KMS key"
  default     = "csye6225-secrets-key"
}

variable "CertificateArn" {
  description = "SSL CertificateArn"
}


variable "dev_ssl_cert_arn" {
  description = "dev SSL CertificateArn"
}