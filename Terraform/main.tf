terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "1.12.0"

  name                   = "my-cluster"
  instance_count         = 5

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

variable "list_of_allowed_accounts" {
  type = "list"
  default = ["1111", "2222"]
}

variable "list_of_images" {
  type = "list"
  default = ["alpine", "java", "jenkins"]
}

data "template_file" "ecr_policy_allowed_accounts" {
  count = "${length(var.list_of_allowed_accounts) * length(var.list_of_images)}"

  template = "${file("${path.module}/ecr_policy.tpl")}"

  vars {
    account_id = "${var.list_of_allowed_accounts[count.index / length(var.list_of_images)]}"
    image      = "${var.list_of_images[count.index % length(var.list_of_images)]}"
  }
}

resource "aws_ecr_repository_policy" "repo_policy_allowed_accounts" {
  count = "${data.template_file.ecr_policy_allowed_accounts.count}"

  repository = "${var.list_of_images[count.index % length(var.list_of_images)]}"
  policy = "${data.template_file.ecr_policy_allowed_accounts.*.rendered[count.index]}"
}