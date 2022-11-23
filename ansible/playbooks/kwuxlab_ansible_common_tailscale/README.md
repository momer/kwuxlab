# Kwuxlab-ansible-common-tailscale

This playbook installs and configures tailscale for the target node(s).

## Requirements

### Variables

1. `target_tailscale_auth_key`: Tailscale authorization key. Generated at the [tailscale](https://tailscale.com/) website. 
   * Additional details about this variable are at the
    [tailscale documentation site](https://tailscale.com/kb/1085/auth-keys/#authentication)
