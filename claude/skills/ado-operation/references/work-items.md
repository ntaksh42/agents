# Work Items Reference

## Table of Contents

- [CLI Operations](#cli-operations)
- [WIQL Query Examples](#wiql-query-examples)
- [Work Item Relations](#work-item-relations)
- [Common Patterns](#common-patterns)
- [MCP Alternative (Optional)](#mcp-alternative-optional)

## CLI Operations

### Create

```bash
# Basic
az boards work-item create --type "Task" --title "タイトル"

# Full options
az boards work-item create \
  --type "User Story" \
  --title "ユーザー登録機能の実装" \
  --assigned-to "dev@example.com" \
  --description "ユーザー登録フォームを実装する" \
  --area "ProjectName\\TeamArea" \
  --iteration "ProjectName\\Sprint 1" \
  --fields "Microsoft.VSTS.Common.Priority=1" "Microsoft.VSTS.Scheduling.StoryPoints=5"
```

Work Item types: `Bug`, `Task`, `User Story`, `Feature`, `Epic`, `Issue`, `Test Case`

### Read

```bash
# Single item
az boards work-item show --id 123 --output json

# Multiple items
az boards work-item show --id 123 456 789

# Specific fields only
az boards work-item show --id 123 --fields "System.Title,System.State,System.AssignedTo"
```

### Update

```bash
# State change
az boards work-item update --id 123 --state "Active"
az boards work-item update --id 123 --state "Resolved"
az boards work-item update --id 123 --state "Closed"

# Multiple fields
az boards work-item update --id 123 \
  --state "Active" \
  --assigned-to "dev@example.com" \
  --fields "Microsoft.VSTS.Common.Priority=2"

# Add discussion comment
az boards work-item update --id 123 --discussion "作業を開始しました"
```

### Delete

```bash
az boards work-item delete --id 123 --yes
```

### Query (WIQL)

```bash
# Inline query
az boards query --wiql "SELECT [System.Id], [System.Title] FROM WorkItems WHERE [System.State] = 'Active'"

# Saved query by ID
az boards query --id "query-guid-here"
```

## WIQL Query Examples

### 自分に割り当てられたアクティブなアイテム

```sql
SELECT [System.Id], [System.Title], [System.State], [System.WorkItemType]
FROM WorkItems
WHERE [System.AssignedTo] = @Me
  AND [System.State] <> 'Closed'
  AND [System.State] <> 'Removed'
ORDER BY [Microsoft.VSTS.Common.Priority] ASC, [System.CreatedDate] DESC
```

### 現在のスプリントのアイテム

```sql
SELECT [System.Id], [System.Title], [System.State], [System.AssignedTo]
FROM WorkItems
WHERE [System.IterationPath] = @CurrentIteration
  AND [System.WorkItemType] IN ('User Story', 'Bug', 'Task')
ORDER BY [Microsoft.VSTS.Common.StackRank] ASC
```

### 未完了バグ（優先度順）

```sql
SELECT [System.Id], [System.Title], [System.State], [Microsoft.VSTS.Common.Priority]
FROM WorkItems
WHERE [System.WorkItemType] = 'Bug'
  AND [System.State] IN ('New', 'Active')
ORDER BY [Microsoft.VSTS.Common.Priority] ASC
```

### 最近更新されたアイテム（過去7日）

```sql
SELECT [System.Id], [System.Title], [System.State], [System.ChangedDate]
FROM WorkItems
WHERE [System.ChangedDate] >= @Today - 7
  AND [System.TeamProject] = @Project
ORDER BY [System.ChangedDate] DESC
```

### 親子関係クエリ（Tree）

```sql
SELECT [System.Id], [System.Title], [System.State]
FROM WorkItemLinks
WHERE [Source].[System.WorkItemType] = 'Feature'
  AND [Target].[System.WorkItemType] IN ('User Story', 'Bug')
  AND [Target].[System.State] <> 'Closed'
MODE (Recursive)
```

## Work Item Relations

```bash
# Add parent-child relation
az boards work-item relation add --id 456 --relation-type "parent" --target-id 123

# Add related link
az boards work-item relation add --id 123 --relation-type "Related" --target-id 456

# Remove relation
az boards work-item relation remove --id 123 --relation-type "parent" --target-id 456 --yes
```

Relation types: `parent`, `child`, `Related`, `Duplicate`, `Successor`, `Predecessor`

## Common Patterns

### Bulk Status Update

```bash
# Query IDs then update in loop
for id in $(az boards query --wiql "SELECT [System.Id] FROM WorkItems WHERE [System.State] = 'New' AND [System.AssignedTo] = @Me" --query "[].id" -o tsv); do
  az boards work-item update --id $id --state "Active"
done
```

### Sprint Planning: List Unestimated Stories

```sql
SELECT [System.Id], [System.Title]
FROM WorkItems
WHERE [System.WorkItemType] = 'User Story'
  AND [System.IterationPath] = @CurrentIteration
  AND [Microsoft.VSTS.Scheduling.StoryPoints] = ''
```

## MCP Alternative (Optional)

MCP Server (`@azure-devops/mcp`) が設定済みの場合、以下のツールも利用可能。
CLI と機能同等だが、構造化レスポンスを直接取得できる。

| Operation | MCP Tool |
|-----------|----------|
| Get | `mcp_ado_workitems_get_work_item` |
| Create | `mcp_ado_workitems_create_work_item` |
| Update | `mcp_ado_workitems_update_work_item` |
| Query | `mcp_ado_workitems_run_wiql_query` |
| Search | `mcp_ado_search_workitem` |
| Links | `mcp_ado_workitems_manage_work_item_link` |
| Tags | `mcp_ado_workitems_manage_work_item_tags` |
| Comments | `mcp_ado_workitems_get_work_item_comments` / `add_work_item_comment` |
| History | `mcp_ado_workitems_get_work_item_updates` |
