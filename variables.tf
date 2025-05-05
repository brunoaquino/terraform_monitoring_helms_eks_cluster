variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
}

variable "eks_cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
}

variable "eks_cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  type        = string
}

variable "eks_cluster_ca_cert" {
  description = "Certificado CA do cluster EKS"
  type        = string
}

variable "base_domain" {
  description = "Domínio base para acesso aos serviços via Ingress"
  type        = string
}

# Referência ao Cert-Manager já instalado no cluster
variable "cert_manager_letsencrypt_server" {
  description = "Servidor do Let's Encrypt (staging ou prod)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "prod"], var.cert_manager_letsencrypt_server)
    error_message = "O valor de cert_manager_letsencrypt_server deve ser 'staging' ou 'prod'."
  }
}

# Variáveis para o Prometheus
variable "prometheus_namespace" {
  description = "Namespace do Kubernetes onde o Prometheus será instalado"
  type        = string
  default     = "monitoring"
}

variable "prometheus_create_namespace" {
  description = "Se deve criar o namespace para o Prometheus"
  type        = bool
  default     = true
}

variable "prometheus_chart_version" {
  description = "Versão do chart Helm do Prometheus"
  type        = string
  default     = "40.0.0" # Use uma versão específica para consistência
}

variable "prometheus_service_type" {
  description = "Tipo de serviço Kubernetes para o Prometheus"
  type        = string
  default     = "ClusterIP" # Recomendado para produção com Ingress
}

variable "prometheus_enable_https" {
  description = "Se deve habilitar HTTPS para o Prometheus"
  type        = bool
  default     = true
}

variable "prometheus_create_ingress" {
  description = "Se deve criar um Ingress para o Prometheus"
  type        = bool
  default     = true
}

variable "grafana_admin_password" {
  description = "Senha do administrador do Grafana"
  type        = string
  default     = "admin" # Alterar em produção
  sensitive   = true
}

variable "prometheus_retention" {
  description = "Período de retenção de dados no Prometheus"
  type        = string
  default     = "15d" # 15 dias
}

variable "prometheus_resources_requests_cpu" {
  description = "Requisição de CPU para o Prometheus"
  type        = string
  default     = "500m"
}

variable "prometheus_resources_requests_memory" {
  description = "Requisição de memória para o Prometheus"
  type        = string
  default     = "1Gi"
}

variable "prometheus_resources_limits_cpu" {
  description = "Limite de CPU para o Prometheus"
  type        = string
  default     = "1000m"
}

variable "prometheus_resources_limits_memory" {
  description = "Limite de memória para o Prometheus"
  type        = string
  default     = "2Gi"
}

variable "prometheus_storage_size" {
  description = "Tamanho do volume de armazenamento para o Prometheus"
  type        = string
  default     = "10Gi"
}

variable "grafana_storage_size" {
  description = "Tamanho do volume de armazenamento para o Grafana"
  type        = string
  default     = "5Gi"
}

variable "storage_class_name" {
  description = "Nome da storage class a ser usada para volumes persistentes"
  type        = string
  default     = "gp2"
}

# Variáveis para o Loki
variable "loki_enabled" {
  description = "Se o Loki deve ser habilitado"
  type        = bool
  default     = true
}

variable "loki_namespace" {
  description = "Namespace do Kubernetes onde o Loki será instalado"
  type        = string
  default     = "loki"
}

variable "loki_create_namespace" {
  description = "Se deve criar o namespace para o Loki"
  type        = bool
  default     = true
}

variable "loki_chart_version" {
  description = "Versão do chart Helm do Loki"
  type        = string
  default     = "2.9.11"
}

variable "loki_service_type" {
  description = "Tipo de serviço Kubernetes para o Loki"
  type        = string
  default     = "ClusterIP"
}

variable "loki_enable_https" {
  description = "Se deve habilitar HTTPS para o Loki"
  type        = bool
  default     = true
}

variable "loki_create_ingress" {
  description = "Se deve criar um Ingress para o Loki"
  type        = bool
  default     = true
}

variable "loki_storage_size" {
  description = "Tamanho do volume de armazenamento para o Loki"
  type        = string
  default     = "10Gi"
}

variable "loki_resources_requests_cpu" {
  description = "Requisição de CPU para o Loki"
  type        = string
  default     = "200m"
}

variable "loki_resources_requests_memory" {
  description = "Requisição de memória para o Loki"
  type        = string
  default     = "256Mi"
}

variable "loki_resources_limits_cpu" {
  description = "Limite de CPU para o Loki"
  type        = string
  default     = "500m"
}

variable "loki_resources_limits_memory" {
  description = "Limite de memória para o Loki"
  type        = string
  default     = "512Mi"
}

variable "promtail_resources_requests_cpu" {
  description = "Requisição de CPU para o Promtail"
  type        = string
  default     = "100m"
}

variable "promtail_resources_requests_memory" {
  description = "Requisição de memória para o Promtail"
  type        = string
  default     = "128Mi"
}

variable "promtail_resources_limits_cpu" {
  description = "Limite de CPU para o Promtail"
  type        = string
  default     = "200m"
}

variable "promtail_resources_limits_memory" {
  description = "Limite de memória para o Promtail"
  type        = string
  default     = "256Mi"
}

variable "loki_retention" {
  description = "Período de retenção de logs no Loki (ex: 168h para 7 dias)"
  type        = string
  default     = "168h"
}

variable "loki_subdomain" {
  description = "Subdomínio para acesso ao Loki (será combinado com base_domain)"
  type        = string
  default     = "loki"
}

# Adicionando variáveis de subdomínio para completude
variable "grafana_subdomain" {
  description = "Subdomínio para acesso ao Grafana (será combinado com base_domain)"
  type        = string
  default     = "grafana"
}

variable "prometheus_subdomain" {
  description = "Subdomínio para acesso ao Prometheus (será combinado com base_domain)"
  type        = string
  default     = "prometheus"
}

variable "alertmanager_subdomain" {
  description = "Subdomínio para acesso ao Alertmanager (será combinado com base_domain)"
  type        = string
  default     = "alertmanager"
}

# Variáveis para o Elasticsearch
variable "elasticsearch_enabled" {
  description = "Se o Elasticsearch deve ser habilitado"
  type        = bool
  default     = true
}

variable "elasticsearch_namespace" {
  description = "Namespace do Kubernetes onde o Elasticsearch será instalado"
  type        = string
  default     = "elasticsearch"
}

variable "elasticsearch_create_namespace" {
  description = "Se deve criar o namespace para o Elasticsearch"
  type        = bool
  default     = true
}

variable "elasticsearch_chart_version" {
  description = "Versão do chart Helm do Elasticsearch"
  type        = string
  default     = "7.17.3"
}

variable "elasticsearch_service_type" {
  description = "Tipo de serviço Kubernetes para o Elasticsearch"
  type        = string
  default     = "ClusterIP"
}

variable "elasticsearch_replicas" {
  description = "Número de réplicas para o Elasticsearch"
  type        = number
  default     = 1
}

variable "elasticsearch_heap_size" {
  description = "Tamanho do heap do Java para o Elasticsearch"
  type        = string
  default     = "512m"
}

variable "elasticsearch_java_opts" {
  description = "Opções adicionais do Java para o Elasticsearch"
  type        = string
  default     = "-Xms512m -Xmx512m"
}

variable "elasticsearch_resources_requests_cpu" {
  description = "Requisição de CPU para o Elasticsearch"
  type        = string
  default     = "500m"
}

variable "elasticsearch_resources_requests_memory" {
  description = "Requisição de memória para o Elasticsearch"
  type        = string
  default     = "1Gi"
}

variable "elasticsearch_resources_limits_cpu" {
  description = "Limite de CPU para o Elasticsearch"
  type        = string
  default     = "1000m"
}

variable "elasticsearch_resources_limits_memory" {
  description = "Limite de memória para o Elasticsearch"
  type        = string
  default     = "2Gi"
}

variable "elasticsearch_storage_size" {
  description = "Tamanho do volume de armazenamento para o Elasticsearch"
  type        = string
  default     = "30Gi"
}

variable "elasticsearch_cluster_name" {
  description = "Nome do cluster Elasticsearch"
  type        = string
  default     = "elasticsearch"
}

# Variáveis para o OpenTelemetry
variable "opentelemetry_enabled" {
  description = "Se o OpenTelemetry deve ser habilitado"
  type        = bool
  default     = true
}

variable "opentelemetry_namespace" {
  description = "Namespace do Kubernetes onde o OpenTelemetry será instalado"
  type        = string
  default     = "opentelemetry"
}

variable "opentelemetry_create_namespace" {
  description = "Se deve criar o namespace para o OpenTelemetry"
  type        = bool
  default     = true
}

variable "otel_collector_chart_version" {
  description = "Versão do chart do OpenTelemetry Collector"
  type        = string
  default     = "0.70.0"
}

variable "jaeger_chart_version" {
  description = "Versão do chart do Jaeger"
  type        = string
  default     = "0.71.10"
}

variable "opentelemetry_service_type" {
  description = "Tipo de serviço para o OpenTelemetry e Jaeger"
  type        = string
  default     = "ClusterIP"
}

variable "opentelemetry_create_ingress" {
  description = "Indica se deve criar um Ingress para o Jaeger UI"
  type        = bool
  default     = true
}

variable "jaeger_subdomain" {
  description = "Subdomínio para acesso ao Jaeger UI (será combinado com base_domain)"
  type        = string
  default     = "jaeger"
}

variable "otel_collector_resources_requests_cpu" {
  description = "Requisição de CPU para o OpenTelemetry Collector"
  type        = string
  default     = "100m"
}

variable "otel_collector_resources_requests_memory" {
  description = "Requisição de memória para o OpenTelemetry Collector"
  type        = string
  default     = "128Mi"
}

variable "otel_collector_resources_limits_cpu" {
  description = "Limite de CPU para o OpenTelemetry Collector"
  type        = string
  default     = "200m"
}

variable "otel_collector_resources_limits_memory" {
  description = "Limite de memória para o OpenTelemetry Collector"
  type        = string
  default     = "256Mi"
}

variable "jaeger_resources_requests_cpu" {
  description = "Requisição de CPU para o Jaeger"
  type        = string
  default     = "200m"
}

variable "jaeger_resources_requests_memory" {
  description = "Requisição de memória para o Jaeger"
  type        = string
  default     = "256Mi"
}

variable "jaeger_resources_limits_cpu" {
  description = "Limite de CPU para o Jaeger"
  type        = string
  default     = "500m"
}

variable "jaeger_resources_limits_memory" {
  description = "Limite de memória para o Jaeger"
  type        = string
  default     = "512Mi"
}
