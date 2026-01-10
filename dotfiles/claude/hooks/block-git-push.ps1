# Block git push hook
# JSONパースを避け、文字列マッチでgit pushを検出
$rawInput = @($input) -join ""

# "command":"git push" パターンを検出
if ($rawInput -match '"command"\s*:\s*"[^"]*\bgit\s+push\b') {
    Write-Error "git push is blocked. Please run it manually."
    exit 2
}

exit 0
