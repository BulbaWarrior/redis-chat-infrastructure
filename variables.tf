variable "region" {
  default = "us-east-2"
}

variable "amis" {
  type = map
  
  default = {
    "us-east-2" = "ami-0a91cd140a1fc148a"
  }
  
}

variable "keys" {
  type = map

  default = {
    "us-east-2" = "MyKey"
  }
}

variable "network_addr" {
  default = "10.0.0.0/24"
}

variable "database_addr" {
  default = "10.0.0.100"
}
