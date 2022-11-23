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

#
# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  aws_region = "us-east-2"
}
