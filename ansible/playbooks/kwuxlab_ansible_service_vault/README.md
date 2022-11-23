## Requirements

### External

1. Consul
    1. Must be installed/configured on the target hosts/inventory.
    1.  (see `example_environment.yml`).
        - The generated master token can be used in a pinch, and can be 
          acquierd directly from a consul server host, by running:
          ```sh
          cat /var/lib/consul/config.json | grep master
          ```
    2. Consul DNS: must be configured and working properly

### Internal

### Variables

#### Playbook variables

1. `consul_acl_key`: Consul ACL token for usage by Vault storage.

#### Host variables

This playbook expects a `datacenter` variable to be set on all hosts targeted,
such that Vault is aware of the topology.
