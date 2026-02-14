---
name: ado-operation
description: "Azure DevOps operations via Azure CLI. Use for Work Item management (create, update, query, link), Pull Request operations (create, review, vote, merge), Pipeline management (run, monitor, logs), and repository operations. Triggers on: Azure DevOps, work item, PR, pipeline, sprint, backlog, boards, repos, WIQL queries."
dependencies: "Azure CLI >= 2.50 with azure-devops extension"
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - WebFetch
---

# Azure DevOps Operations

Azure CLI (`az devops`) を主軸に Azure DevOps を操作するスキル。
専用コマンドがない操作は `az devops invoke` (REST API ラッパー) で補完する。

## IMPORTANT: Windows 日本語文字化け防止

Azure CLI (MSI版) は内蔵 Python を `-I` (isolated mode) で起動するため、
`PYTHONUTF8=1` や `PYTHONIOENCODING` 等の環境変数は**無効**。
出力は常に cp932 (Shift-JIS) となるため、**全ての `az` コマンドの末尾に
`2>&1 | iconv -f cp932 -t utf-8` を付与すること。**

```bash
# NG: 日本語が文字化けする
az boards work-item show --id 123 --output table

# OK: iconv で UTF-8 に変換
az boards work-item show --id 123 --output table 2>&1 | iconv -f cp932 -t utf-8
```

このルールは本スキル内の全コマンドに適用する。

## コマンド体系

| レイヤー | コマンド | 用途 |
|---------|---------|------|
| Work Items | `az boards work-item` / `az boards query` | CRUD, WIQL クエリ |
| Pull Requests | `az repos pr` | 作成, レビュー, 投票, マージ |
| Repositories | `az repos` / `az repos ref` | リポジトリ管理, ブランチ管理 |
| Pipelines | `az pipelines` / `az pipelines build` | 実行, 監視, 変数管理 |
| REST API 補完 | `az devops invoke` | 上記で対応できない操作全般 |

### `az devops invoke` が必要な操作

以下は専用コマンドがないため `az devops invoke` で対応する:

- **PR コメント・スレッド** -- 取得・追加・インラインコメント・ステータス更新
- **ビルドタイムライン** -- ステージ・ジョブ・タスクの詳細と失敗箇所特定
- **テスト結果** -- テスト実行結果・失敗テストの詳細
- **添付ファイル** -- Work Item への添付アップロード・リンク
- **Git 差分** -- コミット間差分・PR 変更ファイル一覧
- **通知** -- サブスクリプション管理

詳細は [references/rest-api.md](references/rest-api.md) を参照。

### MCP (オプション)

Azure DevOps MCP Server (`@azure-devops/mcp`) が設定済みの場合、MCP ツールも利用可能。
機能的に CLI と同等だが、構造化データを直接取得できるため効率的な場合がある。

MCP セットアップ: `~/.claude/settings.json` の `mcpServers` に追加:
```json
"azure-devops": {
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@azure-devops/mcp", "{ORG_NAME}"]
}
```

## Prerequisites

```bash
# Login check
az account show 2>&1 | iconv -f cp932 -t utf-8

# DevOps extension check
az extension show --name azure-devops 2>&1 | iconv -f cp932 -t utf-8

# Organization default setting (recommend)
az devops configure --defaults organization=https://dev.azure.com/{ORG}
az devops configure --defaults project={PROJECT}
```

## Core Workflow

### 1. Work Items

詳細は [references/work-items.md](references/work-items.md) を参照。

```bash
# 作成
az boards work-item create --type "Task" --title "タスク名" \
  --assigned-to "user@example.com" --description "詳細" 2>&1 | iconv -f cp932 -t utf-8

# 表示
az boards work-item show --id {ID} --output table 2>&1 | iconv -f cp932 -t utf-8

# 更新
az boards work-item update --id {ID} --state "Active" \
  --assigned-to "user@example.com" 2>&1 | iconv -f cp932 -t utf-8

# WIQL クエリ
az boards query --wiql "SELECT [System.Id], [System.Title], [System.State] \
  FROM WorkItems WHERE [System.AssignedTo] = @Me \
  AND [System.State] <> 'Closed' \
  ORDER BY [System.ChangedDate] DESC" --output table 2>&1 | iconv -f cp932 -t utf-8
```

### 2. Pull Requests

詳細は [references/pull-requests.md](references/pull-requests.md) を参照。

```bash
# PR 作成
az repos pr create --source-branch "feature/xxx" --target-branch "main" \
  --title "タイトル" --description "説明" 2>&1 | iconv -f cp932 -t utf-8

# PR 一覧
az repos pr list --status active --output table 2>&1 | iconv -f cp932 -t utf-8

# レビュー投票 (approve=10, approve-with-suggestions=5, wait-for-author=-5, reject=-10)
az repos pr set-vote --id {PR_ID} --vote approve 2>&1 | iconv -f cp932 -t utf-8

# PR コメント取得 (az devops invoke)
# NOTE: --resource には REST API パス名ではなく CLI 内部の resource 名を使う
az devops invoke --area git --resource pullRequestThreads \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} pullRequestId={PR_ID} \
  --http-method GET --api-version "7.1" 2>&1 | iconv -f cp932 -t utf-8
```

### 3. Pipelines

詳細は [references/pipelines.md](references/pipelines.md) を参照。

```bash
# パイプライン一覧
az pipelines list --output table 2>&1 | iconv -f cp932 -t utf-8

# 実行
az pipelines run --name "pipeline-name" --branch "main" 2>&1 | iconv -f cp932 -t utf-8

# ビルド状態確認
az pipelines build show --id {BUILD_ID} --output table 2>&1 | iconv -f cp932 -t utf-8

# ビルドタイムライン (az devops invoke)
az devops invoke --area build --resource timeline \
  --route-parameters project={PROJECT} buildId={BUILD_ID} \
  --api-version "7.1" 2>&1 | iconv -f cp932 -t utf-8
```

### 4. Repository Operations

```bash
# リポジトリ一覧
az repos list --output table 2>&1 | iconv -f cp932 -t utf-8

# ブランチ一覧
az repos ref list --repository {REPO} --filter heads/ --output table 2>&1 | iconv -f cp932 -t utf-8
```

## `az devops invoke` クイックリファレンス

**重要**: `--resource` には REST API URL のパスセグメント名ではなく、
CLI 内部に登録された resource 名（通常 camelCase）を指定すること。
誤った resource 名を指定すると `--resource and --api-version combination is not correct`
という**誤解を招くエラー**が発生する（api-version ではなく resource 名が原因）。

```bash
# 基本構文
az devops invoke --area {area} --resource {resource} \
  --route-parameters {key=value ...} \
  --http-method {GET|POST|PATCH|DELETE} \
  --in-file {body.json} \
  --api-version "7.1" 2>&1 | iconv -f cp932 -t utf-8

# 利用可能な area/resource を確認（resource名が不明な場合は必ず実行）
az devops invoke --query "[?area=='{area}'].{Area:area, Resource:resourceName}" \
  --output table 2>&1 | iconv -f cp932 -t utf-8
```

### よく使う resource 名マッピング

| 目的 | area | resource (正しい名前) |
|------|------|----------------------|
| PR スレッド取得・追加 | git | `pullRequestThreads` |
| PR スレッド内コメント | git | `pullRequestThreadComments` |
| PR イテレーション | git | `pullRequestIterations` |
| PR イテレーション変更 | git | `pullRequestIterationChanges` |
| コミット間差分 | git | `commitDiffs` |
| ビルドタイムライン | build | `Timeline` |
| ビルドログ | build | `logs` |

## Output Format Tips

- `--output table` で人間が読みやすい表形式
- `--output json` でプログラム処理用
- `--query` で JMESPath フィルタリング（例: `--query "[].{ID:id, Title:fields.\"System.Title\"}"`)

## Error Handling

| エラー | 対処 |
|--------|------|
| `az devops: command not found` | `az extension add --name azure-devops` |
| `TF401019: unauthorized` | `az devops login` で PAT を再設定 |
| `TF200016: project not found` | `--project` パラメータ確認、`az devops configure --defaults project=XXX` |
| `az devops invoke` で area 不明 | `az devops invoke --query "[].{Area:area}"` で確認 |
| `--resource and --api-version combination is not correct` | **resource 名が間違っている**（api-version の問題ではない）。上記マッピング表を参照するか `az devops invoke --query "[?area=='{area}'].resourceName"` で確認 |
| 日本語が文字化け | `2>&1 \| iconv -f cp932 -t utf-8` をパイプ末尾に付与 |
