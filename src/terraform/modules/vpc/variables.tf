variable "vpc_cidr" {
  description = "define the vpc cidr_block"
  type        = string
}

variable "availability_zones" {
  description = "the list of availability_zones for the subnets"
  type        = list(string)
}

variable "project" {
  description = "define the class id from devops academy"
  type        = string
}

variable "common_tags" {
  description = "define tags which will be applied for every resource created"
  type        = map(string)
  default     = {}
}

variable "deploy_nat" {
  type = bool
}