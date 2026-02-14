# Pull Requests & Repository Reference

## Table of Contents

- [PR CLI Operations](#pr-cli-operations)
- [Repository Operations](#repository-operations)
- [Common Patterns](#common-patterns)
- [MCP Alternative (Optional)](#mcp-alternative-optional)

## PR CLI Operations

### Create PR

```bash
# Basic
az repos pr create \
  --source-branch "feature/login" \
  --target-branch "main" \
  --title "Add login feature" \
  --description "Implement user authentication"

# With reviewers and work item link
az repos pr create \
  --source-branch "feature/login" \
  --target-branch "main" \
  --title "Add login feature" \
  --description "Implement user authentication" \
  --reviewers "reviewer1@example.com" "reviewer2@example.com" \
  --work-items 123 456

# Auto-complete enabled
az repos pr create \
  --source-branch "feature/login" \
  --target-branch "main" \
  --title "Add login feature" \
  --auto-complete true \
  --merge-commit-message "Merge: Add login feature" \
  --delete-source-branch true
```

### List PRs

```bash
# Active PRs
az repos pr list --status active --output table

# My PRs
az repos pr list --creator "user@example.com" --status active --output table

# PRs assigned to me for review
az repos pr list --reviewer "user@example.com" --status active --output table

# PRs targeting specific branch
az repos pr list --target-branch "main" --status active --output table

# Specific repository
az repos pr list --repository "my-repo" --status active --output table
```

### Show PR Details

```bash
az repos pr show --id 42 --output json
```

### Update PR

```bash
# Update title/description
az repos pr update --id 42 --title "Updated title" --description "Updated description"

# Set auto-complete
az repos pr update --id 42 --auto-complete true --delete-source-branch true

# Set to draft
az repos pr update --id 42 --draft true

# Mark as ready
az repos pr update --id 42 --draft false

# Set merge strategy (squash)
az repos pr update --id 42 --squash true

# Complete (merge) PR
az repos pr update --id 42 --status completed
```

### Review & Vote

```bash
# Approve
az repos pr set-vote --id 42 --vote approve

# Approve with suggestions
az repos pr set-vote --id 42 --vote approve-with-suggestions

# Wait for author
az repos pr set-vote --id 42 --vote wait-for-author

# Reject
az repos pr set-vote --id 42 --vote reject

# Reset vote
az repos pr set-vote --id 42 --vote reset
```

Vote values: `approve` (10), `approve-with-suggestions` (5), `no-vote` (0), `wait-for-author` (-5), `reject` (-10)

### PR Reviewers

```bash
# Add reviewer
az repos pr reviewer add --id 42 --reviewers "user@example.com"

# List reviewers
az repos pr reviewer list --id 42 --output table

# Remove reviewer
az repos pr reviewer remove --id 42 --reviewers "user@example.com"
```

### PR Work Items

```bash
# Link work item to PR
az repos pr work-item add --id 42 --work-items 123

# List linked work items
az repos pr work-item list --id 42 --output table

# Remove link
az repos pr work-item remove --id 42 --work-items 123
```

### Checkout PR Locally

```bash
az repos pr checkout --id 42
```

## Repository Operations

```bash
# List repos
az repos list --output table

# Show repo details
az repos show --repository "my-repo"

# Create repo
az repos create --name "new-repo"

# List branches
az repos ref list --repository "my-repo" --filter heads/ --output table

# Delete branch
az repos ref delete --name "refs/heads/old-branch" --repository "my-repo" --object-id {COMMIT_SHA}
```

## Common Patterns

### PR Summary Report

```bash
# Active PRs aging report (JSON processing)
az repos pr list --status active --output json \
  --query "[].{ID:pullRequestId, Title:title, Author:createdBy.displayName, Created:creationDate, Reviewers:reviewers[].displayName}"
```

### Create PR from Current Branch

```bash
current_branch=$(git rev-parse --abbrev-ref HEAD)
az repos pr create \
  --source-branch "$current_branch" \
  --target-branch "main" \
  --title "$(git log -1 --format=%s)" \
  --description "$(git log -1 --format=%b)" \
  --open
```

### Find PRs Without Reviews

```bash
az repos pr list --status active --output json \
  --query "[?length(reviewers)==\`0\`].{ID:pullRequestId, Title:title}"
```

## MCP Alternative (Optional)

MCP Server (`@azure-devops/mcp`) が設定済みの場合、以下のツールも利用可能。

**PR:**

| Operation | MCP Tool |
|-----------|----------|
| Create PR | `mcp_ado_repos_create_pull_request` |
| Get PR | `mcp_ado_repos_get_pull_request` |
| Update PR | `mcp_ado_repos_update_pull_request` |
| List PRs | `mcp_ado_repos_list_pull_requests` |
| PR comments | `mcp_ado_repos_get_pull_request_comments` / `create_pull_request_comment` |
| PR diff | `mcp_ado_repos_get_pull_request_diff` |

**Repository:**

| Operation | MCP Tool |
|-----------|----------|
| List repos | `mcp_ado_repos_list_repositories` |
| File content | `mcp_ado_repos_get_file_content` |
| Browse | `mcp_ado_repos_browse_repository` |
| Branches | `mcp_ado_repos_list_branches` |
| Commits | `mcp_ado_repos_list_commits` |
| Code search | `mcp_ado_search_code` |
