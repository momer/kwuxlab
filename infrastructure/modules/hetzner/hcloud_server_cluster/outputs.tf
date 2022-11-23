output "all_hetzner_servers" {
  value = hcloud_server.default
}

output "hetzner_server_ids" {
  value = values(hcloud_server.default)[*].id
}

output "hetzner_server_names" {
  value = values(hcloud_server.default)[*].name
}
