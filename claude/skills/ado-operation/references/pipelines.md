# Pipelines Reference

## Table of Contents

- [CLI Operations](#cli-operations)
- [Build Monitoring](#build-monitoring)
- [Variables & Variable Groups](#variables--variable-groups)
- [Release Pipelines](#release-pipelines)
- [Common Patterns](#common-patterns)
- [MCP Alternative (Optional)](#mcp-alternative-optional)

## CLI Operations

### List Pipelines

```bash
# All pipelines
az pipelines list --output table

# Filter by name
az pipelines list --name "CI-*" --output table

# In specific folder
az pipelines list --folder-path "\\build" --output table
```

### Show Pipeline Details

```bash
az pipelines show --name "my-pipeline" --output json
az pipelines show --id 42 --output json
```

### Run Pipeline

```bash
# Basic run
az pipelines run --name "my-pipeline"

# Specific branch
az pipelines run --name "my-pipeline" --branch "refs/heads/feature/xxx"

# With parameters
az pipelines run --name "my-pipeline" --parameters "env=staging" "region=eastus"

# With variables
az pipelines run --name "my-pipeline" --variables "buildConfiguration=Release"
```

### Create Pipeline

```bash
az pipelines create \
  --name "new-pipeline" \
  --repository "my-repo" \
  --branch "main" \
  --yml-path "azure-pipelines.yml" \
  --repository-type tfsgit
```

### Update Pipeline

```bash
az pipelines update --id 42 --new-name "renamed-pipeline"
az pipelines update --id 42 --new-folder-path "\\production"
```

### Delete Pipeline

```bash
az pipelines delete --id 42 --yes
```

## Build Monitoring

### List Builds

```bash
# Recent builds
az pipelines build list --output table --top 10

# Builds for specific pipeline
az pipelines build list --definition-ids 42 --output table

# Builds by status
az pipelines build list --status completed --result succeeded --top 5 --output table
az pipelines build list --status completed --result failed --top 5 --output table

# In-progress builds
az pipelines build list --status inProgress --output table
```

### Show Build Details

```bash
az pipelines build show --id 1234 --output json
```

### Pipeline Runs

```bash
# List runs
az pipelines runs list --pipeline-ids 42 --output table --top 10

# Show run
az pipelines runs show --id 5678 --output json
```

### Build Tags

```bash
az pipelines build tag add --build-id 1234 --tags "release-candidate"
az pipelines build tag list --build-id 1234 --output table
```

## Variables & Variable Groups

### Pipeline Variables

```bash
# List variables
az pipelines variable list --pipeline-name "my-pipeline" --output table

# Create variable
az pipelines variable create --pipeline-name "my-pipeline" --name "MY_VAR" --value "my-value"

# Secret variable
az pipelines variable create --pipeline-name "my-pipeline" --name "SECRET_KEY" --value "xxx" --is-secret true

# Update variable
az pipelines variable update --pipeline-name "my-pipeline" --name "MY_VAR" --value "new-value"

# Delete variable
az pipelines variable delete --pipeline-name "my-pipeline" --name "MY_VAR" --yes
```

### Variable Groups

```bash
# List groups
az pipelines variable-group list --output table

# Create group
az pipelines variable-group create --name "my-group" --variables "KEY1=value1" "KEY2=value2"

# Show group
az pipelines variable-group show --id 10 --output json

# Add variable to group
az pipelines variable-group variable create --group-id 10 --name "NEW_VAR" --value "value"
```

## Release Pipelines

```bash
# List release definitions
az pipelines release definition list --output table

# Show release
az pipelines release show --id 100 --output json

# List releases
az pipelines release list --definition-id 5 --output table --top 10

# Create release
az pipelines release create --definition-id 5
```

## Common Patterns

### Check Last Build Status

```bash
az pipelines build list --definition-ids 42 --top 1 --output json \
  --query "[0].{Status:status, Result:result, Source:sourceBranch, Time:finishTime}"
```

### Trigger and Wait for Build

```bash
# Run and get build ID
build_id=$(az pipelines run --name "my-pipeline" --query "id" -o tsv)

# Poll status
while true; do
  status=$(az pipelines build show --id $build_id --query "status" -o tsv)
  echo "Build $build_id: $status"
  if [ "$status" = "completed" ]; then break; fi
  sleep 30
done

# Check result
az pipelines build show --id $build_id --query "{Result:result, Duration:finishTime}" -o json
```

### Find Failed Builds

```bash
az pipelines build list --status completed --result failed --top 10 --output table \
  --query "[].{ID:id, Pipeline:definition.name, Branch:sourceBranch, Time:finishTime}"
```

### Agent Pool Information

```bash
az pipelines pool list --output table
az pipelines agent list --pool-id 1 --output table
```

## MCP Alternative (Optional)

MCP Server (`@azure-devops/mcp`) が設定済みの場合、以下のツールも利用可能。

| Operation | MCP Tool |
|-----------|----------|
| Create | `mcp_ado_pipelines_create_pipeline` |
| Get builds | `mcp_ado_pipelines_get_builds` |
| Build status | `mcp_ado_pipelines_get_build_status` |
| Build log | `mcp_ado_pipelines_get_build_log` |
| Run pipeline | `mcp_ado_pipelines_run_pipeline` |
| List artifacts | `mcp_ado_pipelines_list_artifacts` |
| Download artifact | `mcp_ado_pipelines_download_artifact` |
| Get run details | `mcp_ado_pipelines_get_pipeline_run` |
