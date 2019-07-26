terraform {
  required_version = "~> 0.11"

  backend "s3" {
    region  = "us-east-1"
    profile = "aws-platform-services-prod:aws-platform-services-prod-admin"
    bucket  = "tf-state-platform-services"
    key     = "foundationsettings-infrastructure.tfstate"
  }
}

provider "aws" {
  version = "~> 2.8"
  region  = "${var.region}"
  profile = "${local.aws_account}:${local.saml_role}"
}

provider "local" {
  version = "~> 1.2"
}
