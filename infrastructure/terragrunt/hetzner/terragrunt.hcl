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

# Root-level Terragrunt configuration; note that the included/referenced
# configuration files will be loaded at run-time, and so will be context-aware.
#
# Note: Hetzner doesn't, at the time of writing, provide an s3 compatible
# object storage resource, so to keep this example simple, we'll use AWS s3
# as our remote-state storage layer.
locals {
  # Account-level variables (account id, name, local credentials profile to use)
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Region details
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Load project variables
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))

  # Remote state details
  aws_remote_state_region = local.region_vars.locals.aws_remote_state_region

  # Extract the variables we need for easy access
  hetzner_region    = local.region_vars.locals.hetzner_region
  hetzner_api_token = local.account_vars.locals.hetzner_api_token
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "hcloud" {
  token = "${get_env("HETZNER_API_TOKEN")}"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config  = {
    encrypt        = true
    bucket         = "${local.project_vars.locals.project_name}-hetzner-${local.environment_vars.locals.environment}-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_remote_state_region
    dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
