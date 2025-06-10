provider "google" {
    project = var.project_id
    region  = var.region
  
}

module "vpc" {
    source = "git::https://github.com/roopla/terraform-gcp-modules.git//vpc?ref=v1.0.0"
    #source = "git@github.com:roopla/terraform-gcp-modules.git//vpc?ref=v1.0.0"
    vpc_name = var.vpc_name
    
     
     }
module "subnet" {
    source = "git::https://github.com/roopla/terraform-gcp-modules.git//subnet?ref=v1.0.0"
    subnet_name = var.subnet_name
    # Ensure the subnet is created in the same region as the VPC
    region = var.region
    vpc_id = module.vpc.vpc_id
    subnet_cidr = var.subnet_cidr
}


module "gce" {
    source = "git::https://github.com/roopla/terraform-gcp-modules.git//gce?ref=v1.0.0"
    vm_name = var.vm_name
    machine_type = var.machine_type
    zone = var.zone
    subnet_id = module.subnet.subnet_id
}