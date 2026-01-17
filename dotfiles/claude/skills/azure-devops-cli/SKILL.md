---
name: azure-devops-cli
description: |
  Azure DevOps CLI (az devops) を使用した包括的な操作スキル。
  リポジトリ、パイプライン、ボード（ワークアイテム）、アーティファクト、Wiki、サービス接続の管理を行う。
  使用場面: (1) ワークアイテム（タスク、バグ、ユーザーストーリー）の作成・更新・検索、
  (2) パイプラインの実行・監視・管理、(3) プルリクエストの作成・レビュー・マージ、
  (4) リポジトリのブランチ・ポリシー管理、(5) アーティファクトフィードの管理、
  (6) Wikiページの作成・更新、(7) Azure DevOpsプロジェクトの設定変更
---

# Azure DevOps CLI

## Prerequisites

```bash
# Azure CLI と DevOps 拡張機能のインストール確認
az --version
az extension show --name azure-devops

# 拡張機能がない場合はインストール
az extension add --name azure-devops

# ログインと組織設定
az login
az devops configure --defaults organization=https://dev.azure.com/{org} project={project}
```

## Quick Reference

| 操作 | コマンド |
|------|----------|
| ワークアイテム一覧 | `az boards work-item query --wiql "SELECT [Id] FROM WorkItems WHERE [State] = 'Active'"` |
| パイプライン実行 | `az pipelines run --name {pipeline-name}` |
| PR作成 | `az repos pr create --source-branch {branch} --target-branch main` |
| ビルド状態確認 | `az pipelines build show --build-id {id}` |

## Command Groups

### Repositories (az repos)
Git リポジトリ、ブランチ、プルリクエストの管理。
詳細: [references/repos.md](references/repos.md)

### Pipelines (az pipelines)
ビルド・リリースパイプラインの実行と管理。
詳細: [references/pipelines.md](references/pipelines.md)

### Boards (az boards)
ワークアイテム、スプリント、クエリの管理。
詳細: [references/boards.md](references/boards.md)

### Artifacts (az artifacts)
パッケージフィードとアーティファクトの管理。
詳細: [references/artifacts.md](references/artifacts.md)

### Wiki (az devops wiki)
プロジェクトWikiの管理。
詳細: [references/wiki.md](references/wiki.md)

### Service Connections
デプロイメント用のサービス接続設定。
詳細: [references/service-connections.md](references/service-connections.md)

## Common Workflows

### ワークアイテムの日常管理
```bash
# アクティブなタスクを確認
az boards work-item query --wiql "SELECT [Id],[Title],[State] FROM WorkItems WHERE [Assigned To] = @Me AND [State] <> 'Closed'"

# タスクの状態を更新
az boards work-item update --id {id} --state "In Progress"
```

### PR ワークフロー
```bash
# PR作成
az repos pr create --source-branch feature/xxx --target-branch main --title "Add feature" --auto-complete

# PRにレビュアーを追加
az repos pr reviewer add --id {pr-id} --reviewers user@example.com

# PRをマージ
az repos pr update --id {pr-id} --status completed
```

### パイプライン操作
```bash
# パイプラインを実行
az pipelines run --name "Build-Pipeline" --branch main

# 実行中のビルドを確認
az pipelines build list --status inProgress

# ビルドログを取得
az pipelines build logs --build-id {id}
```

## Tips

- `--output table` で見やすい表形式出力
- `--output json | jq` で JSON 加工
- `--query` で JMESPath フィルタリング
- 環境変数 `AZURE_DEVOPS_EXT_PAT` で PAT 認証

## Windows環境での実行（重要）

**Claude Codeから実行する場合、必ず `cmd.exe /c` 経由で実行すること。**

Bash シェルから直接 `az` コマンドを実行すると、出力が正しくキャプチャされない問題があります。

```bash
# 正しい実行方法
cmd.exe /c "az devops project list --output table"
cmd.exe /c "az boards work-item show --id 123"
cmd.exe /c "az pipelines run --name Build-Pipeline"

# 誤った実行方法（出力が取得できない）
az devops project list --output table
```

すべての `az` コマンドは以下の形式で実行してください：
```bash
cmd.exe /c "az <command> <arguments>"
```
