#
# Google Cloud Platform
#
provider "google" {
  #version = "2.5.0"
  project = "${var.project}"
  region  = "${var.region}"
}
