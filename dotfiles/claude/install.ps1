# Claude Code dotfiles installer for Windows
# Usage: .\install.ps1

$ErrorActionPreference = "Stop"

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$HooksSourceDir = Join-Path $ScriptDir "hooks"
$TemplateFile = Join-Path $ScriptDir "settings.template.json"

Write-Host "Claude Code dotfiles installer" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Create .claude directory if not exists
if (-not (Test-Path $ClaudeDir)) {
    Write-Host "Creating $ClaudeDir ..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $ClaudeDir | Out-Null
}

# Backup existing settings.json
$SettingsFile = Join-Path $ClaudeDir "settings.json"
if (Test-Path $SettingsFile) {
    $BackupFile = Join-Path $ClaudeDir "settings.json.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "Backing up existing settings.json to $BackupFile" -ForegroundColor Yellow
    Copy-Item $SettingsFile $BackupFile
}

# Copy hook scripts
Write-Host "Copying hook scripts..." -ForegroundColor Green
$HookFiles = Get-ChildItem -Path $HooksSourceDir -Filter "*.ps1"
foreach ($file in $HookFiles) {
    $dest = Join-Path $ClaudeDir $file.Name
    Copy-Item $file.FullName $dest -Force
    Write-Host "  - $($file.Name)" -ForegroundColor Gray
}

# Generate settings.json from template
Write-Host "Generating settings.json..." -ForegroundColor Green
$template = Get-Content $TemplateFile -Raw
$claudeDirEscaped = $ClaudeDir -replace '\\', '\\\\'
$settings = $template -replace '\{\{CLAUDE_DIR\}\}', $claudeDirEscaped
Set-Content -Path $SettingsFile -Value $settings -Encoding UTF8

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Installed files:" -ForegroundColor Cyan
Get-ChildItem $ClaudeDir -Filter "*.ps1" | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Gray }
Write-Host "  - $SettingsFile" -ForegroundColor Gray
Write-Host ""
Write-Host "Note: Restart Claude Code for changes to take effect." -ForegroundColor Yellow
