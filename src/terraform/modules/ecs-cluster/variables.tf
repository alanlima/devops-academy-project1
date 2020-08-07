variable "project" {
  description = "define the class id from devops academy"
  type        = string
}

variable "common_tags" {
  description = "define tags which will be applied for every resource created"
  type        = map(string)
  default     = {}
}

variable "image_id" {
  type    = string
  default = "ami-0a7c4f7f17d3eecbc"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "max_size" {
  description = "Maximum number of instances in the cluster"
  type        = number
  default     = 5
}
variable "min_size" {
  description = "Minimum number of instances in the cluster"
  type        = number
  default     = 1
}

variable "vpc_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "key_pair" {
  type    = string
  default = "kp-devops"
}