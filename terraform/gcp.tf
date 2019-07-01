#
# Google Cloud Platform
#

terraform {
  required_version = ">=0.11,<0.13"
}


provider "google" {
  version = "2.9.1"
  project = "${var.project}"
  region  = "${var.region}"
}
