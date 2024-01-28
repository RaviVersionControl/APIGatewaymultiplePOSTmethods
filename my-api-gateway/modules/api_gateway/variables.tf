variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "post_endpoints" {
  description = "List of POST method endpoints"
  type        = list(string)
}

variable "stage_name" {
  description = "Name of the deployment stage"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}
