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

resource "hcloud_ssh_key" "default" {
  name       = var.name
  public_key = file(var.ssh_public_key_path)
}
