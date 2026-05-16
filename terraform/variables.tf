variable "namecheap_username" {
  type      = string
  sensitive = true
}

variable "namecheap_api_key" {
  type      = string
  sensitive = true
}

variable "client_ip" {
  description = "Your whitelisted IP for the Namecheap API"
  type        = string
}

variable "uptime_kuma_endpoint" {
  description = "URL of the Uptime Kuma instance"
  type        = string
  default     = "https://uptime-kuma.sua.dev"
}

variable "uptime_kuma_username" {
  type      = string
  sensitive = true
}

variable "uptime_kuma_password" {
  type      = string
  sensitive = true
}
