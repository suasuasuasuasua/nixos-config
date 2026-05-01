locals {
  hetzner_cloud_vps0_ip = "5.78.184.15"
  hetzner_cloud_vps1_ip = "5.78.145.94"
}

resource "namecheap_domain_records" "sua_dev" {
  domain = "sua.dev"
  mode   = "MERGE"

  record {
    hostname = "@"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "staging"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "gitea"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "files"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "www"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "vpn"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "mc"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "hetzner-cloud-vps0"
    type     = "A"
    address  = local.hetzner_cloud_vps0_ip
  }

  record {
    hostname = "hetzner-cloud-vps1"
    type     = "A"
    address  = local.hetzner_cloud_vps1_ip
  }
}
