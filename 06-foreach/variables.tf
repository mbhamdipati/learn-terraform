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
  type = map(any)
  default = {
    "mongodb" = {
      instance_type = "t3.micro"
      port_number   = 27017
    },
    "redis" = {
      instance_type = "t3.micro"
      port_number   = 6379
    },
    "mysql" = {
      "instance_type" = "t3.small"
      port_number     = 3306
    },
    "rabbitmq" = {
      "instance_type" = "t3.micro"
      port_number     = 5672
    },
    "catalogue" = {
      "instance_type" = "t3.micro"
      port_number     = 8080
    },
    "user" = {
      "instance_type" = "t3.micro"
      port_number     = 8080
    },
    "cart" = {
      "instance_type" = "t3.micro"
      port_number     = 8080
    },
    "shipping" = {
      "instance_type" = "t3.micro"
      port_number     = 8080
    },
    "payment" = {
      "instance_type" = "t3.micro"
      port_number     = 8080
    },
    "frontend" = {
      "instance_type" = "t3.micro"
      port_number     = 80
    }
  }
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
