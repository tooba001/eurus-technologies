
locals {
  db_ingress_rules = {
    mysql = {
      description    = "Allow mysql"
      from_port      = 3306
      to_port        = 3306
      protocol       = "tcp"
      cidr_blocks    = [] 
      security_groups = [module.websecuritygroups.webserver_securitygroup_id]
    }
  }
}

locals {
  lb_ingress_rules = {
    http = {
      description = "Allow HTTP traffic"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = lookup(var.lb_ingress_rules.http, "cidr_blocks", ["0.0.0.0/0"])
    }
  }

  lb_egress_rules = {
    http_egress = {
      description = "Allow HTTP egress traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks =   ["0.0.0.0/0"]
    }
    # Add more egress rules as needed
  }
}

locals {
  web_ingress_rules = {
    http = {
      description     = "Allow HTTP traffic"
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = [] 
      security_groups = [module.securitygroups.lb_securitygroup_id]
    }
    ssh = {
      description     = "Allow SSH traffic"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = [] 
    }
  }
}



