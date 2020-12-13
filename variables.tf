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



variable "network_addr" {
  default = "10.0.0.0/24"
}

variable "web_subnet_addr" {
  default = cidrsubnet(var.network_addr, 1, 0)
}

variable "other_subnet_addr" {
  default = cidrsubnet(var.network_addr, 1, 1)
}

variable "database_addr" {
  default = cidrhost(var.other_subnet_addr, 1)
}