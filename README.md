# Terraform EKS Monitoring Stack

Este projeto implementa uma stack de monitoramento completa para clusters EKS (Amazon Elastic Kubernetes Service) utilizando Terraform. O módulo provisiona Prometheus, Grafana, Loki, OpenTelemetry e Jaeger para a coleta e visualização de métricas, traces e logs do cluster Kubernetes e de suas aplicações.

## Arquitetura

A solução implanta:

- **Prometheus Stack**

  - **Prometheus Server**: Para coleta e armazenamento de métricas
  - **Grafana**: Para visualização e dashboards
  - **AlertManager**: Para gerenciamento de alertas
  - **Node Exporter**: Para coletar métricas de sistema dos nós
  - **kube-state-metrics**: Para métricas detalhadas do Kubernetes

- **OpenTelemetry Stack**
  - **OpenTelemetry Collector**: Para recepção, processamento e exportação de telemetria
  - **Jaeger**: Para rastreamento distribuído (tracing)
- **Logging Stack**

  - **Loki**: Para agregação e consulta de logs
  - **Promtail**: Para coleta de logs dos pods e nós

- **Storage**
  - **Elasticsearch** (opcional): Para armazenamento de traces do Jaeger
- **Acesso Externo**
  - **Ingress NGINX**: Para acesso externo com HTTPS
  - **ExternalDNS**: Para configuração automática de registros DNS
  - **Cert-Manager**: Para provisão automática de certificados SSL/TLS

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

### Configurações Gerais

- `aws_region`: Região AWS onde o cluster EKS está localizado
- `eks_cluster_name`: Nome do cluster EKS
- `base_domain`: Domínio base para acesso aos serviços (ex: mixnarede.com.br)

### Prometheus e Grafana

- `prometheus_namespace`: Namespace para instalação do Prometheus e Grafana (default: "monitoring")
- `prometheus_create_namespace`: Define se o namespace do Prometheus deve ser criado (default: true)
- `prometheus_chart_version`: Versão do chart Helm do Prometheus (default: "56.16.0")
- `prometheus_retention`: Período de retenção das métricas no Prometheus (default: "10d")
- `grafana_admin_password`: Senha do administrador do Grafana
- `prometheus_storage_size`: Tamanho do armazenamento persistente para o Prometheus (default: "10Gi")
- `grafana_storage_size`: Tamanho do armazenamento persistente para o Grafana (default: "10Gi")

### Loki

- `loki_enabled`: Define se o Loki deve ser habilitado (default: true)
- `loki_namespace`: Namespace para instalação do Loki (default: "loki")
- `loki_chart_version`: Versão do chart Helm do Loki (default: "5.41.2")
- `loki_retention`: Período de retenção dos logs no Loki (default: "168h")
- `loki_storage_size`: Tamanho do armazenamento persistente para o Loki (default: "10Gi")

### Elasticsearch

- `elasticsearch_enabled`: Define se o Elasticsearch deve ser habilitado (default: true)
- `elasticsearch_namespace`: Namespace para instalação do Elasticsearch (default: "elasticsearch")
- `elasticsearch_chart_version`: Versão do chart Helm do Elasticsearch (default: "7.17.3")
- `elasticsearch_storage_size`: Tamanho do armazenamento persistente para o Elasticsearch (default: "30Gi")
- `elasticsearch_replicas`: Número de réplicas do Elasticsearch (default: 3)
- `elasticsearch_heap_size`: Tamanho do heap do Elasticsearch (default: "512m")

### OpenTelemetry

- `opentelemetry_enabled`: Define se o OpenTelemetry deve ser habilitado (default: true)
- `opentelemetry_namespace`: Namespace para instalação do OpenTelemetry (default: "opentelemetry")
- `otel_collector_chart_version`: Versão do chart Helm do OpenTelemetry Collector (default: "0.86.0")
- `jaeger_chart_version`: Versão do chart Helm do Jaeger (default: "0.71.10")
- `jaeger_subdomain`: Subdomínio para acesso ao Jaeger UI (default: "jaeger")

### Ingress e Segurança

- `create_ingress`: Define se os Ingresses devem ser criados (default: true)
- `enable_https`: Habilita HTTPS para os serviços (default: true)
- `cert_manager_letsencrypt_server`: Servidor do Let's Encrypt (staging ou prod) (default: "staging")

## Módulos

### 1. Prometheus Stack

Este módulo instala o Prometheus Operator, kube-prometheus-stack, que inclui:

- Prometheus Server: Coleta e armazenamento de métricas
- AlertManager: Gerenciamento de alertas
- Grafana: Visualização de métricas
- Service Monitors: Para descoberta automática de serviços a serem monitorados

Acesso:

- Prometheus UI: https://prometheus.exemplo.com
- Grafana UI: https://grafana.exemplo.com
- AlertManager UI: https://alertmanager.exemplo.com

Credenciais do Grafana:

- Usuário: admin
- Senha: [definida em `grafana_admin_password`]

### 2. Loki Stack

O Loki é uma solução de agregação de logs escalável e econômica, integrada ao Grafana:

- Loki: Sistema de armazenamento e indexação de logs
- Promtail: Agente que coleta logs dos contêineres e nós do Kubernetes

Configurado como datasource no Grafana, permitindo consultas de logs com LogQL.

Exemplo de consulta LogQL:

```
{namespace="default", app="demo-app"} |= "error"
```

### 3. OpenTelemetry e Jaeger

O OpenTelemetry Collector é configurado para receber, processar e exportar telemetria:

- Recebe dados via protocolos OTLP, Jaeger, Zipkin
- Exporta para Jaeger para visualização
- Exporta para Elasticsearch para armazenamento de longo prazo

O Jaeger fornece visualização e análise de traces distribuídos:

- Jaeger UI: https://jaeger.exemplo.com
- Endpoints para envio de traces:
  - Jaeger Collector: http://jaeger-collector.opentelemetry.svc.cluster.local:14268/api/traces
  - OpenTelemetry Collector (OTLP/HTTP): http://opentelemetry-collector.opentelemetry.svc.cluster.local:4318
  - OpenTelemetry Collector (OTLP/gRPC): grpc://opentelemetry-collector.opentelemetry.svc.cluster.local:4317
  - Jaeger UDP: jaeger-agent.opentelemetry.svc.cluster.local:6831 (Thrift/UDP)

### 4. Elasticsearch

O Elasticsearch é usado como armazenamento para traces do Jaeger:

- Alta performance para consultas de traces
- Retenção de longo prazo
- Escalabilidade horizontal

## Instrumentação de Aplicações

### Exemplo de Aplicação com Traces

Um exemplo de aplicação (HotROD) está incluído para demonstrar a instrumentação de traces:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo-app
  template:
    metadata:
      labels:
        app: demo-app
    spec:
      containers:
        - name: demo-app
          image: jaegertracing/example-hotrod:1.30.0
          ports:
            - containerPort: 8080
          env:
            - name: JAEGER_ENDPOINT
              value: "http://jaeger-collector.opentelemetry.svc.cluster.local:14268/api/traces"
            - name: JAEGER_SAMPLER_TYPE
              value: "const"
            - name: JAEGER_SAMPLER_PARAM
              value: "1"
            - name: JAEGER_REPORTER_LOG_SPANS
              value: "true"
            - name: JAEGER_SERVICE_NAME
              value: "hotrod"
```

### Instrumentação para Outras Linguagens

#### Java (Spring Boot)

```xml
<dependency>
    <groupId>io.opentelemetry</groupId>
    <artifactId>opentelemetry-api</artifactId>
    <version>1.29.0</version>
</dependency>
<dependency>
    <groupId>io.opentelemetry</groupId>
    <artifactId>opentelemetry-sdk</artifactId>
    <version>1.29.0</version>
</dependency>
<dependency>
    <groupId>io.opentelemetry</groupId>
    <artifactId>opentelemetry-exporter-otlp</artifactId>
    <version>1.29.0</version>
</dependency>
```

#### Python

```
pip install opentelemetry-api opentelemetry-sdk opentelemetry-exporter-otlp
```

#### Node.js

```
npm install @opentelemetry/api @opentelemetry/sdk-node @opentelemetry/exporter-trace-otlp-http
```

#### .NET

```
dotnet add package OpenTelemetry.Extensions.Hosting
dotnet add package OpenTelemetry.Exporter.OpenTelemetryProtocol
```

## Segurança e Autenticação

Por padrão, a stack de monitoramento é instalada sem autenticação. Para ambientes de produção, é altamente recomendado configurar autenticação:

### Opção 1: Autenticação com Keycloak (OpenID Connect)

1. Configure um Client no Keycloak:

   - Client ID: jaeger
   - Access Type: confidential
   - Valid Redirect URIs: https://jaeger.exemplo.com/*
   - Web Origins: https://jaeger.exemplo.com

2. Instale o OAuth2-Proxy:

   ```yaml
   config:
     clientID: "jaeger"
     clientSecret: "seu-client-secret"
     cookieSecret: "cookie-secret-aleatorio"
     configFile: |-
       provider = "keycloak-oidc"
       oidc_issuer_url = "https://seu-keycloak.exemplo.com/realms/jaeger"
       redirect_url = "https://jaeger.exemplo.com/oauth2/callback"
       upstreams = [ "http://jaeger-query.opentelemetry.svc.cluster.local:80/" ]
   ```

3. Atualize o Ingress para usar o OAuth2-Proxy:
   ```yaml
   annotations:
     nginx.ingress.kubernetes.io/auth-signin: "https://jaeger.exemplo.com/oauth2/start?rd=$escaped_request_uri"
     nginx.ingress.kubernetes.io/auth-url: "https://jaeger.exemplo.com/oauth2/auth"
   ```

### Opção 2: Autenticação Básica com Ingress NGINX

```yaml
annotations:
  nginx.ingress.kubernetes.io/auth-type: basic
  nginx.ingress.kubernetes.io/auth-secret: basic-auth
  nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
```

## Dashboards do Grafana

O Grafana vem pré-configurado com vários dashboards, mas recomendamos importar os seguintes:

- **Node Exporter Full** (ID: 1860): Métricas detalhadas dos nós
- **Kubernetes Cluster Monitoring** (ID: 315): Visão geral do cluster
- **Prometheus Statistics** (ID: 7587): Monitoramento do Prometheus
- **Kubernetes EKS Cluster** (ID: 17119): Dashboard específico para EKS
- **Loki Logs** (ID: 12019): Visualização de logs
- **Jaeger Trace Analytics** (ID: 12932): Análise de traces

## Outputs

Após aplicar o Terraform, os seguintes outputs estarão disponíveis:

- **URLs de acesso**:

  - `prometheus_url`: URL do Prometheus
  - `grafana_url`: URL do Grafana
  - `alertmanager_url`: URL do AlertManager
  - `loki_url`: URL do Loki
  - `jaeger_url`: URL do Jaeger

- **Endpoints internos**:

  - `prometheus_server_endpoint`: Endpoint interno do Prometheus
  - `grafana_endpoint`: Endpoint interno do Grafana
  - `loki_endpoint`: Endpoint interno do Loki
  - `elasticsearch_endpoint`: Endpoint interno do Elasticsearch
  - `otel_collector_endpoint`: Endpoint interno do OpenTelemetry Collector
  - `jaeger_collector_endpoint`: Endpoint interno do Jaeger Collector

- **Namespaces**:
  - `prometheus_namespace`: Namespace do Prometheus
  - `loki_namespace`: Namespace do Loki
  - `elasticsearch_namespace`: Namespace do Elasticsearch
  - `opentelemetry_namespace`: Namespace do OpenTelemetry

## Considerações de Produção

### Armazenamento

- Utilize Storage Classes apropriadas para o ambiente de produção
- Considere usar volumes gerenciados como EBS para maior confiabilidade
- Configure backups adequados para volumes persistentes

### Recursos

- Ajuste os limites de recursos (CPU, memória) para cada componente
- Para clusters grandes, aumente os recursos para o Prometheus, Elasticsearch e Loki
- Configure retenção apropriada para evitar crescimento excessivo de dados

### Alta Disponibilidade

- Configure réplicas adequadas para componentes críticos
- Utilize PodDisruptionBudgets para garantir disponibilidade durante manutenções
- Distribua os componentes em diferentes zonas de disponibilidade

### Segurança

- Implemente autenticação para todos os serviços expostos
- Configure TLS para comunicação interna entre componentes
- Utilize secrets gerenciados (AWS Secrets Manager, Hashicorp Vault) para credenciais

## Solução de Problemas

### Verificando o status dos pods

```bash
kubectl get pods -n monitoring
kubectl get pods -n loki
kubectl get pods -n elasticsearch
kubectl get pods -n opentelemetry
```

### Verificando logs

```bash
kubectl logs -n monitoring deployment/prometheus-grafana
kubectl logs -n opentelemetry deployment/jaeger-query
```

### Problemas comuns e soluções

1. **Grafana não mostra datasources**

   - Verificar se os ConfigMaps estão corretamente rotulados com `grafana_datasource: "true"`
   - Verificar logs do sidecar do Grafana

2. **Jaeger não exibe traces**

   - Verificar a conexão entre aplicações e o Jaeger Collector
   - Verificar a conexão entre Jaeger e Elasticsearch
   - Verificar se as aplicações estão instrumentadas corretamente

3. **Falhas no Elasticsearch**
   - Aumentar limites de memória e CPU
   - Verificar configurações de JVM
   - Aumentar o tamanho do volume persistente

## Suporte

Para dúvidas ou problemas, abra uma issue no repositório.
