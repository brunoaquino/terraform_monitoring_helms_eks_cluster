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

variable "loki_subdomain" {
  description = "Subdomínio para acesso ao Loki (será combinado com base_domain)"
  type        = string
  default     = "loki"
}

variable "namespace" {
  description = "Namespace do Kubernetes onde o Loki será instalado"
  type        = string
  default     = "monitoring"
}

variable "prometheus_namespace" {
  description = "Namespace do Kubernetes onde o Prometheus/Grafana está instalado"
  type        = string
  default     = "monitoring"
}

variable "create_namespace" {
  description = "Indica se deve criar o namespace para o Loki"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Versão do Helm chart do Loki"
  type        = string
  default     = "2.9.10"
}

variable "service_type" {
  description = "Tipo de serviço para o Loki (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "enable_https" {
  description = "Habilita HTTPS para o Loki"
  type        = bool
  default     = true
}

variable "create_ingress" {
  description = "Indica se deve criar um Ingress para o Loki"
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

variable "loki_storage_size" {
  description = "Tamanho do volume persistente para o Loki"
  type        = string
  default     = "10Gi"
}

variable "storage_class_name" {
  description = "Nome da storage class para os volumes persistentes"
  type        = string
  default     = "gp2"
}

variable "loki_resources_requests_cpu" {
  description = "Requisição de CPU para o Loki"
  type        = string
  default     = "100m"
}

variable "loki_resources_requests_memory" {
  description = "Requisição de memória para o Loki"
  type        = string
  default     = "512Mi"
}

variable "loki_resources_limits_cpu" {
  description = "Limite de CPU para o Loki"
  type        = string
  default     = "500m"
}

variable "loki_resources_limits_memory" {
  description = "Limite de memória para o Loki"
  type        = string
  default     = "1Gi"
}

variable "promtail_resources_requests_cpu" {
  description = "Requisição de CPU para o Promtail"
  type        = string
  default     = "50m"
}

variable "promtail_resources_requests_memory" {
  description = "Requisição de memória para o Promtail"
  type        = string
  default     = "256Mi"
}

variable "promtail_resources_limits_cpu" {
  description = "Limite de CPU para o Promtail"
  type        = string
  default     = "250m"
}

variable "promtail_resources_limits_memory" {
  description = "Limite de memória para o Promtail"
  type        = string
  default     = "512Mi"
}

variable "loki_retention" {
  description = "Período de retenção dos dados no Loki"
  type        = string
  default     = "168h" # 7 dias
}

variable "wait_for_storage" {
  description = "Define se o deployment deve aguardar os PersistentVolumeClaims serem criados"
  type        = bool
  default     = true
} 
