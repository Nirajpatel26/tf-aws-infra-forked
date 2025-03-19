resource "aws_instance" "web_app_instance" {
  ami           = var.ami
  instance_type = var.instance_type # Or any instance type suitable for your app
  key_name      = var.key_pair_name
  # Attach the security group you created above
  vpc_security_group_ids = [aws_security_group.web_app_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  # Make sure the EBS volume is terminated when the instance is terminated
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }
  depends_on = [aws_db_instance.csye6225_db]

  # Disable accidental termination protection
  disable_api_termination = false


  subnet_id = aws_subnet.public_subnet[0].id


  user_data = (<<-EOF
  #!/bin/bash
  echo "DB_HOST=$(echo ${aws_db_instance.csye6225_db.endpoint} | cut -d':' -f1)" > /opt/csye6225/.env
  echo "DB_PORT=${var.db_port}" >> /opt/csye6225/.env
  echo "DB_USERNAME=${aws_db_instance.csye6225_db.username}" >> /opt/csye6225/.env
  echo "DB_PASSWORD=${var.db_password}" >> /opt/csye6225/.env
  echo "SERVER_PORT=${var.app_port}" >> /opt/csye6225/.env
  echo "DB_DATABASE=${aws_db_instance.csye6225_db.db_name}" >> /opt/csye6225/.env
  echo "AWS_S3_BUCKET_NAME=${aws_s3_bucket.app_bucket.bucket}" >> /opt/csye6225/.env
  echo "AWS_REGION=${var.region}" >> /opt/csye6225/.env

  # Debug output
  echo "Environment variables:" > /tmp/debug_env.log
  cat /opt/csye6225/.env >> /tmp/debug_env.log

  systemctl restart webapp.service
  EOF
  )



  tags = {
    Name = "${var.project_name}-a05"
  }
}