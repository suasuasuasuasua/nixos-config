terraform {
  required_providers {
    namecheap = {
      source  = "namecheap/namecheap"
      version = "~> 2.0"
    }
    uptimekuma = {
      source  = "breml/uptimekuma"
      version = "~> 0.3"
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

provider "uptimekuma" {
  endpoint = var.uptime_kuma_endpoint
  username = var.uptime_kuma_username
  password = var.uptime_kuma_password
}
