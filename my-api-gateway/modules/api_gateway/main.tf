provider "aws" {
  region = var.aws_region
}

resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "API Gateway for ${var.api_name}"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "your_resource_path"
}

resource "aws_api_gateway_method" "post_methods" {
  count              = length(var.post_endpoints)
  rest_api_id        = aws_api_gateway_rest_api.api.id
  resource_id        = aws_api_gateway_resource.resource.id
  http_method        = "POST"
  authorization_type = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  count              = length(var.post_endpoints)
  rest_api_id        = aws_api_gateway_rest_api.api.id
  resource_id        = aws_api_gateway_resource.resource.id
  http_method        = aws_api_gateway_method.post_methods[count.index].http_method
  integration_http_method = "POST"
  type               = "HTTP"
  uri                = "your_backend_uri"
}

resource "aws_api_gateway_method_response" "response" {
  count       = length(var.post_endpoints)
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.post_methods[count.index].http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "integration_response" {
  count       = length(var.post_endpoints)
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.post_methods[count.index].http_method
  status_code = aws_api_gateway_method_response.response[count.index].status_code
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_method.post_methods, aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name
}
