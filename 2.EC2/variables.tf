variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources are going to create choose"
  #replace the region as suits for your requirement
}

variable "aws_vpc_cidr" {
  default = "10.181.242.0/24"
}

variable "az_count" {
  default     = "1"
  description = "number of availability zones in above region"
}

variable "azs" {
    type = list
    default = ["1a"]
}

variable "health_check_path" {
  default = "/"
}