variable "ami_id" {
  description = "The ID of the AMI to use for the instances"
  type        = string
  default     = "ami-02457590d33d576c3"
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"
}

variable "security_group_id" {
  description = "The ID of the security group to use"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "elb_id" {
  description = "The ID of the load balancer"
  type        = string
}

variable "desired_capacity" {
  description = "The desired number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of instances"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of instances"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
} 