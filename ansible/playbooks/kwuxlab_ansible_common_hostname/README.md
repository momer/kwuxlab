# Kwuxlab-ansible-common-hostname

This playbook has a singular purpose: to add a secondary (`target`) hostname
to the host's configuration.

## Target use-case

One use-case in which this playbook becomes helpful is when configuring
local, ephemeral, machines (*e.g.* Vagrant managed VMs) with tailscale
[ephemeral keys](https://tailscale.com/kb/1111/ephemeral-nodes/).

When pausing/shutting-down those machines, they may not have their desired
hostname upon reboot.