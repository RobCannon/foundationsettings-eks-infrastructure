variable "app" {
  default = "foundationsettings"
}

variable "image_version" {
  default = "1.0.190430.1"
}

variable "container_registry" {
  default = "687928977810.dkr.ecr.us-east-1.amazonaws.com"
}

variable "region" {
  default = "us-east-1"
}

# Whether the application is available on the public internet,
# also will determine which subnets will be used (public or private)
variable "internal" {
  default = "true"
}

variable "team" {
  default = "Developer Services"
}

variable "contact-email" {
  default = "techop-devops@turner.com"
}

variable "customer" {
  default = "Developer Services"
}

locals {
  env = "${terraform.workspace == "default" ? "dev" : terraform.workspace}"

  aws_account = "${terraform.workspace == "prod" ? "aws-platform-services-prod" : "aws-platform-services-dev"}"
  saml_role   = "${local.aws_account}-admin"

  cluster_name = "${local.env == "prod" ? "platform-services-eks-prod" : (local.env == "pst" ? "platform-services-eks-test" : "platform-services-eks-dev")}"

  host_name = "${local.env == "prod" ? "${var.app}.turner-systems.com" : "${local.env}.${var.app}.turner-systems.com" }"

  tags = {
    app             = "${var.app}"
    env             = "${local.env}"
    team            = "${var.team}"
    "contact-email" = "${var.contact-email}"
    customer        = "${var.customer}"
  }
}
