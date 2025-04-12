// app launch template
resource "aws_launch_template" "app_launch_template" {
  name          = "csye6225-asg-instance"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_app_sg.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      volume_size           = 25
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_kms_key.arn
    }
  }



  user_data = base64encode(<<-EOF
  #!/bin/bash
    sudo apt-get update -y
    sudo snap install aws-cli --classic
    sudo apt-get install -y jq

  echo "DB_HOST=$(echo ${aws_db_instance.csye6225_db.endpoint} | cut -d':' -f1)" > /opt/csye6225/.env
  echo "DB_PORT=${var.db_port}" >> /opt/csye6225/.env
  echo "DB_USERNAME=${aws_db_instance.csye6225_db.username}" >> /opt/csye6225/.env
  echo "SERVER_PORT=${var.app_port}" >> /opt/csye6225/.env
  echo "DB_DATABASE=${aws_db_instance.csye6225_db.db_name}" >> /opt/csye6225/.env
  echo "AWS_S3_BUCKET_NAME=${aws_s3_bucket.app_bucket.bucket}" >> /opt/csye6225/.env
  echo "AWS_REGION=${var.region}" >> /opt/csye6225/.env
  DB_PASSWORD=$(aws secretsmanager get-secret-value --secret-id db-password --query 'SecretString' --output text --region ${var.region} | jq -r '.password')
  echo "DB_PASSWORD=$DB_PASSWORD" >> /opt/csye6225/.env

  # Debug output
  echo "Environment variables:" > /tmp/debug_env.log
  cat /opt/csye6225/.env >> /tmp/debug_env.log

  sudo touch /var/log/webapp.log
  sudo chown csye6225:csye6225 /var/log/webapp.log
  sudo chmod 644 /var/log/webapp.log

  # Start CloudWatch agent
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
  sudo amazon-cloudwatch-agent-ctl -a start
  
  systemctl restart webapp.service
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "csye6225-asg-instance"
    }
  }
}

resource "aws_autoscaling_group" "web_app_asg" {
  name                      = "webapp-asg"
  min_size                  = var.min_size_autosacling_group
  max_size                  = var.max_size_autosacling_group
  desired_capacity          = var.desired_capacity_autosacling_group
  vpc_zone_identifier       = aws_subnet.public_subnet[*].id
  target_group_arns         = [aws_lb_target_group.web_app_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-app-instance"
    propagate_at_launch = true
  }

  # Cooldown period
  default_cooldown = 60
}


resource "aws_autoscaling_policy" "scale_up" {
  name                   = "cpu-high"
  scaling_adjustment     = var.no_of_instnaces_scaling_up
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown_period_of_an_instnaces
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}


resource "aws_autoscaling_policy" "scale_down" {
  name                   = "cpu-low"
  scaling_adjustment     = var.no_of_instnaces_scaling_down
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown_period_of_an_instnaces
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
}


resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-util-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.high_threshold
  alarm_description   = " Scale Up when CPU usage is more then Threshold"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }
}


resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-util-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.low_threshold
  alarm_description   = " Scale down when CPU usage is below"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_app_asg.name
  }
}
