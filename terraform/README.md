# Terraform / OpenTofu — DNS Management

## What is this?

[OpenTofu](https://opentofu.org/) (open-source fork of Terraform) is an infrastructure-as-code tool.
Instead of clicking around in a web UI to manage DNS records, you declare what you want in `.tf` files
and `tofu apply` makes it so. Benefits:

- **No drift** — the config is the source of truth, not a dashboard
- **Version controlled** — adding a subdomain is a one-line commit
- **Readable** — every record is visible at a glance

## File layout

```
terraform/
├── main.tf           # provider config (Namecheap API settings)
├── variables.tf      # input variable declarations
├── dns.tf            # the actual DNS records
├── .gitignore        # excludes secrets and local state from git
└── terraform.tfvars  # your secrets — NOT committed to git, create manually
```

## First-time setup

### 1. Enable the Namecheap API

Profile → Tools → API Access → enable it and whitelist your public IP (`curl ifconfig.me`).

### 2. Create `terraform.tfvars`

This file is gitignored and holds your secrets:

```hcl
namecheap_username = "your-namecheap-username"
namecheap_api_key  = "your-api-key"
client_ip          = "your-public-ip"  # curl ifconfig.me
```

### 3. Initialize and apply

```bash
tofu init     # downloads the namecheap provider
tofu plan     # preview what will change
tofu apply    # apply changes
```

> **Note:** On first run, manually delete any conflicting records from the Namecheap dashboard
> before running `tofu apply`. The provider errors on duplicates even in MERGE mode.
> After the first apply, tofu owns those records and subsequent runs handle updates cleanly.

## Day-to-day usage

**Adding a new subdomain** — add a `record` block to `dns.tf`:

```hcl
record {
  hostname = "myservice"
  type     = "A"
  address  = local.vps0_ip
}
```

Then run `tofu apply`.

**If your home IP changes** — update `client_ip` in `terraform.tfvars` before running tofu,
since Namecheap whitelists the IP that's allowed to call their API.

## MERGE vs OVERWRITE mode

The `namecheap_domain_records` resource has a `mode` field in `dns.tf`:

- `"MERGE"` — only manages the records declared here, leaves others alone (e.g. Namecheap's default email/parking records)
- `"OVERWRITE"` — tofu owns *all* records; anything not declared gets deleted

Currently set to `MERGE`, which is the safer default.

## State file

OpenTofu tracks what it has applied in `terraform.tfstate`. This file is gitignored because it can
contain sensitive values. Don't delete it — tofu uses it to diff against your config on the next
run. If you lose it, you can reimport resources, but it's easier to just not lose it.
