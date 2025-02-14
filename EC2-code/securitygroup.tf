resource "aws_security_group" "ec2-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
        cidr_blocks  = ingress.value.cidr_blocks
        from_port    = ingress.value.from_port
        protocol     = ingress.value.protocol
        to_port      = ingress.value.to_port 
    }
  }

  egress {
    
    cidr_blocks    = ["0.0.0.0/0"]
    protocol       = "-1" # semantically equivalent to all ports
    from_port      = 0
    to_port        = 0
  }
}

# resource "aws_vpc_security_group_ingress_rule" "allow_tls22" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }

# resource "aws_vpc_security_group_ingress_rule" "allow_tls80" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }