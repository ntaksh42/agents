# Azure DevOps Service Connections Reference

## Table of Contents
- [Service Endpoint Management](#service-endpoint-management)
- [Azure Resource Manager](#azure-resource-manager)
- [GitHub](#github)
- [Docker Registry](#docker-registry)
- [Kubernetes](#kubernetes)
- [Generic Service Connections](#generic-service-connections)

## Service Endpoint Management

```bash
# サービス接続一覧
az devops service-endpoint list --output table

# サービス接続詳細
az devops service-endpoint show --id {endpoint-id}

# サービス接続削除
az devops service-endpoint delete --id {endpoint-id} --yes
```

## Azure Resource Manager

```bash
# Azure サービス接続作成（サービスプリンシパル・自動）
az devops service-endpoint azurerm create \
  --name {connection-name} \
  --azure-rm-service-principal-id {sp-app-id} \
  --azure-rm-subscription-id {subscription-id} \
  --azure-rm-subscription-name {subscription-name} \
  --azure-rm-tenant-id {tenant-id}

# マネージド ID での接続（Workload Identity Federation）
# Azure DevOps UI または REST API で設定

# サブスクリプションスコープの接続
az devops service-endpoint azurerm create \
  --name {connection-name} \
  --azure-rm-service-principal-id {sp-app-id} \
  --azure-rm-subscription-id {subscription-id} \
  --azure-rm-subscription-name {subscription-name} \
  --azure-rm-tenant-id {tenant-id}
```

## GitHub

```bash
# GitHub サービス接続作成（PAT）
az devops service-endpoint github create \
  --name {connection-name} \
  --github-url "https://github.com" \
  --github-pat {personal-access-token}

# GitHub Enterprise
az devops service-endpoint github create \
  --name {connection-name} \
  --github-url "https://github.mycompany.com" \
  --github-pat {personal-access-token}
```

## Docker Registry

```bash
# Docker Hub 接続
az devops service-endpoint dockerregistry create \
  --name {connection-name} \
  --docker-registry "https://index.docker.io/v1/" \
  --docker-username {username} \
  --docker-password {password}

# Azure Container Registry 接続
az devops service-endpoint dockerregistry create \
  --name {connection-name} \
  --docker-registry "https://{acr-name}.azurecr.io" \
  --docker-username {sp-app-id} \
  --docker-password {sp-secret} \
  --registry-type ACR

# ACR（サービスプリンシパルなし）
# Azure DevOps UI で "Azure Container Registry" タイプを選択
```

## Kubernetes

```bash
# Kubernetes 接続作成
az devops service-endpoint kubernetes create \
  --name {connection-name} \
  --kubernetes-url {cluster-url} \
  --kubernetes-cluster-config {base64-kubeconfig}

# Azure Kubernetes Service 接続
# Azure DevOps UI で "Kubernetes" サービス接続を作成し、
# "Azure Subscription" 認証を選択
```

## Generic Service Connections

```bash
# 汎用サービス接続作成
az devops service-endpoint create \
  --service-endpoint-configuration {config-file.json}
```

構成ファイル例 (`config.json`):
```json
{
  "data": {},
  "name": "My Service Connection",
  "type": "generic",
  "url": "https://api.example.com",
  "authorization": {
    "parameters": {
      "username": "user",
      "password": "pass"
    },
    "scheme": "UsernamePassword"
  }
}
```

## Permissions

```bash
# パイプラインへのアクセス許可（すべてのパイプライン）
az devops service-endpoint update \
  --id {endpoint-id} \
  --enable-for-all

# 特定パイプラインのみ許可
# Azure DevOps UI の「セキュリティ」設定で管理
```

## Common Connection Types

| タイプ | 用途 |
|--------|------|
| Azure Resource Manager | Azure リソースへのデプロイ |
| GitHub | GitHub リポジトリ連携 |
| Docker Registry | コンテナイメージの push/pull |
| Kubernetes | K8s クラスターへのデプロイ |
| npm | npm フィードへの公開 |
| NuGet | NuGet フィードへの公開 |
| SSH | SSH 経由でのデプロイ |
| Generic | カスタム API 接続 |

## Security Best Practices

1. **最小権限の原則**: サービスプリンシパルには必要最小限の権限を付与
2. **シークレットローテーション**: 定期的に認証情報を更新
3. **Workload Identity Federation**: 可能な場合は PAT やシークレットの代わりに使用
4. **パイプラインスコープ**: 必要なパイプラインのみにアクセスを許可
5. **監査ログ**: サービス接続の使用状況を定期的に確認
