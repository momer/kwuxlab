variable "docker_registry" {
  type    = string
  default = "registry.gitlab.com"
}

variable "docker_registry_token" {
  type    = string
  default = "<a registry token here>"
}

job "rails" {
  datacenters = ["dc1"]

  group "railsredis" {
    count = 1

    meta {
      docker_image_tag = "6.2.6-alpine3.15"
    }

    network {
      mode = "bridge"
    }

    volume "railsredis-data" {
      type      = "host"
      source    = "rails_redis"
      read_only = false
    }

    service {
      name = "railsredis"
      port = "6379"

      # TODO: Add check {}

      connect {
        sidecar_service {
          proxy {
            local_service_port = 6379
          }
        }
      }
    }

    task "railsredis" {
      driver = "docker"

      vault {
        policies = ["read-rails-details"]
      }

      volume_mount {
        volume      = "railsredis-data"
        destination = "/data"
      }

      config {
        image   = "redis:${NOMAD_META_docker_image_tag}"
        command = "redis-server"
        args    = [
          "/etc/redis/redis.conf"
        ]

        volumes = [
          "local/redis.conf:/etc/redis/redis.conf",
        ]
      }

      template {
        data = <<-EOF
          # bind 127.0.0.1 ::1
          appendonly yes
          requirepass {{ with secret "kv-v1/consul-catalog-services/rails/redis" }}{{ .Data.password }}{{ end }}
        EOF

        destination   = "local/redis.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      resources {
        cpu    = 1000
        memory = 2048
      }
    }
  }

  group "db" {
    count = 1

    network {
      mode = "bridge"

      port "db" {
        to           = 5432
        host_network = "private"
      }
    }

    service {
      name = "rails-db"
      port = "5432"

      connect {
        sidecar_service {
          proxy {
            local_service_port = 5432
          }
        }
      }
    }

    volume "db" {
      type      = "host"
      read_only = false
      source    = "rails_db"
    }

    task "db" {
      driver = "docker"

      vault {
        policies = ["read-rails-details"]
      }

      volume_mount {
        volume      = "db"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      config {
        image = "postgres:14.2-alpine"
      }

      template {
        data        = <<EOF
          POSTGRES_DB      = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.database }}{{ end }}"
          POSTGRES_USER      = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.username }}{{ end }}"
          POSTGRES_PASSWORD    = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.password }}{{ end }}"
        EOF
        destination = "secrets/rails_db.env"
        env         = true
      }

      resources {
        cpu    = 400
        memory = 512
      }
    }
  }

  group "app" {
    count = 2

    # https://www.nomadproject.io/docs/job-specification/update#blue-green-upgrades
    update {
      canary       = 1
      max_parallel = 1
    }

    meta {
      redis_database   = "1"
      docker_registry  = var.docker_registry
      docker_image     = "kwuxlab/example-rails-app"
      docker_image_tag = "v0-0-1-alpha"
    }

    network {
      mode = "bridge"

      port "http" {
        to = 3000
      }
    }

    service {
      name = "rails-app"
      port = "3000"

      tags = [
        "traefik.enable=true",
        "traefik.consulcatalog.connect=true",
        # Middleware
        # "traefik.http.middlewares.compresstraefik.compress=true",
        # Http services
        "traefik.http.services.railsapp.loadbalancer.passhostheader=true",
        "traefik.http.services.railsapp.loadbalancer.sticky=true",
        "traefik.http.services.railsapp.loadbalancer.sticky.cookie.name=railslbstk",
        "traefik.http.services.railsapp.loadbalancer.sticky.cookie.secure=true",
        # Routers
        ## Public router
        "traefik.http.routers.railsapp.rule=Host(`rails.com`)",
        "traefik.http.routers.railsapp.entrypoints=websecure",
        "traefik.http.routers.railsapp.tls=true",
        "traefik.http.routers.railsapp.tls.certresolver=letsencrypt",
        # "traefik.http.routers.railsapp.middlewares=compresstraefik",
      ]

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "rails-db"
              local_bind_port  = 5432
            }

            upstreams {
              destination_name = "railsredis"
              local_bind_port  = 6379
            }
          }
        }
      }
    }

    task "app" {
      driver = "docker"

      vault {
        # The below policy provides this access:
        #
        #   ```
        #   path "kv-v1/consul-catalog-services/rails/*" {
        #     capabilities = ["read"]
        #   }
        #   ```
        policies = ["read-rails-details"]
      }

      config {
        image = "${var.docker_registry}/${NOMAD_META_docker_image}:${NOMAD_META_docker_image_tag}"

        # Sad, these are only available in plain text or variable (i.e. not Vault)
        # right now: https://www.nomadproject.io/docs/drivers/docker#authentication
        #
        # That said, 1.4 adds variables natively
        # TODO: Implement via https://www.hashicorp.com/blog/nomad-1-4-adds-nomad-variables-and-updates-service-discovery
        auth {
          username       = "nomad_deployment"
          password       = var.docker_registry_token
          server_address = var.docker_registry
        }

        ports = ["http"]
      }

      template {
        data        = <<-EOF
          RAILS_MASTER_KEY          = "{{ with secret "kv-v1/consul-catalog-services/rails/app" }}{{ .Data.rails_master_key }}{{ end }}"
          RAILS_ENV                 = "production"
          rails_DATABASE             = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.database }}{{ end }}"
          rails_DATABASE_USERNAME    = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.username }}{{ end }}"
          rails_DATABASE_PASSWORD    = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.password }}{{ end }}"
          REDIS_URL                 = "redis://:{{ with secret "kv-v1/consul-catalog-services/rails/redis" }}{{ .Data.password }}{{ end }}@{{ env "NOMAD_UPSTREAM_ADDR_railsredis" }}/{{ env "NOMAD_META_redis_database" }}"
          PORT                      = 3000
        EOF
        destination = "secrets/rails_app.env"
        env         = true
      }

      resources {
        cpu    = 1000
        memory = 2048
      }
    }
  }

  group "sidekiq" {
    count = 3

    meta {
      redis_database   = "1"
      docker_registry  = var.docker_registry
      docker_image     = "kwux/rails"
      docker_image_tag = "v0-3-6-alpha"
    }

    network {
      mode = "bridge"
    }

    service {
      name = "rails-sidekiq-workers"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "rails-db"
              local_bind_port  = 5432
            }

            upstreams {
              destination_name = "railsredis"
              local_bind_port  = 6379
            }
          }
        }
      }
    }

    task "sidekiq" {
      driver = "docker"

      vault {
        policies = ["read-rails-details"]
      }

      config {
        image   = "${var.docker_registry}/${NOMAD_META_docker_image}:${NOMAD_META_docker_image_tag}"
        command = "bundle"
        args    = ["exec", "sidekiq"]

        # Sad, these are only available in plain text or variable (i.e. not Vault)
        # right now: https://www.nomadproject.io/docs/drivers/docker#authentication
        #
        # That said, 1.4 adds variables natively
        # TODO: Implement via https://www.hashicorp.com/blog/nomad-1-4-adds-nomad-variables-and-updates-service-discovery
        auth {
          username       = "nomad_deployment"
          password       = var.docker_registry_token
          server_address = var.docker_registry
        }
      }

      template {
        data        = <<-EOF
          RAILS_MASTER_KEY          = "{{ with secret "kv-v1/consul-catalog-services/rails/app" }}{{ .Data.rails_master_key }}{{ end }}"
          RAILS_ENV                 = "production"
          rails_DATABASE             = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.database }}{{ end }}"
          rails_DATABASE_USERNAME    = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.username }}{{ end }}"
          rails_DATABASE_PASSWORD    = "{{ with secret "kv-v1/consul-catalog-services/rails/db" }}{{ .Data.password }}{{ end }}"
          REDIS_URL                 = "redis://:{{ with secret "kv-v1/consul-catalog-services/rails/redis" }}{{ .Data.password }}{{ end }}@{{ env "NOMAD_UPSTREAM_ADDR_railsredis" }}/{{ env "NOMAD_META_redis_database" }}"
          PORT                      = 3000
        EOF
        destination = "secrets/rails_app.env"
        env         = true
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
