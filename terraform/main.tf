#
# Google Cloud Platform
#

terraform {
  required_version = ">=0.12,<0.13"

  backend "remote" {
    organization = "devops_project"
    workspaces {
      name = "crawler"
    }
  }
}

provider "google" {
  version = "2.9.1"
  project = "${var.project}"
  region  = "${var.region}"
}
