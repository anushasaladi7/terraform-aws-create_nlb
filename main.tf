##Creating Network load balancer

resource "aws_lb" "nlb" {
  internal                   = false
  load_balancer_type         = "network"
  enable_deletion_protection = false
  subnets                    = var.subnets
  tags = {
    NAME = var.name
  }
}

##Creating Target group and listener for port 8080 and protocol as TCP

resource "aws_lb_target_group" "nlb-tg" {
  target_type = "instance"
  name = "anu-nlb-tg"
  port        = var.port
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.vpc.id
  tags = {
    Name = var.name
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8080
  protocol          = "TCP" #aws_lb_target_group.nlb.tg.protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}

