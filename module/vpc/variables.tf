variable "vpc_name" { 
 }

variable "availability_zone_value" {
  description = "Value for the avaliability zone"
  default     = "ap-south-1a"
}


variable "cidr_block_value" {
  type = map(any)
  default = {
    "my_vpc_cidr"    = "10.0.0.0/16"
    "public-subnet"  = "10.0.1.0/24"
    "private-subnet" = "10.0.2.0/24"
    "public-route"   = "0.0.0.0/0"
    "nat-route"      = "0.0.0.0/0"
  }
}

variable "cidr_blocks_value" {
  description = "Value of CIDR block for subnets "
  default     = ["0.0.0.0/0"]
}

variable "ingress_ports" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    "ssh" = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    "http" = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }


  }
}

variable "egress_port" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
       "any_port"={ 
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
       }
    
  }
}