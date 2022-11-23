# Kwuxlab / Infrastructure / Vagrant

> NOTE: Unless you're working with a beast of a computer, and can beef up the
resources on your Vagrant machines, I highly recommend paying a few bucks for
a hosting provider (AWS/Hetzner) to use the development environment instead.
>
> On some machines, the Vagrant execution of Ansible playbooks
is pretty quick, while on others, I've experienced excruciatingly slow
execution.

## Pre-requisites & Configuration

You don't need to be an expert to get started with Vagrant, but I do recommend
being familiar with how it works. Going through the official
[Getting Started](https://learn.hashicorp.com/tutorials/vagrant/getting-started-install?in=vagrant/getting-started)
would be a good use of your time, if you're going this route!

1. [Install Vagrant](https://www.vagrantup.com/downloads)
   - You may need to install/configure `virtualbox` as well,
      as the provider.
