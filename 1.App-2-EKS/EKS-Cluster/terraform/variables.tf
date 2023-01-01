variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources are going to create choose"
  #replace the region as suits for your requirement
}

variable "aws_vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "az_count" {
  default     = "2"
  description = "number of availability zones in above region"
}

variable "azs" {
    type = list
    default = ["1a", "1b"]
}

variable "app_port" {
  default     = "443"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}

variable "health_check_path" {
  default = "/"
}

#Nodes Properties
variable "ami_type" {
  default = "AL2_x86_64"
}

variable "capacity_type" {
  default = "SPOT"
}

variable "disk_size" {
  default = 8
}

variable "instance_types" {
  default = "t3.small"
}
#End nodes Properties

#Autoscaling
variable "desired_size" {
  default = 2
}

variable "max_size" {
  default = 10
}

variable "min_size" {
  default = 2
}

variable "repo-name" {
  default     = "guestbook-go"
  description = "ECR repo name"
}