resource "aws_instance" "web_app_instance" {
  ami           = var.ami           # Your custom AMI ID
  instance_type = var.instance_type # Or any instance type suitable for your app

  # Attach the security group you created above
  vpc_security_group_ids = [aws_security_group.app_security_group.id]

  # Make sure the EBS volume is terminated when the instance is terminated
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # Disable accidental termination protection
  disable_api_termination = false

  # Ensure the EC2 instance is created within the custom VPC and subnet
  subnet_id = aws_subnet.public_subnet[0].id # Make sure this is a public subnet if you want to access it from the internet
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