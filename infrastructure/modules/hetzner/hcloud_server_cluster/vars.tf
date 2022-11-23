variable "environment" {
  description = "Operational environment"
  type        = string
  default     = "test"
}

variable "server_names" {
  description = "List of server names to create"
  type        = list(string)
  default     = [
    "server-node1",
    "server-node2",
    "server-node3",
    "client-node1",
  ]
}

variable "server_type" {
  description = "The type of hcloud server to create"
  type        = string
  default     = "cpx21"
}

variable "image" {
  description = "The OS image to use to create the server"
  type        = string
  default     = "ubuntu-20.04"
}

variable "location" {
  description = "Target region in which to create the servers"
  type        = string
  default     = "ash"
}

variable "authorized_ssh_keys" {
  description = "List of hcloud_ssh_key ids to add to the created host's authorized_keys list"
  type        = list(string)
  default     = null
}
