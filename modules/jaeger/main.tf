# Criação do namespace para o Jaeger
resource "kubernetes_namespace" "jaeger" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/part-of"    = "jaeger"
    }
  }
}

# Secret para autenticação básica do Jaeger
resource "kubernetes_secret" "jaeger_auth" {
  count = (var.namespace != "default-disabled-namespace" && var.enable_authentication) ? 1 : 0

  metadata {
    name      = "jaeger-auth"
    namespace = var.create_namespace ? kubernetes_namespace.jaeger[0].metadata[0].name : var.namespace
  }

  type = "Opaque"

  data = {
    auth = "${var.jaeger_username}:{PLAIN}${var.jaeger_password}"
  }
}

locals {
  domain_name = var.create_ingress ? "${var.jaeger_subdomain}.${var.base_domain}" : ""

  elasticsearch_values = var.deploy_elasticsearch ? {
    elasticsearch = {
      replicas = var.elasticsearch_replicas
      persistence = {
        enabled      = true
        storageClass = var.storage_class_name
        size         = var.elasticsearch_storage_size
      }
      resources = {
        requests = {
          cpu    = "200m"
          memory = "1Gi"
        }
        limits = {
          cpu    = "1000m"
          memory = "2Gi"
        }
      }
      volumeClaimTemplate = {
        accessModes      = ["ReadWriteOnce"]
        storageClassName = var.storage_class_name
      }
    }
  } : {}

  # Corrigindo a estrutura do storage_values para garantir que todas as opções contenham a mesma estrutura
  storage_values = {
    storage = {
      type = var.storage_type
      elasticsearch = var.storage_type == "elasticsearch" ? {
        host = var.elasticsearch_host != "" ? var.elasticsearch_host : "elasticsearch-master.${var.namespace}.svc.cluster.local"
        port = var.elasticsearch_port
      } : null
      options = var.storage_type == "elasticsearch" ? {
        es = {
          "num-shards"   = 3
          "num-replicas" = 1
        }
      } : null
    }
  }

  # Configurações de autenticação
  auth_values = var.enable_authentication ? {
    query = {
      extraEnv = [
        {
          name  = "JAEGER_QUERY_BASIC_AUTH"
          value = "/conf/jaeger-auth/auth"
        }
      ]
      extraConfigmapMounts = []
      extraSecretMounts = [
        {
          name       = "jaeger-auth"
          secretName = "jaeger-auth"
          mountPath  = "/conf/jaeger-auth"
        }
      ]
    }
  } : {}
}

# Instalação do Jaeger via Helm
resource "helm_release" "jaeger" {
  count      = var.namespace != "default-disabled-namespace" ? 1 : 0
  name       = "jaeger"
  repository = "https://jaegertracing.github.io/helm-charts"
  chart      = "jaeger"
  version    = var.chart_version
  namespace  = var.create_namespace ? kubernetes_namespace.jaeger[0].metadata[0].name : var.namespace
  timeout    = 600

  # Valors customizados para o Jaeger
  values = [
    yamlencode(merge({
      # Configurações gerais
      nameOverride     = "jaeger"
      fullnameOverride = "jaeger"

      # Configurações de armazenamento
      provisionDataStore = {
        cassandra     = false
        elasticsearch = var.deploy_elasticsearch && var.storage_type == "elasticsearch"
      }

      # Configurações específicas do Elasticsearch
      elasticsearch = {
        replicas = var.elasticsearch_replicas
        persistence = {
          enabled          = true
          storageClassName = var.storage_class_name
          size             = var.elasticsearch_storage_size
          annotations      = {}
        }
      }

      # Configurações do Collector
      collector = {
        enabled = true
        service = {
          type = var.service_type
        }
        resources = {
          limits = {
            cpu    = var.collector_resources_limits_cpu
            memory = var.collector_resources_limits_memory
          }
          requests = {
            cpu    = var.collector_resources_requests_cpu
            memory = var.collector_resources_requests_memory
          }
        }
      }

      # Configurações do Query (UI)
      query = {
        enabled = true
        service = {
          type = var.service_type
        }
        basePath = var.ui_base_path
        resources = {
          limits = {
            cpu    = var.query_resources_limits_cpu
            memory = var.query_resources_limits_memory
          }
          requests = {
            cpu    = var.query_resources_requests_cpu
            memory = var.query_resources_requests_memory
          }
        }
        ingress = {
          enabled = false
        }
      }

      # Configurações do Agent
      agent = {
        enabled = true
        resources = {
          limits = {
            cpu    = var.agent_resources_limits_cpu
            memory = var.agent_resources_limits_memory
          }
          requests = {
            cpu    = var.agent_resources_requests_cpu
            memory = var.agent_resources_requests_memory
          }
        }
      }

      # Configurações para retenção de dados
      retention = {
        enabled  = true
        days     = var.retention_days
        schedule = "0 0 * * *"
      }

    }, local.storage_values, local.elasticsearch_values, local.auth_values))
  ]

  # Aguardar os volumes persistentes serem criados
  wait = var.wait_for_storage

  depends_on = [
    kubernetes_namespace.jaeger,
    kubernetes_secret.jaeger_auth
  ]
}

# Ingress para o Jaeger
resource "kubernetes_ingress_v1" "jaeger_ingress" {
  count = (var.namespace != "default-disabled-namespace" && var.create_ingress) ? 1 : 0

  metadata {
    name      = "jaeger-ingress"
    namespace = var.create_namespace ? kubernetes_namespace.jaeger[0].metadata[0].name : var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = var.cert_manager_environment == "prod" ? "letsencrypt-prod" : "letsencrypt-staging"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = var.enable_https ? "true" : "false"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "external-dns.alpha.kubernetes.io/hostname"      = "${var.jaeger_subdomain}.${var.base_domain}"
      "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTP"
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "50m"
      "nginx.ingress.kubernetes.io/proxy-buffer-size"  = "128k"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" = "3600"
    }
  }

  spec {
    dynamic "tls" {
      for_each = var.enable_https ? [1] : []
      content {
        hosts       = ["${var.jaeger_subdomain}.${var.base_domain}"]
        secret_name = "jaeger-tls"
      }
    }

    rule {
      host = "${var.jaeger_subdomain}.${var.base_domain}"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "jaeger-query"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.jaeger
  ]
}
