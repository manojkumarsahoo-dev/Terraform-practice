module "network" {
  source      = "./modules/network"
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.0.0/24"
}

module "compute" {
  source        = "./modules/compute"
  ami           = "ami-04b938437b69a2c9c"
  instance_type = "t2.micro"
  subnet_id     = module.network.subnet_id
}