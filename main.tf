#Configure provider 
provider "aws" {
  region = var.region

}


#Store state files in remote backend s3
terraform {
  backend "s3" {
    bucket         = "mybucket1811"
    key            = "statefile/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "locktable" #for state locking

  }
}

# create vpc
module "vpc" {
  source = "./module/vpc"

  cidr_block_value = {
    "my_vpc_cidr"    = "10.0.0.0/16"
    "public-subnet"  = "10.0.1.0/24"
    "private-subnet" = "10.0.2.0/24"
    "public-route"   = "0.0.0.0/0"
    "nat-route"      = "0.0.0.0/0"
  }
  vpc_name                = "my_vpc"
  availability_zone_value = "ap-south-1a"
  cidr_blocks_value       = ["0.0.0.0/0"]
  ingress_ports = {
    "ssh" = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    "http" = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress_port = {
    "any_port" = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

module "ec2" {
  source              = "./module/ec2"
  ami_value           = "ami-0f5ee92e2d63afc18"
  instance_type_value = "t2.micro"
  security_group_id   = module.vpc.security_group_id
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  public_ec2_name     = "public_ec2"
  private_ec2_name    = "private_ec2"
}

