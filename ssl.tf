data "aws_acm_certificate" "demo_imported_cert" {
  domain      = var.domain_name
  most_recent = true
  statuses    = ["ISSUED"]
}


resource "aws_lb_listener" "demo_https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.CertificateArn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }
}

