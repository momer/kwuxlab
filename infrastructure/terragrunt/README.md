# Kwuxlab / Infrastructure / Terragrunt 

This repository provides scripts
([terraform](https://www.terraform.io/) / [terragrunt](https://terragrunt.gruntwork.io/))
which will help you quickly create external (*e.g.* AWS, Hetzner) infrastructure
resources.

> NOTE: You don't have to be an expert in either terraform or terragrunt to get
> started, but it is helpful to know that terragrunt is a project that
> extends/builds
> on-top of terraform, providing additional features.

## Billing Reminder

> WARNING: creating any resources within any external provider may cause charges/fees, which you
> will be obligated to pay. Any billing incurred as a result of following this project is your
> obligation. 
> 
> I recommend destroying any resources when you've finished using them, by running
> `terragrunt destroy`, or, `terragrunt run-all destroy`.

## Pre-requisites & Configuration

Before we start deploying any infrastructure, follow the instructions below to
prepare your
local machine by installing and configuring the required dependencies:

1. Install [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Install [terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
3. Create and activate an [Amazon Web Services (AWS) Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
4. Create an [AWS S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html)
   > Note: This step is required regardless of which hosting provider you
   > choose to use for compute resources (*i.e.* servers), in order to
   > provide terraform a location to save its state.
    - Optionally (recommended): [Block public access to your S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/configuring-block-public-access-bucket.html)
5. [Create an SSH key, and add it to the `ssh-agent`](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
   (if you don't already have one)
6. Select a supported provider, and follow the instructions in the directory
   containing their terraform code/configuration (links below).
    - [x] :heavy_check_mark: [Hetzner](/infrastructure/terragrunt/hetzner/README.md)
    - [ ] :no_entry_sign: AWS (`pending`)
7. Optional (recommended) steps:
    1. Install [direnv](https://direnv.net/#basic-installation) to help manage
       environment variables

### Environment variables

In order to provide terraform/terragrunt access to sensitive materials 
(*e.g.* AWS or Hetzner API tokens), these terragrunt scripts expect that
certain environment variables are set.


This project supports [direnv](https://direnv.net/) to manage environment
variables, but it's not required.

The `.envrc.example` files located in the directories listed below detail
the environment variables needed.

**If you're using [direnv](https://direnv.net/)**:

Rename the `.envrc.example` files (locations listed below)
to `.envrc`, and modify their values as needed (*e.g.* by setting API tokens, etc.).

```
# First, move the .envrc.example file to .envrc, so that it's ignored by git

mv .envrc.example .envrc

# Then, edit .envrc with your favorite text editor!
```

Ensure that your secrets aren't committed to the version control system
(this repository is, by default, configured to ignore `.envrc` files)!

**else**:

Use whatever system/configuration works best for you to ensure that the
environment variables specified in the `.envrc.example` files (listed below) are
set prior to running any `terragrunt` commands!

### Example direnv files:

You'll only need to set the environment variables for your target hosting 
provider!

#### AWS 

- [./aws/non-prod/.envrc.example](./aws/non-prod/.envrc.example)

#### Hetzner

- [./hetzner/non-prod/.envrc.example](./hetzner/non-prod/.envrc.example)

## Deployment

Finally, to deploy the development within any of the supported providers,
follow the instructions in their associated README files (linked below):

- [x] :heavy_check_mark: [Hetzner](/infrastructure/terragrunt/hetzner/README.md)
- [ ] :no_entry_sign: AWS (`pending`)


### Terraform encryption

Some modules may generate/require sensitive information (*e.g.* 
User Access Keys). It's best practice to configure Terraform to encrypt these
values, if possible; this project leverages [Keybase](https://keybase.io/) for
this functionality.

## References

 - [Terragrunt infrastructure live exmaple](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/)
