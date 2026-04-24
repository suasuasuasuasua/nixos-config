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
