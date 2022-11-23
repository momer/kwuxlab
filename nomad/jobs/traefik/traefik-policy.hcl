# Ref:
# https://www.vaultproject.io/docs/secrets/kv/kv-v1
# https://www.vaultproject.io/docs/concepts/policies
# https://www.nomadproject.io/docs/integrations/vault-integration
# https://www.nomadproject.io/docs/job-specification/template
#
# 1. `consul acl policy create -name traefik -rules @traefik-policy.hcl`
# 2. `consul acl token create -description "treafik token" -policy-name traefik`
# 3. Go into Vault's UI, create a secret under kv-v1 with
#    - name: consul-catalog-services/traefik/acl
#    - keys: secret_id, accessor_id, policy_name
# Then, on a machine with vault installed
# 4. export VAULT_ADDR="http://127.0.0.1:8200"
# 5. export VAULT_TOKEN="<token configured>
# 6. Ensure that a policy exists called `read-consul-catalog-services` in vault, with definition
#   ```
#      path "kv-v1/consul-catalog-services" {
#        capabilities = ["read"]
#      }
#   ```
# 7. `vault token create -policy read-consul-catalog-services -period 1h -orphan`
# 8. VAULT_TOKEN=<token> nomad job run traefik/traefik.nomad
key_prefix "traefik" {
  policy = "write"
}

service "traefik" {
  policy = "write"
}

agent_prefix "" {
  policy = "read"
}

node_prefix "" {
  policy = "read"
}

service_prefix "" {
  policy = "read"
}