variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment of the instance"
}

variable "project" {
  type    = string
  default = "roboshop"
}

variable "ami_id" {
  type        = string
  default     = "ami-0055977a6e828a4f4"
  description = "AMI id of the instance"

}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "instance type of EC2"
  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium", "t3.large"], var.instance_type)
    error_message = "Instance type must be one of t3.micro, t3.small, or t3.medium."
  }
}

variable "instances" {
  type    = list(any)
  default = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "user", "cart", "shipping", "payment", "frontend"]
}

variable "instance_count" {
  type        = number
  default     = 10
  description = "Number of instances to create"
}

variable "zone_id" {
    type        = string
    default     = "Z0579378K5AL0YOAZ116"
    description = "Route53 zone id"
}

variable "domain_name" {
    type        = string
    default     = "chinna.online"
    description = "Route53 zone name"
}