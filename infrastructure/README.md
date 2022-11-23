# Kwuxlab / Infrastructure

This project includes multiple ways to create resources which will support a
hardy Hashicorp cluster. By default, all environments will create:

- 3 server nodes
- 1 client node

And configure access for:

- 1 SSH public key

Choose, and follow the instructions for, a compute environment to get started!

1. **Development** (recommended): [Instructions](infrastructure/terragrunt/README.md)
   to create external servers in a supported hosting provider via terragrunt/terraform scripts, and
2. **Test**: [Instructions](infrastructure/vagrant/README.md) to create local resources
   (read: virtual machines) via a tool called [Vagrant](https://www.vagrantup.com/)
