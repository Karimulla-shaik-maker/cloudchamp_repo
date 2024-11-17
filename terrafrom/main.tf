
provider "aws" {
region = "us-east-1"
profile = "acloud"
}


variable "vpc_id" {
  type = string
  description = "value to use for VPC ID"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICC7N1vZoJadu18zXn9XQU2Cw230xHEz7xS++oBg22A0 karim@MacBookPro"
}

resource "aws_default_security_group" "default" {
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 9000
    to_port   = 9000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }  

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "ec2_instance" {
    source = "../../../../terraform-practice/modules/ec2-create-instance"
    ami_value = "ami-005fc0f236362e99f"
    instance_type = "t2.micro"
    security-group = [aws_default_security_group.default.id]
    key-pair = aws_key_pair.deployer.key_name
    tag = "jenkins-server"
}


output "instance_publicIP" {
    value = "${module.ec2_instance.public-ip-address}"
}

#module "ec2_instance" {
#    source = "../../../../terraform-practice/modules/ec2-create-instance"
#    ami_value = "ami-005fc0f236362e99f"
#    instance_type = "t2.micro"
#    security-group = [aws_default_security_group.default.id]
#    key-pair = aws_key_pair.deployer.key_name
#    tag = "jenkins-server"
#}


#output "instance_publicIP" {
#    value = "${module.ec2_instance.public-ip-address}"
#}
