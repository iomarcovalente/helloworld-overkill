terraform {
  backend "s3" {
    bucket = "terraform.helloworld-overkill"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}
