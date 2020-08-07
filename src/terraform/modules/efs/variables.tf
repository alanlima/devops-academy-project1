variable "project" {
  description = "define the class id from devops academy"
  type        = string
}

variable "common_tags" {
  description = "define tags which will be applied for every resource created"
  type        = map(string)
  default     = {}
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}