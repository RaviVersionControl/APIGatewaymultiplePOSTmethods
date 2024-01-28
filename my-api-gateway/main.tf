module "my_api_gateway" {
  source       = "./modules/api_gateway"
  api_name     = "MyAPI"
  post_endpoints = [
    "/create-user",
    "/update-profile",
    "/submit-order",
  ]
  stage_name   = "dev"
  aws_region   = "us-east-1"
}
