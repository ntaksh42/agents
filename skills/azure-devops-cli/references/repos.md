# Azure Repos CLI Reference

## Table of Contents
- [Repository Management](#repository-management)
- [Branch Management](#branch-management)
- [Pull Requests](#pull-requests)
- [Branch Policies](#branch-policies)

## Repository Management

```bash
# リポジトリ一覧
az repos list --output table

# リポジトリ詳細
az repos show --repository {repo-name}

# リポジトリ作成
az repos create --name {repo-name}

# リポジトリ削除
az repos delete --id {repo-id} --yes

# リポジトリをクローン（URL取得）
az repos show --repository {repo-name} --query remoteUrl
```

## Branch Management

```bash
# ブランチ一覧
az repos ref list --repository {repo} --filter heads/

# ブランチ作成
az repos ref create --name heads/{branch-name} --repository {repo} --object-id {commit-sha}

# ブランチ削除
az repos ref delete --name heads/{branch-name} --repository {repo} --object-id {commit-sha}

# デフォルトブランチ設定
az repos update --repository {repo} --default-branch {branch}
```

## Pull Requests

### PR 作成
```bash
# 基本的なPR作成
az repos pr create \
  --repository {repo} \
  --source-branch {source} \
  --target-branch {target} \
  --title "PR Title" \
  --description "Description"

# 自動完了を有効にしてPR作成
az repos pr create \
  --source-branch {source} \
  --target-branch main \
  --auto-complete \
  --delete-source-branch \
  --squash

# ドラフトPR作成
az repos pr create \
  --source-branch {source} \
  --target-branch main \
  --draft
```

### PR 操作
```bash
# PR一覧
az repos pr list --status active --output table

# 自分がレビュアーのPR
az repos pr list --reviewer {email}

# PR詳細
az repos pr show --id {pr-id}

# PR更新（タイトル、説明）
az repos pr update --id {pr-id} --title "New Title" --description "Updated description"

# PRをマージ
az repos pr update --id {pr-id} --status completed

# PRを放棄
az repos pr update --id {pr-id} --status abandoned

# PRをドラフトから公開
az repos pr update --id {pr-id} --draft false
```

### レビュアー管理
```bash
# レビュアー追加
az repos pr reviewer add --id {pr-id} --reviewers user@example.com

# レビュアー一覧
az repos pr reviewer list --id {pr-id}

# レビュアー削除
az repos pr reviewer remove --id {pr-id} --reviewers user@example.com
```

### PR コメント
```bash
# コメント一覧
az repos pr thread list --id {pr-id}

# コメント追加（全体）
az repos pr thread create --id {pr-id} --body "Comment text"

# ファイルへのコメント
az repos pr thread create \
  --id {pr-id} \
  --body "Comment on code" \
  --file-path "src/main.py" \
  --line 42 \
  --line-offset 0
```

### ワークアイテムリンク
```bash
# PRにワークアイテムをリンク
az repos pr work-item add --id {pr-id} --work-items {work-item-id}

# リンクされたワークアイテム一覧
az repos pr work-item list --id {pr-id}
```

## Branch Policies

```bash
# ポリシー一覧
az repos policy list --repository {repo} --branch main

# 最小レビュアー数ポリシー作成
az repos policy approver-count create \
  --repository-id {repo-id} \
  --branch main \
  --minimum-approver-count 2 \
  --creator-vote-counts false \
  --allow-downvotes false \
  --reset-on-source-push true \
  --blocking true \
  --enabled true

# ビルド検証ポリシー作成
az repos policy build create \
  --repository-id {repo-id} \
  --branch main \
  --build-definition-id {pipeline-id} \
  --display-name "Build Validation" \
  --blocking true \
  --enabled true \
  --queue-on-source-update-only false

# ポリシー削除
az repos policy delete --id {policy-id} --yes
```

## Import Repository

```bash
# Git URLからインポート
az repos import create \
  --repository {new-repo-name} \
  --git-url https://github.com/org/repo.git
```
