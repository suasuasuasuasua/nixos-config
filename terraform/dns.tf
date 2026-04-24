locals {
  vps0_ip = "5.78.184.15"
}

resource "namecheap_domain_records" "sua_dev" {
  domain = "sua.dev"
  mode   = "MERGE"

  record {
    hostname = "@"
    type     = "A"
    address  = local.vps0_ip
  }

  record {
    hostname = "gitea"
    type     = "A"
    address  = local.vps0_ip
  }

  record {
    hostname = "files"
    type     = "A"
    address  = local.vps0_ip
  }

  record {
    hostname = "www"
    type     = "A"
    address  = local.vps0_ip
  }
}
