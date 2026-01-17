# Azure Pipelines CLI Reference

## Table of Contents
- [Pipeline Management](#pipeline-management)
- [Pipeline Runs](#pipeline-runs)
- [Build Operations](#build-operations)
- [Release Pipelines](#release-pipelines)
- [Variables and Variable Groups](#variables-and-variable-groups)

## Pipeline Management

```bash
# パイプライン一覧
az pipelines list --output table

# パイプライン詳細
az pipelines show --name {pipeline-name}
az pipelines show --id {pipeline-id}

# パイプライン作成（YAMLファイルから）
az pipelines create \
  --name {pipeline-name} \
  --repository {repo-name} \
  --branch main \
  --yaml-path azure-pipelines.yml

# パイプライン削除
az pipelines delete --id {pipeline-id} --yes

# パイプライン更新
az pipelines update --id {pipeline-id} --new-name "New Name"
```

## Pipeline Runs

### 実行
```bash
# パイプラインを実行
az pipelines run --name {pipeline-name}

# 特定ブランチで実行
az pipelines run --name {pipeline-name} --branch {branch}

# パラメータを指定して実行
az pipelines run --name {pipeline-name} --parameters key1=value1 key2=value2

# 変数を指定して実行
az pipelines run --name {pipeline-name} --variables var1=value1 var2=value2
```

### 実行状態の確認
```bash
# 実行一覧
az pipelines runs list --pipeline-name {name} --output table

# 特定ステータスの実行
az pipelines runs list --status completed --result succeeded
az pipelines runs list --status inProgress

# 実行詳細
az pipelines runs show --id {run-id}

# 最新の実行結果
az pipelines runs list --pipeline-name {name} --top 1
```

## Build Operations

```bash
# ビルド一覧
az pipelines build list --output table

# ステータス別ビルド
az pipelines build list --status inProgress
az pipelines build list --status completed --result failed

# ビルド詳細
az pipelines build show --build-id {id}

# ビルドログ取得
az pipelines build logs --build-id {id}

# ビルドをキャンセル
az pipelines build cancel --build-id {id}

# ビルドをキューに追加
az pipelines build queue --definition-name {pipeline-name}

# ビルドタグ操作
az pipelines build tag add --build-id {id} --tags tag1 tag2
az pipelines build tag list --build-id {id}
az pipelines build tag delete --build-id {id} --tag tag1
```

## Release Pipelines

```bash
# リリース定義一覧
az pipelines release definition list --output table

# リリース定義詳細
az pipelines release definition show --id {definition-id}

# リリース一覧
az pipelines release list --output table

# リリース詳細
az pipelines release show --id {release-id}

# リリース作成（手動トリガー）
az pipelines release create --definition-id {definition-id}

# 特定アーティファクトバージョンでリリース
az pipelines release create \
  --definition-id {definition-id} \
  --artifact-metadata-list "alias=version"
```

## Variables and Variable Groups

### パイプライン変数
```bash
# 変数一覧
az pipelines variable list --pipeline-name {name}

# 変数作成
az pipelines variable create \
  --pipeline-name {name} \
  --name {var-name} \
  --value {value}

# シークレット変数作成
az pipelines variable create \
  --pipeline-name {name} \
  --name {var-name} \
  --value {value} \
  --secret true

# 変数更新
az pipelines variable update \
  --pipeline-name {name} \
  --name {var-name} \
  --value {new-value}

# 変数削除
az pipelines variable delete --pipeline-name {name} --name {var-name} --yes
```

### 変数グループ
```bash
# 変数グループ一覧
az pipelines variable-group list --output table

# 変数グループ詳細
az pipelines variable-group show --group-id {id}

# 変数グループ作成
az pipelines variable-group create \
  --name {group-name} \
  --variables key1=value1 key2=value2

# 変数グループに変数追加
az pipelines variable-group variable create \
  --group-id {id} \
  --name {var-name} \
  --value {value}

# Key Vault リンク変数グループ
az pipelines variable-group create \
  --name {group-name} \
  --authorize true \
  --type AzureKeyVault \
  --azure-rm-service-endpoint-id {service-connection-id} \
  --azure-key-vault {keyvault-name}
```

## Agents and Pools

```bash
# エージェントプール一覧
az pipelines pool list --output table

# プール内のエージェント一覧
az pipelines agent list --pool-id {pool-id}

# エージェント詳細
az pipelines agent show --pool-id {pool-id} --agent-id {agent-id}
```

## Folders

```bash
# フォルダー一覧
az pipelines folder list

# フォルダー作成
az pipelines folder create --path "\\Folder\\SubFolder"

# フォルダー削除
az pipelines folder delete --path "\\Folder" --yes
```
