# Terraform EKS Monitoring Stack

Este projeto implementa uma stack de monitoramento completa para clusters EKS (Amazon Elastic Kubernetes Service) utilizando Terraform. O módulo provisiona Prometheus e Grafana para a coleta e visualização de métricas do cluster Kubernetes e de suas aplicações.

## Arquitetura

A solução implanta:

- **Prometheus**: Para coleta e armazenamento de métricas
- **Grafana**: Para visualização e dashboards
- **Node Exporter**: Para coletar métricas de sistema dos nós
- **Ingress (opcional)**: Para acesso externo com HTTPS

## Pré-requisitos

- Terraform >= 1.0.0
- AWS CLI configurado com permissões adequadas
- Cluster EKS existente
- kubectl configurado para o cluster EKS

## Como usar

1. Clone este repositório
2. Configure as variáveis no arquivo `terraform.tfvars`
3. Inicialize e aplique o Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Variáveis

Consulte o arquivo `variables.tf` para uma lista completa das variáveis disponíveis. As principais incluem:

- `aws_region`: Região AWS onde o cluster EKS está localizado
- `eks_cluster_name`: Nome do cluster EKS
- `prometheus_namespace`: Namespace para instalação do Prometheus e Grafana
- `grafana_admin_password`: Senha do administrador do Grafana
- `prometheus_storage_size`: Tamanho do armazenamento persistente para o Prometheus
- `grafana_storage_size`: Tamanho do armazenamento persistente para o Grafana

## Dashboards do Grafana

O Grafana vem pré-configurado com vários dashboards úteis para monitoramento de clusters Kubernetes. Recomendamos importar os seguintes dashboards adicionais:

### Node Exporter Full (ID: 1860)

Dashboard completo para métricas de sistema dos nós, incluindo CPU, memória, rede e disco.  
URL: https://grafana.com/grafana/dashboards/1860

### Kubernetes Cluster Monitoring (ID: 315)

Visão geral do cluster Kubernetes com métricas de nós, pods e recursos do sistema.  
URL: https://grafana.com/grafana/dashboards/315

### Prometheus Statistics (ID: 7587)

Monitora o próprio Prometheus, incluindo desempenho e uso de recursos.  
URL: https://grafana.com/grafana/dashboards/7587

### Kubernetes EKS Cluster (ID: 17119)

Dashboard específico para EKS, com métricas específicas da AWS e do EKS.  
URL: https://grafana.com/grafana/dashboards/17119-kubernetes-eks-cluster-prometheus/

### Kubernetes Cluster (Prometheus) (ID: 10670)

Funciona bem com versões recentes do Prometheus e fornece métricas resumidas sobre containers rodando no Kubernetes.  
URL: https://grafana.com/grafana/dashboards/10670-kubernetes-cluster-prometheus/

### Kubernetes Pod and Cluster Monitoring (ID: 6663)

Dashboard abrangente com foco em pods e recursos do cluster.  
URL: https://grafana.com/grafana/dashboards/6663

## Como importar dashboards no Grafana

1. Acesse a interface web do Grafana
2. Vá em Dashboards > Import
3. Digite o ID do dashboard na caixa de texto "Import via grafana.com"
4. Selecione "Prometheus" como fonte de dados
5. Clique em "Import"

## Outputs

Após aplicar o Terraform, os seguintes outputs estarão disponíveis:

- URL do Prometheus
- URL do Grafana
- Credenciais de acesso

## Suporte

Para dúvidas ou problemas, abra uma issue no repositório.
