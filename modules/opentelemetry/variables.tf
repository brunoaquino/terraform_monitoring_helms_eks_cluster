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

variable "namespace" {
  description = "Namespace do Kubernetes onde o OpenTelemetry será instalado"
  type        = string
  default     = "opentelemetry"
}

variable "create_namespace" {
  description = "Indica se deve criar o namespace para o OpenTelemetry"
  type        = bool
  default     = true
}

variable "otel_collector_chart_version" {
  description = "Versão do chart do OpenTelemetry Collector"
  type        = string
  default     = "0.86.0"
}

variable "jaeger_chart_version" {
  description = "Versão do chart do Jaeger"
  type        = string
  default     = "0.71.10"
}

variable "service_type" {
  description = "Tipo de serviço para o OpenTelemetry e Jaeger (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "create_ingress" {
  description = "Indica se deve criar um Ingress para o Jaeger UI"
  type        = bool
  default     = true
}

variable "cert_manager_environment" {
  description = "Servidor do Let's Encrypt (staging ou prod)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["staging", "prod"], var.cert_manager_environment)
    error_message = "O valor de cert_manager_environment deve ser 'staging' ou 'prod'."
  }
}

variable "jaeger_subdomain" {
  description = "Subdomínio para acesso ao Jaeger UI (será combinado com base_domain)"
  type        = string
  default     = "jaeger"
}

variable "enable_https" {
  description = "Habilita HTTPS para os serviços"
  type        = bool
  default     = true
}

variable "elasticsearch_host" {
  description = "Hostname do serviço Elasticsearch"
  type        = string
  default     = "elasticsearch-master.elasticsearch.svc.cluster.local"
}

variable "elasticsearch_port" {
  description = "Porta do serviço Elasticsearch"
  type        = number
  default     = 9200
}

variable "prometheus_namespace" {
  description = "Namespace onde o Prometheus/Grafana está instalado"
  type        = string
  default     = "monitoring"
}

variable "grafana_host" {
  description = "Hostname do serviço Grafana"
  type        = string
  default     = "prometheus-grafana.monitoring.svc.cluster.local"
}

variable "grafana_port" {
  description = "Porta do serviço Grafana"
  type        = number
  default     = 80
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
