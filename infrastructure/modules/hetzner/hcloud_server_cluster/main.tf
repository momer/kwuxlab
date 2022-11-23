terraform {
  # Minimum required terraform version: 1.1.8
  required_version = ">= 1.1.8"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "= 1.33.2"
    }
  }
}

resource "hcloud_server" "default" {
  for_each    = toset(var.server_names)
  name        = "${var.environment}-${each.value}"
  image       = var.image
  server_type = var.server_type
  ssh_keys    = var.authorized_ssh_keys
  location    = var.location
}
