module "vpc" {
  source         = "./modules/vpc"
  vpc-name       = "terraform com modulos"
  vpc_cidr_block = "10.0.0.0/16"
}
