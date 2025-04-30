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
  description = "Namespace do Kubernetes onde o Prometheus será instalado"
  type        = string
  default     = "prometheus"
}

variable "create_namespace" {
  description = "Indica se deve criar o namespace para o Prometheus"
  type        = bool
  default     = true
}

variable "chart_version" {
  description = "Versão do Helm chart do Prometheus"
  type        = string
  default     = "54.2.2"
}

variable "service_type" {
  description = "Tipo de serviço para o Prometheus (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "ClusterIP"
}

variable "enable_https" {
  description = "Habilita HTTPS para o Prometheus"
  type        = bool
  default     = true
}

variable "create_ingress" {
  description = "Indica se deve criar um Ingress para o Prometheus"
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

variable "grafana_admin_password" {
  description = "Senha do administrador do Grafana"
  type        = string
  default     = ""
  sensitive   = true
}

variable "prometheus_retention" {
  description = "Período de retenção dos dados no Prometheus"
  type        = string
  default     = "15d"
}

variable "prometheus_resources_requests_cpu" {
  description = "Requisição de CPU para o Prometheus"
  type        = string
  default     = "200m"
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
  description = "Tamanho do volume persistente para o Prometheus"
  type        = string
  default     = "50Gi"
}

variable "grafana_storage_size" {
  description = "Tamanho do volume persistente para o Grafana"
  type        = string
  default     = "10Gi"
}

variable "storage_class_name" {
  description = "Nome da storage class para os volumes persistentes"
  type        = string
  default     = "gp2"
}

variable "wait_for_storage" {
  description = "Define se o deployment deve aguardar os PersistentVolumeClaims serem criados"
  type        = bool
  default     = true
}

variable "prometheus_subdomain" {
  description = "Subdomínio para acesso ao Prometheus (será combinado com base_domain)"
  type        = string
  default     = "prometheus"
}

variable "grafana_subdomain" {
  description = "Subdomínio para acesso ao Grafana (será combinado com base_domain)"
  type        = string
  default     = "grafana"
}

variable "alertmanager_subdomain" {
  description = "Subdomínio para acesso ao Alertmanager (será combinado com base_domain)"
  type        = string
  default     = "alertmanager"
}
