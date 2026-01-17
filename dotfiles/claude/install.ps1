# Claude Code dotfiles installer for Windows
# Usage: .\install.ps1

$ErrorActionPreference = "Stop"

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$HooksSourceDir = Join-Path $ScriptDir "hooks"
$SkillsSourceDir = Join-Path $ScriptDir "skills"
$SkillsDestDir = Join-Path $ClaudeDir "skills"
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

# Copy skills
if (Test-Path $SkillsSourceDir) {
    Write-Host "Copying skills..." -ForegroundColor Green
    if (-not (Test-Path $SkillsDestDir)) {
        New-Item -ItemType Directory -Path $SkillsDestDir | Out-Null
    }
    $SkillDirs = Get-ChildItem -Path $SkillsSourceDir -Directory
    foreach ($skillDir in $SkillDirs) {
        $destSkillDir = Join-Path $SkillsDestDir $skillDir.Name
        Copy-Item $skillDir.FullName $destSkillDir -Recurse -Force
        Write-Host "  - $($skillDir.Name)" -ForegroundColor Gray
    }
}

# Set ENABLE_TOOL_SEARCH environment variable if not exists
$envName = "ENABLE_TOOL_SEARCH"
$currentValue = [Environment]::GetEnvironmentVariable($envName, "User")
if (-not $currentValue) {
    Write-Host "Setting $envName environment variable..." -ForegroundColor Green
    [Environment]::SetEnvironmentVariable($envName, "true", "User")
    $env:ENABLE_TOOL_SEARCH = "true"
    Write-Host "  - $envName = true (User scope)" -ForegroundColor Gray
} else {
    Write-Host "$envName already set: $currentValue" -ForegroundColor Gray
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
if (Test-Path $SkillsDestDir) {
    Write-Host "Installed skills:" -ForegroundColor Cyan
    Get-ChildItem $SkillsDestDir -Directory | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Gray }
}
Write-Host ""
Write-Host "Note: Restart Claude Code for changes to take effect." -ForegroundColor Yellow
