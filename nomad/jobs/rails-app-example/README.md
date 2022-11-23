## Deployment

In order to deploy rails-app, we need a token with access to the required
vault policies.
   
#### Commands

### 1. Add the generated Consul token to Vault

#### Pre-requisites

In order to run the required commands, the host must:

1. Have access to the remote **Vault** host

#### Execution

1. Log into **Vault**'s web UI, create the required secrets under `kv-v1`
  - Gitea database configuration
    - secret:
      - name: `consul-catalog-services/rails/db`
      - keys: 
        - `database` (database name), 
        - `username`, 
        - `password`
  - Deploy secrets
    - secret:
      - name: `consul-catalog-services/rails/app` 
      - keys:
        - `gitlab_registry_url`
        - `gitlab_registry_token`
2. Ensure that a **Vault** policy exists called `read-rails-details` in vault,
   with definition as below (or more specific)
  ```
     path "kv-v1/consul-catalog-services/rails/*" {
       capabilities = ["read"]
     }
  ```   

### 2. Generate the temporary Vault token for deployment

#### Pre-requisites

In order to run the required commands, the host must:

1. Have access to the remote **Nomad** host
2. Have the `vault` binary installed
3. Have defined the following variables:
   ```sh
   VAULT_ADDR="http://<REPLACE_WITH_VAULT_ADDR>:8200"
   VAULT_TOKEN="<REPLACE_WITH_VAULT_TOKEN>"
   ```

#### Execution

1. Generate the token
   ```sh
   vault token create -policy read-rails-details -period 1h -orphan
   ```

### 3. Deploy the nomad job

#### Pre-requisites

1. The token from step `3` above, defined as the environment variable 
   `VAULT_TOKEN`, or in-lined with the command below:

```sh
# Not preferred:
# VAULT_TOKEN="<token>" nomad job run -var="docker_registry_token=abcdefghijfk" rails-app-example/rails.nomad
#
# Preferred:
# VAULT_TOKEN is defined in the environment
# NOMAD_VAR_docker_registry_token is defined in the environment
nomad job run rails-app-example/rails.nomad
```

### Ref:
-  https://www.vaultproject.io/docs/secrets/kv/kv-v1
-  https://www.vaultproject.io/docs/concepts/policies
-  https://www.nomadproject.io/docs/integrations/vault-integration
-  https://www.nomadproject.io/docs/job-specification/template

## Migrations

1.  Get job status (and see allocations)

```sh
$ nomad job status rails

ID            = rails
Name          = rails
Submit Date   = 2022-05-03T12:55:08-05:00
Type          = service
Priority      = 50
Datacenters   = ...
Namespace     = default
Status        = running
Periodic      = false
Parameterized = false

Summary
Task Group  Queued  Starting  Running  Failed  Complete  Lost
app         0       0         3        0       1         0
db          0       0         1        0       0         0
sidekiq     0       0         3        0       4         0
railsredis   0       0         1        0       0         0

Latest Deployment
ID          = b5fc216c
Status      = successful
Description = Deployment completed successfully

Deployed
Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
app         3        3       3        0          2022-05-03T13:05:23-05:00
db          1        1       1        0          2022-05-03T13:05:19-05:00
sidekiq     3        3       3        0          2022-05-03T13:05:19-05:00
railsredis   1        1       1        0          2022-05-03T13:05:19-05:00

Allocations
ID        Node ID   Task Group  Version  Desired  Status    Created     Modified
050a4423  e531c390  app         3        run      running   11m2s ago   10m47s ago
d70b4723  dc5e3414  app         3        run      running   11m2s ago   10m47s ago
15a5c9f3  dc5e3414  sidekiq     3        run      running   12m45s ago  10m51s ago
23866212  e531c390  sidekiq     3        run      running   13m22s ago  10m51s ago
68ef4c6b  3c14f058  app         3        run      running   14m ago     10m51s ago
557607de  3c14f058  sidekiq     3        run      running   14m ago     10m51s ago
...
```

2. Select an allocation (any) for the `app` Task Group,
   and grab it's `ID` (e.g. `050a4423` above).
   
   With this ID, enter the container:

```sh
nomad alloc exec -task app 050a4423 /bin/sh
```

3. Run migrations

```sh
rails db:migrate
```