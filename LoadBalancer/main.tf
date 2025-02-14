resource "aws_lb" "test" {
  name               = var.lb_tag
  internal           = var.lb_scheme
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  tags = {
    Environment = "production"
  }
}

# Target Group for LoadBalancer
resource "aws_lb_target_group" "alb_tg" {
  name        = var.tg_name
  target_type = var.target_type
  port        = var.tg_port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
}

# Creating Listner and attaching it to the Target Group and LB
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
   port              = var.lb_listener_port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# Attaching the target group to the load balancer
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = var.target
  port             = var.lb_target_port
}