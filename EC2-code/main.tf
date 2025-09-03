resource "aws_instance" "a" {
  ami = var.ami // ami id's are region specific so choose according to your region
  instance_type =  var.instance_type
  key_name = var.key_name
  # vpc_security_group_ids = [aws_security_group.allow_tls.id] // all the security group ports will be selected with just adding this
  vpc_security_group_ids = var.security_group
  subnet_id = var.subnet_id
  associate_public_ip_address = var.public_ip
  iam_instance_profile = aws_iam_instance_profile.demo_role_profile.name
    user_data = <<-EOF
    #!/bin/bash
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo dnf upgrade
    sudo yum -y install java-17
    sudo dnf install -y jenkins
    sudo systemctl daemon-reload
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    EOF

  tags = {
    Name = var.tags
    
  }
}