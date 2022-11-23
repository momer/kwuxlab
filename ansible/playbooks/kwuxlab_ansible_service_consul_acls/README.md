# kwux_service_consul_acls

This playbook configures Consul ACLs, and stores details and configuration
within a Vault instance.

As such, it has a direct dependency (in this configuration) on a
Hashicorp Vault installation.

## Requirements

### External

1. Consul
   1. Must be installed/configured on the target hosts/inventory.
   1. Master token (see `example_environment.yml`).
      - The generated master token can be obtained directly from a consul server
        host, by running:
        
        ```sh
        cat /var/lib/consul/config.json | grep master
        ```
    2. Consul DNS: must be configured and working properly
2. Vault
   1. Vault must be installed and bootstrapped on all primary datacenter
      server nodes.
   2. A Vault token with access to the `kv-v1` target namespace must be
      generated.

### Internal

#### Playbook Variables

1. `consul_master_key`: Consul ACL token used to generate node agent tokens, etc.
2. `vault_master_token`: Vault token with access to the `kv-v1` store, used to
   store Consul ACLs.
3. `target_vault_primary_datacenter`: The Consul datacenter where Vault has been
   installed, initialized, and unsealed (on all nodes).
