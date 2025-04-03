resource "aws_security_group" "web_app_sg" {
  name   = "app-security-group"
  vpc_id = aws_vpc.csye6225_vpc.id # Ensure this is the VPC you created with Terraform

  # Ingress rules for allowing incoming traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from load balancer
  }

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere
  # }

  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS access from anywhere
  # }
  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  # Egress rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}



resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.csye6225_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_app_sg.id]
  }



  tags = {
    Name = "${var.project_name}-database-sg"
  }
}



resource "aws_security_group" "load_balancer_sg" {
  name   = "load-balancer-group"
  vpc_id = aws_vpc.csye6225_vpc.id



  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-load-balancer-sg"
  }
}