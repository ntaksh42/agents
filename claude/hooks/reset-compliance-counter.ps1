# reset-compliance-counter.ps1
# Claude Code UserPromptSubmit Hook - Reset compliance check counter
# Resets the violation counter when the user submits a new prompt

# Read stdin JSON
$rawInput = @($input) -join ""

try {
    $hookInput = $rawInput | ConvertFrom-Json
} catch {
    exit 0
}

$sessionId = $hookInput.session_id

if (-not $sessionId) {
    exit 0
}

# Delete the state file for this session (resets counter)
$stateFile = Join-Path $env:TEMP "claude-hook-state-$sessionId.json"
if (Test-Path $stateFile) {
    Remove-Item $stateFile -Force -ErrorAction SilentlyContinue
}

# Cleanup old state files (>24h)
try {
    $cutoff = (Get-Date).AddHours(-24)
    Get-ChildItem -Path $env:TEMP -Filter "claude-hook-state-*.json" -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt $cutoff } |
        Remove-Item -Force -ErrorAction SilentlyContinue
} catch {
    # Ignore cleanup errors
}

exit 0
