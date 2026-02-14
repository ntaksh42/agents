# Azure DevOps REST API Reference (`az devops invoke`)

専用コマンド (`az boards`, `az repos pr`, `az pipelines`) で対応できない操作を
`az devops invoke` で補完する。認証は `az login` を自動利用。

## Table of Contents

- [az devops invoke 基本構文](#az-devops-invoke-基本構文)
- [PR Threads & Comments](#pr-threads--comments)
- [Work Item Attachments](#work-item-attachments)
- [Build Timeline & Stages](#build-timeline--stages)
- [Test Results](#test-results)
- [Git Diffs & Changes](#git-diffs--changes)
- [Notifications & Subscriptions](#notifications--subscriptions)

## az devops invoke 基本構文

```bash
# GET
az devops invoke --area {area} --resource {resource} \
  --route-parameters {key=value ...} \
  --api-version "7.1"

# POST (JSON body)
az devops invoke --area {area} --resource {resource} \
  --route-parameters {key=value ...} \
  --http-method POST \
  --in-file body.json \
  --api-version "7.1"

# PATCH
az devops invoke --area {area} --resource {resource} \
  --route-parameters {key=value ...} \
  --http-method PATCH \
  --in-file body.json \
  --api-version "7.1"

# Query parameters (filter等)
az devops invoke --area {area} --resource {resource} \
  --route-parameters {key=value ...} \
  --query-parameters "key1=value1" "key2=value2" \
  --api-version "7.1"

# 利用可能な area/resource の確認
az devops invoke --query "[].{Area:area, Resource:resourceName}" --output table
```

常に `--api-version "7.1"` を使用すること。
resource 名が不明な場合は必ず事前に確認する。

**重要**: `--resource` には REST API URL のパスセグメント名ではなく、
CLI 内部に登録された resource 名（通常 camelCase）を指定すること。
誤った resource 名を指定すると `--resource and --api-version combination is not correct`
という**誤解を招くエラー**が発生する（実際は resource 名が原因）。

## PR Threads & Comments

CLI では PR のコメントスレッド取得・追加ができないため `az devops invoke` で対応。

### スレッド一覧取得

```bash
az devops invoke --area git --resource pullRequestThreads \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} pullRequestId={PR_ID} \
  --api-version "7.1"
```

### コメント追加

```bash
cat > /tmp/comment.json << 'EOF'
{
  "comments": [
    {
      "parentCommentId": 0,
      "content": "コメント内容をここに記述",
      "commentType": "text"
    }
  ],
  "status": "active"
}
EOF

az devops invoke --area git --resource pullRequestThreads \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} pullRequestId={PR_ID} \
  --http-method POST \
  --in-file /tmp/comment.json \
  --api-version "7.1"
```

### インラインコメント（特定ファイル・行）

```bash
cat > /tmp/inline_comment.json << 'EOF'
{
  "comments": [
    {
      "parentCommentId": 0,
      "content": "この行を修正してください",
      "commentType": "text"
    }
  ],
  "status": "active",
  "threadContext": {
    "filePath": "/src/main.py",
    "rightFileStart": { "line": 10, "offset": 1 },
    "rightFileEnd": { "line": 10, "offset": 50 }
  }
}
EOF

az devops invoke --area git --resource pullRequestThreads \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} pullRequestId={PR_ID} \
  --http-method POST \
  --in-file /tmp/inline_comment.json \
  --api-version "7.1"
```

### スレッドのステータス更新

```bash
# Status values: active, fixed, wontFix, closed, byDesign, pending
cat > /tmp/update_thread.json << 'EOF'
{
  "status": "fixed"
}
EOF

az devops invoke --area git --resource pullRequestThreads \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} pullRequestId={PR_ID} threadId={THREAD_ID} \
  --http-method PATCH \
  --in-file /tmp/update_thread.json \
  --api-version "7.1"
```

## Work Item Attachments

### 添付ファイルのアップロード

> **注意**: `az devops invoke` は `--in-file` を JSON としてパースするため、
> バイナリ/テキストファイルのアップロードには使用できない。
> PAT 認証の curl を使用すること。

```bash
# Step 1: Upload attachment (curl + PAT)
curl -s -u ":${AZURE_DEVOPS_PAT}" \
  -X POST \
  -H "Content-Type: application/octet-stream" \
  --data-binary @"path/to/file.pdf" \
  "https://dev.azure.com/{ORG}/{PROJECT}/_apis/wit/attachments?fileName=file.pdf&api-version=7.1"
# Response contains { "url": "https://...attachment-url..." }

# Step 2: Link attachment to work item (JSON Patch - az devops invoke OK)
cat > /tmp/attach.json << 'EOF'
[
  {
    "op": "add",
    "path": "/relations/-",
    "value": {
      "rel": "AttachedFile",
      "url": "{ATTACHMENT_URL_FROM_STEP1}",
      "attributes": { "comment": "添付ファイル説明" }
    }
  }
]
EOF

az devops invoke --area wit --resource workitems \
  --route-parameters id={WORK_ITEM_ID} \
  --http-method PATCH \
  --in-file /tmp/attach.json \
  --api-version "7.1" 2>&1 | iconv -f cp932 -t utf-8
```

### 添付ファイル一覧取得

```bash
# Work Item の relations から AttachedFile を抽出
az boards work-item show --id {ID} --output json \
  --query "relations[?rel=='AttachedFile'].{Name:attributes.name, URL:url}"
```

## Build Timeline & Stages

CLI では取得できないビルドの詳細タイムライン（ステージ・ジョブ・タスク）。

### タイムライン取得

```bash
az devops invoke --area build --resource timeline \
  --route-parameters project={PROJECT} buildId={BUILD_ID} \
  --api-version "7.1"
```

### 失敗タスクのフィルタリング

```bash
# JSON出力 + --query で失敗タスクを抽出
az devops invoke --area build --resource timeline \
  --route-parameters project={PROJECT} buildId={BUILD_ID} \
  --api-version "7.1" \
  --query "records[?result=='failed'].{Name:name, Type:type, Result:result, Log:log}"
```

### ビルドログ（特定タスク）

```bash
az devops invoke --area build --resource logs \
  --route-parameters project={PROJECT} buildId={BUILD_ID} logId={LOG_ID} \
  --api-version "7.1"
```

## Test Results

> **注意**: `test` area の resource (`runs`, `results` 等) は `az devops invoke` では
> 正常に動作しない場合がある（resource 未登録・404 エラー）。
> テスト結果の取得には PAT 認証での直接 REST API 呼び出しを使用すること。

```bash
# PAT を環境変数に設定（未設定の場合）
# export AZURE_DEVOPS_PAT="your-personal-access-token"
```

### テスト実行一覧

```bash
curl -s -u ":${AZURE_DEVOPS_PAT}" \
  "https://dev.azure.com/{ORG}/{PROJECT}/_apis/test/runs?minLastUpdatedDate={START_DATE}&maxLastUpdatedDate={END_DATE}&api-version=7.1"
```

### 特定テスト実行の結果

```bash
curl -s -u ":${AZURE_DEVOPS_PAT}" \
  "https://dev.azure.com/{ORG}/{PROJECT}/_apis/test/runs/{RUN_ID}/results?api-version=7.1"
```

### 失敗テストのみ取得

```bash
curl -s -u ":${AZURE_DEVOPS_PAT}" \
  "https://dev.azure.com/{ORG}/{PROJECT}/_apis/test/runs/{RUN_ID}/results?\$filter=outcome%20eq%20'Failed'&api-version=7.1"
```

### ビルドに関連するテスト結果

```bash
curl -s -u ":${AZURE_DEVOPS_PAT}" \
  "https://dev.azure.com/{ORG}/{PROJECT}/_apis/test/runs?buildIds={BUILD_ID}&api-version=7.1"
```

## Git Diffs & Changes

### コミット間の差分

```bash
az devops invoke --area git --resource commitDiffs \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} \
  --query-parameters "baseVersion={BASE_COMMIT}" "targetVersion={TARGET_COMMIT}" \
  --http-method GET --api-version "7.1"
```

### PR の変更ファイル一覧

```bash
az devops invoke --area git --resource pullRequestIterationChanges \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} pullRequestId={PR_ID} iterationId={ITERATION_ID} \
  --http-method GET --api-version "7.1"
```

### PR のイテレーション（プッシュ履歴）

```bash
az devops invoke --area git --resource pullRequestIterations \
  --route-parameters project={PROJECT} repositoryId={REPO_ID} pullRequestId={PR_ID} \
  --http-method GET --api-version "7.1"
```

## Notifications & Subscriptions

> **注意**: `notification` area は organization によっては `az devops invoke` で利用できない
> 場合がある（`--area is not present in current organization` エラー）。
> その場合は `az rest` による直接 REST API 呼び出しを使用すること。

### サブスクリプション一覧

```bash
# az devops invoke で利用可能な場合
az devops invoke --area notification --resource Subscriptions \
  --http-method GET --api-version "7.1" 2>&1 | iconv -f cp932 -t utf-8

# 上記がエラーの場合は PAT 認証で直接 API 呼び出し
curl -s -u ":${AZURE_DEVOPS_PAT}" \
  "https://dev.azure.com/{ORG}/_apis/notification/subscriptions?api-version=7.1"
```
