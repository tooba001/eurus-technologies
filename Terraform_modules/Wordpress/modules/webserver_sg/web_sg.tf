

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web servers"

  vpc_id = var.vpc_id

dynamic "ingress" {
    for_each = var.web_ingress_rules


    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }

}

