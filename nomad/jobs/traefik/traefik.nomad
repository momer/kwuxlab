job "traefik-dc1" {
  datacenters = ["dc1"]
  type        = "system"

  group "traefik" {
    count = 1

    volume "acme" {
      type      = "host"
      read_only = false
      source    = "traefik_acme"
    }

    network {
      port "http" {
        static = 80
        to = 80
      }

      port "https" {
        static = 443
        to = 443
      }

      port "api" {
        static = 9998
        to = 9998
        host_network = "private"
      }
    }

    service {
      name = "traefik"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    # Required to change volume permissions
    # Ref:
    # https://github.com/hashicorp/nomad/issues/8892
    task "traefik" {
      driver = "docker"

      vault {
        policies  = [
          "read-consul-catalog-services",
          # The below policy provides this access:
          #
          #   ```
          #   path "kv-v1/cloudflare/kwux/dns_challenge/*" {
          #     capabilities = ["read"]
          #   }
          #   ```
          "read-cloudflare-kwux",
        ]
      }

      volume_mount {
        volume      = "acme"
        destination = "/letsencrypt"
        read_only   = false
      }

      config {
        image        = "traefik:v2.6.2"
        network_mode = "host"

        volumes = [
          "local/traefik.toml:/etc/traefik/traefik.toml",
        ]
      }

      template {
        # Ref:
        # https://doc.traefik.io/traefik/https/acme/
        # https://go-acme.github.io/lego/dns/cloudflare/
        data        = <<EOF
          CF_API_EMAIL = "{{ with secret "kv-v1/cloudflare/kwux/dns_challenge" }}{{ .Data.api_email }}{{ end }}"
          CF_DNS_API_TOKEN = "{{ with secret "kv-v1/cloudflare/kwux/dns_challenge" }}{{ .Data.dns_api_token }}{{ end }}"
        EOF
        destination = "secrets/cloudflare.env"
        env         = true
      }

      template {
        data = <<EOF
[log]
  level = "DEBUG"
  format = "json"
[entryPoints]
    [entryPoints.http]
      address = ":80"

    [entryPoints.websecure]
      address = ":443"

    [entryPoints.traefik]
      address = ":9998"
[api]
    dashboard = true
    insecure  = true

[certificatesResolvers.letsencrypt.acme]
  email = "{{ with secret "kv-v1/cloudflare/kwux/dns_challenge" }}{{ .Data.api_email }}{{ end }}"
  storage = "/letsencrypt/acme.json"

  [certificatesResolvers.letsencrypt.acme.dnsChallenge]
    provider = "cloudflare"
    delayBeforeCheck = 0

# Enable Consul Catalog configuration backend.
[providers.consulCatalog]
    prefix = "traefik"
    connectAware = true
    connectByDefault = false
    exposedByDefault = false

    [providers.consulCatalog.endpoint]
      # address = "{{ env "NOMAD_HOST_IP_http" }}:8500"
      address = "localhost:8500"
      # secret goes here
      {{ with secret "kv-v1/consul-catalog-services/traefik/acl" }}
      token = "{{.Data.secret_id}}"
      {{ end }}
      scheme  = "http"
      datacenter = "dc1"
EOF

        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
