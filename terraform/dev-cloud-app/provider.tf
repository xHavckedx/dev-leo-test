provider "aws" {
  region                   = "eu-central-1"
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files      = ["~/.aws/config"]
  profile                  = "leogomez"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "dev-cloud-apps-leo"
}