# Claude Code Status Line Script
# Displays: repository_name (branch) | model | context%

# ANSI escape code (compatible with Windows PowerShell 5.1)
$esc = [char]27

# Read JSON input from stdin
$jsonInput = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Get current directory from input
$cwd = $jsonInput.workspace.current_dir

# Build output array
$output = @()

# Get repository name and branch from git
$repoName = $null
$branchName = $null
if ($cwd -and (Test-Path $cwd)) {
    Push-Location $cwd
    $repoName = git rev-parse --show-toplevel 2>$null
    if ($repoName) {
        $repoName = Split-Path -Leaf $repoName
        $branchName = git branch --show-current 2>$null
    }
    Pop-Location
}

# Add repository name and branch in cyan (or directory name if not a git repo)
if ($repoName) {
    if ($branchName) {
        $output += "$esc[36m${repoName} (${branchName})$esc[0m"
    } else {
        $output += "$esc[36m${repoName}$esc[0m"
    }
} elseif ($cwd) {
    $dirName = Split-Path -Leaf $cwd
    $output += "$esc[36m${dirName}$esc[0m"
}

# Add model name in green
$model = $jsonInput.model
if ($model) {
    # Handle model as object or string
    if ($model.id) {
        $modelName = $model.id
    } elseif ($model.display_name) {
        $modelName = $model.display_name
    } else {
        $modelName = $model.ToString()
    }
    $output += "$esc[32m${modelName}$esc[0m"
}

# Calculate context window usage
$contextWindow = $jsonInput.context_window
if ($contextWindow -and $contextWindow.current_usage) {
    $currentUsage = $contextWindow.current_usage
    $currentTokens = 0
    if ($currentUsage.input_tokens) { $currentTokens += $currentUsage.input_tokens }
    if ($currentUsage.cache_creation_input_tokens) { $currentTokens += $currentUsage.cache_creation_input_tokens }
    if ($currentUsage.cache_read_input_tokens) { $currentTokens += $currentUsage.cache_read_input_tokens }
    $totalSize = $contextWindow.context_window_size

    if ($totalSize -gt 0) {
        $percentage = [math]::Round(($currentTokens / $totalSize) * 100)
        $output += "$esc[35m${percentage}%$esc[0m"
    }
}

# Output the status line with separator
if ($output.Count -gt 0) {
    Write-Host ($output -join ' | ')
}
