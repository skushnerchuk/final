#
# Google Cloud Platform
#

terraform {
  required_version = ">=0.12,<0.13"

  backend "remote" {
    organization = "devops_project" # org name from step 2.
    workspaces {
      name = "crawler" # name for your app's state.
    }
  }
}

provider "google" {
  version = "2.9.1"
  project = "${var.project}"
  region  = "${var.region}"
}
