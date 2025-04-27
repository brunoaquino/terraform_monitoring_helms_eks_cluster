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
  description = "Nome de domínio base para o qual o External-DNS terá permissões"
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
  description = "Nome da classe de armazenamento a ser usada para volumes persistentes"
  type        = string
  default     = "gp2" # Padrão para AWS EKS
}
