variable "region" {
    type = string
    default = "eu-west-2"
    description = "region where the infrastructure would be placed"
}

variable "cidr_block" {
    type = list(string)
    default = ["10.0.0.0/16","10.0.60.0/24","10.0.61.0/24","10.0.62.0/24","10.0.63.0/24","10.0.64.0/24","10.0.65.0/24"]
    description = "vpc and subnet cidr block"
}

variable "key_name" {
    type = string
    default = "null"
    description = "name of key pair"
}