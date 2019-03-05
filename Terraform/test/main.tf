# Configure the AWS Provider
provider "aws" {

  region     = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "AzureDevOps-test-vpc"
  cidr = "10.0.0.0/16"

 # azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
 # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
 # public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
 
 # assign_generated_ipv6_cidr_block = true
 
 # enable_nat_gateway = true
 # enable_vpn_gateway = true
  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
    Terraform = "true"
    Environment = "dev"
  }
  vpc_tags = {
    Name = "vpc-name"
  }
}

module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "terraform-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "1.12.0"

  name                   = "my-cluster"
  instance_count         = 1

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

