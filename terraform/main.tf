terraform {
  required_providers {
    namecheap = {
      source  = "namecheap/namecheap"
      version = "~> 2.0"
    }
  }
}

provider "namecheap" {
  user_name   = var.namecheap_username
  api_user    = var.namecheap_username
  api_key     = var.namecheap_api_key
  client_ip   = var.client_ip
  use_sandbox = false
}
