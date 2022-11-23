# Copyright 2022 Mo Omer
#
# Licensed under the uMKR License, Version 1.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://umkr.com/licenses/umkr-1.0
#
# NOTICE: THIS FILE HAS BEEN MODIFIED BY Mo Omer UNDER COMPLIANCE WITH THE
# APACHE 2.0 LICENCE FROM THE ORIGINAL WORK OF THE COMPANY GRUNTWORK.
# THE FOLLOWING IS THE COPYRIGHT OF THE ORIGINAL DOCUMENT:
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0

terraform {
  source = "../../../../../../modules/hetzner/hcloud_server_cluster"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract env for use in default input
  env = local.environment_vars.locals.environment
}

# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
inputs = {
  environment  = local.env
  authorized_ssh_keys = []
  # Use the default server_names set in the upstream module, but override for
  # demonstration
  server_names = [
    "server-node1",
    "server-node2",
    "server-node3",
    "client-node1",
  ]
}