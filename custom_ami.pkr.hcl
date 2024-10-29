packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"  # Correct source for the AWS plugin
    }
  }
}

# Creatina AMI 
source "amazon-ebs" "example" {
  region                 = "us-west-1"
  source_ami             = "ami-0da424eb883458071"
  instance_type          = "t2.micro"
  ssh_username           = "ubuntu"
  ami_name               = "custom-ami-{{timestamp}}"
  vpc_id                 = "vpc-00b36eddebde14388"
  subnet_id              = "subnet-06fa13195037bf7e8"
  security_group_id      = "sg-054e8ebccc42e816e"
  associate_public_ip_address = true

}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
    ]
  }
}

