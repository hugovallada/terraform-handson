variable "public-subnets" {
  description = "list of ips allowed for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.10.0/24"]
}

variable "private-subnets" {
  description = "list of ips allowed for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.11.0/24"]
}

variable "vpc-name" {
  description = "vpc name"
  type = string
  default = "spring-chat"
}