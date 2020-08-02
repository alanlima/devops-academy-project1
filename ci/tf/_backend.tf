# terraform {
#   backend "local" {
#     path = "./terraform.tfstate"
#   }
# }

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "alima-devopsacademy"

    workspaces {
      name = "gh-ci-project1"
    }
  }
}