# Block dangerous commands hook
$rawInput = @($input) -join ""

# 危険なコマンドパターン（完全ブロック）
$blockPatterns = @(
    'git\s+push\s+.*--force',
    'git\s+push\s+-f\b',
    'git\s+reset\s+--hard',
    'rm\s+-rf\s+/',
    'rm\s+-rf\s+\*',
    'rm\s+-rf\s+~',
    'rm\s+-rf\s+\$HOME',
    'rm\s+-rf\s+\.',
    '>\s*/dev/sda',
    'mkfs\.',
    'dd\s+if=.*of=/dev/'
)

# 確認が必要なコマンドパターン
$askPatterns = @(
    'git\s+push\b'
)

# コマンド部分を抽出
if ($rawInput -match '"command"\s*:\s*"([^"]*)"') {
    $command = $matches[1]

    # 完全ブロックチェック
    foreach ($pattern in $blockPatterns) {
        if ($command -match $pattern) {
            $output = @{
                hookSpecificOutput = @{
                    hookEventName = "PreToolUse"
                    permissionDecision = "deny"
                    permissionDecisionReason = "Dangerous command blocked: $pattern"
                }
            } | ConvertTo-Json -Depth 10
            Write-Output $output
            exit 0
        }
    }

    # 確認要求チェック
    foreach ($pattern in $askPatterns) {
        if ($command -match $pattern) {
            $output = @{
                hookSpecificOutput = @{
                    hookEventName = "PreToolUse"
                    permissionDecision = "ask"
                    permissionDecisionReason = "git push requires confirmation. Run manually if preferred."
                }
            } | ConvertTo-Json -Depth 10
            Write-Output $output
            exit 0
        }
    }
}

exit 0
