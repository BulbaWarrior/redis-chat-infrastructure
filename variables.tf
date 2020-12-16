variable "region" {
  default = "us-east-2"
}

variable "amis" {
  type = map(any)

  default = {
    "us-east-2" = "ami-0a91cd140a1fc148a"
  }

}

variable "keys" {
  type = map(any)

  default = {
    "us-east-2" = "MyKey"
  }
}

variable "access_key" {}
variable "secret_key" {}
variable "ssh_key" {}

variable "bacula_database_pass" {
  default = "password"
}



variable "network_addr" {
  default = "10.0.0.0/24"
}

locals {
  web_subnet_addr   = cidrsubnet(var.network_addr, 5, 1)
  other_subnet_addr = cidrsubnet(var.network_addr, 1, 1)
  database_addr     = cidrhost(local.other_subnet_addr, 1)
  loadbalancer_addr = cidrhost(local.other_subnet_addr, 2)
  backup_addr       = cidrhost(local.other_subnet_addr, 3)
  cicd_addr         = cidrhost(local.other_subnet_addr, 4)
}
