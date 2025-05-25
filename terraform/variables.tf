variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "portfolio-api"
}

variable "container_port" {
  description = "Port exposed by the docker image"
  type        = number
  default     = 8080
}

variable "cpu" {
  description = "Fargate instance CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate instance memory"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of containers to run"
  type        = number
  default     = 1
}

variable "domain_name" {
  description = "Domain name for the API"
  type        = string
  default     = "api.dobsond.dev"
}