variable "environment" {
  description = "Operational environment"
  type        = string
  default     = "test"
}

variable "name" {
  description = "SSH Key name"
  type        = string
  default     = "Kwuxlab default allowed SSH key"
}

variable "ssh_public_key_path" {
  description = "Path to the target ssh public key to add"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
