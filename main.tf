module "ec2" {
  source = "./ec2"
  ##### variable declared in ec2 folder variable.tf file
  public_security_group = local.security_groups
  public_subnet = module.network.public_subnet
}
module "network" {
  source = "./network"
  vpc_cidr = local.vpc_cidr
  security_groups = local.security_groups
}