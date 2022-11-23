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

locals {
  # For this demonstration of Hetzner services, we'll still want to store our
  # terraform remote state in an s3-compatible service; and, as Hetzner doesn't,
  # at the time of writing, provide such a service, we'll use an AWS S3 bucket.
  aws_remote_state_region = "us-east-2"

  # Hetzner details
  hetzner_region = ""
}
