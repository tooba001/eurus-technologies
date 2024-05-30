
resource "aws_security_group" "shared_security_group" {
  name        = var.security_group_name 
  description = "Allow  traffic "
  vpc_id      =  var.vpc_id


  dynamic "ingress" {
    for_each = var.ingress_rules


    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      security_groups =  lookup(ingress.value, "security_groups", null)
    }
  }

 dynamic "egress" {
    for_each =  var.egress_rules

    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks =  lookup(egress.value, "cidr_blocks", null)
      security_groups = lookup(egress.value, "security_groups", null)
    }
  }
}





