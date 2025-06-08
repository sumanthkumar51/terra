variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "20.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "20.0.1.0/24"
}

variable "public_subnet_cidr2" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "20.0.2.0/24"
}

variable "az1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
} 