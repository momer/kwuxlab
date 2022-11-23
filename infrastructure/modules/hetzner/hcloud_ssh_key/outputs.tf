output "hcloud_ssh_key_id" {
  value = hcloud_ssh_key.default.id
}

output "hcloud_ssh_key_name" {
  value = hcloud_ssh_key.default.name
}

output "hcloud_ssh_key_public_key" {
  value = hcloud_ssh_key.default.public_key
}

output "hcloud_ssh_key_fingerprint" {
  value = hcloud_ssh_key.default.fingerprint
}

output "hcloud_ssh_key_labels" {
  value = hcloud_ssh_key.default.labels
}
