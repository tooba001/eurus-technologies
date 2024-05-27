
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow inbound traffic on ports 80 "
  vpc_id      =  var.vpc_id

  dynamic "ingress" {
    for_each = var.lb_ingress_rules


    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

 dynamic "egress" {
    for_each = var.lb_egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}


resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow inbound traffic from EC2"
  vpc_id      =  var.vpc_id

  dynamic "ingress" {
    for_each = var.db_ingress_rules


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




