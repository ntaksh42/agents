# Azure Boards CLI Reference

## Table of Contents
- [Work Items](#work-items)
- [WIQL Queries](#wiql-queries)
- [Work Item Relations](#work-item-relations)
- [Areas and Iterations](#areas-and-iterations)

## Work Items

### 作成
```bash
# 基本的なワークアイテム作成
az boards work-item create \
  --type "Task" \
  --title "Task title"

# 詳細を指定して作成
az boards work-item create \
  --type "User Story" \
  --title "User story title" \
  --description "Description text" \
  --assigned-to "user@example.com" \
  --area "Project\\Area" \
  --iteration "Project\\Sprint 1"

# フィールドを指定して作成
az boards work-item create \
  --type "Bug" \
  --title "Bug title" \
  --fields "System.Tags=critical;System.Priority=1"
```

### 参照・更新
```bash
# ワークアイテム詳細
az boards work-item show --id {id}

# 特定フィールドのみ取得
az boards work-item show --id {id} --fields "System.Title,System.State"

# ワークアイテム更新
az boards work-item update --id {id} --title "New title"
az boards work-item update --id {id} --state "In Progress"
az boards work-item update --id {id} --assigned-to "user@example.com"

# 複数フィールドを更新
az boards work-item update \
  --id {id} \
  --fields "System.State=Done;System.Reason=Completed"

# ディスカッション（コメント）追加
az boards work-item update --id {id} --discussion "Comment text"
```

### 削除
```bash
# ワークアイテム削除（ゴミ箱へ）
az boards work-item delete --id {id} --yes

# 完全削除
az boards work-item delete --id {id} --destroy --yes
```

## WIQL Queries

### 基本クエリ
```bash
# アクティブなワークアイテム
az boards work-item query \
  --wiql "SELECT [Id],[Title],[State] FROM WorkItems WHERE [State] = 'Active'"

# 自分に割り当てられたタスク
az boards work-item query \
  --wiql "SELECT [Id],[Title] FROM WorkItems WHERE [Assigned To] = @Me AND [Work Item Type] = 'Task'"

# 特定イテレーションのアイテム
az boards work-item query \
  --wiql "SELECT [Id],[Title] FROM WorkItems WHERE [Iteration Path] UNDER 'Project\\Sprint 1'"

# 最近変更されたアイテム
az boards work-item query \
  --wiql "SELECT [Id],[Title] FROM WorkItems WHERE [Changed Date] > @Today - 7 ORDER BY [Changed Date] DESC"
```

### 複合条件クエリ
```bash
# 未完了のバグ（優先度高）
az boards work-item query \
  --wiql "SELECT [Id],[Title],[Priority] FROM WorkItems WHERE [Work Item Type] = 'Bug' AND [State] <> 'Closed' AND [Priority] <= 2"

# タグでフィルタ
az boards work-item query \
  --wiql "SELECT [Id],[Title] FROM WorkItems WHERE [Tags] CONTAINS 'urgent'"

# エリアパスでフィルタ
az boards work-item query \
  --wiql "SELECT [Id],[Title] FROM WorkItems WHERE [Area Path] UNDER 'Project\\Team A'"
```

### 保存済みクエリ
```bash
# クエリ一覧
az boards query list --output table

# クエリ実行
az boards query show --id {query-id}
```

## Work Item Relations

```bash
# 関連アイテム追加（親子関係）
az boards work-item relation add \
  --id {id} \
  --relation-type "Parent" \
  --target-id {parent-id}

# 関連リンク追加
az boards work-item relation add \
  --id {id} \
  --relation-type "Related" \
  --target-id {related-id}

# ハイパーリンク追加
az boards work-item relation add \
  --id {id} \
  --relation-type "Hyperlink" \
  --target-url "https://example.com"

# 関連削除
az boards work-item relation remove \
  --id {id} \
  --relation-type "Related" \
  --target-id {related-id}

# 関連一覧表示
az boards work-item show --id {id} --expand Relations
```

### 関連タイプ
- `Parent` / `Child` - 親子関係
- `Related` - 関連
- `Predecessor` / `Successor` - 前後関係
- `Duplicate` / `Duplicate Of` - 重複
- `Tested By` / `Tests` - テスト関係

## Areas and Iterations

### エリア
```bash
# エリア一覧
az boards area project list --output table

# エリア作成
az boards area project create --name "New Area"

# 子エリア作成
az boards area project create --name "Sub Area" --path "\\Project\\Parent Area"

# エリア削除
az boards area project delete --path "\\Project\\Area" --yes
```

### イテレーション
```bash
# イテレーション一覧
az boards iteration project list --output table

# イテレーション作成
az boards iteration project create \
  --name "Sprint 1" \
  --start-date "2024-01-01" \
  --finish-date "2024-01-14"

# 子イテレーション作成
az boards iteration project create \
  --name "Sprint 2" \
  --path "\\Project\\Release 1"

# チームイテレーション設定
az boards iteration team add \
  --team {team-name} \
  --id {iteration-id}

# イテレーション削除
az boards iteration project delete --path "\\Project\\Sprint 1" --yes
```

## Work Item Types

```bash
# ワークアイテムタイプ一覧
az boards work-item type list --output table

# タイプ詳細（フィールド情報）
az boards work-item type show --type "Task"
```
