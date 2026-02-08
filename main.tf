module "webapp" {
  source = "./modules/webapp"

  vpc_name      = var.vpc_name
  vpc_cidr      = var.vpc_cidr
  subnet_cidr   = var.subnet_cidr

  instance_name = var.instance_name
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  private_ip    = var.private_ip

  ebs_size      = var.ebs_size
}
