# Kwuxlab

The Kwuxlab is a repository containing real-world examples of:

1. Infrastructure configuration/deployment (via [terraform](https://www.terraform.io/)/[terragrunt](https://terragrunt.gruntwork.io/)) 
2. Configuration management (via [ansible](https://www.ansible.com/))
3. Deploying services on-top of a cluster of machines
   1. Private networking via [Tailscale](https://tailscale.com/)
   1. Hashicorp stack
      - Service Discovery via [Consul](https://www.consul.io/)
      - Container (and direct-host) workload scheduling and orchestration via [Nomad](https://www.nomadproject.io/)
      - Service mesh via [Consul Connect](https://www.consul.io/docs/connect)
      - Secret management via [Vault](https://www.vaultproject.io/)

## What's in the box

Kwuxlab is designed to provide you with a complete set of tools to deploy and comfortably maintain a
complete development environment. Moving from this development environment to a production environment
requires only that you add additional security where desired (*e.g.* configuring cloud-provider firewalls).

## Getting Started

This repository makes use of git submodules, which you'll need to fetch. Don't worry,
it's pretty straight-forward; the commands below should fetch all required components!

1. Clone this repository with submodules
   ```sh
   git clone --recurse-submodules -j4 git@gitlab.com:momer/kwuxlab.git
   ```

2. Ensure fetch of submodules
   ```sh
   git submodule update --init --recursive --remote
   ```
3. Begin by creating a development environment, either locally, or via a Cloud computing provider.
See this project's [/infrastructure/README](/infrastructure/README.md) for details.
4. Configure your machines with Ansible, securing them and
installing services like Tailscale, the Hashicorp stack, etc. See this project's
[/ansible/README](/ansible/README.md) for details.
5. Deploy your own applications, services, or check out [my other projects](https://umkr.com/maker/momer)
for inspiration!
