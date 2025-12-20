<#
.SYNOPSIS
    指定フォルダ配下のすべてのgitリポジトリを最新化するスクリプト

.DESCRIPTION
    指定されたフォルダまたは.slnファイル配下のgitリポジトリを探索し、
    各リポジトリで最新のリモートブランチをpullします。

.PARAMETER Path
    探索対象のフォルダパスまたは.slnファイルパス

.EXAMPLE
    .\Update-GitRepositories.ps1 -Path "C:\Projects"
    .\Update-GitRepositories.ps1 -Path "C:\Projects\MySolution.sln"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Get-DefaultBranch {
    param([string]$RepoPath)
    
    Push-Location $RepoPath
    try {
        # リモートのデフォルトブランチを取得
        $remoteHead = git symbolic-ref refs/remotes/origin/HEAD 2>$null
        if ($remoteHead -match "refs/remotes/origin/(.+)") {
            return $matches[1]
        }
        
        # 取得できない場合は、main/masterを試す
        $branches = git branch -r 2>$null
        if ($branches -match "origin/main") {
            return "main"
        } elseif ($branches -match "origin/master") {
            return "master"
        }
        
        return $null
    }
    finally {
        Pop-Location
    }
}

function Update-Repository {
    param([string]$RepoPath)
    
    $repoName = Split-Path $RepoPath -Leaf
    Write-ColorOutput "`n[処理中] $repoName" "Cyan"
    Write-Host "  パス: $RepoPath"
    
    Push-Location $RepoPath
    try {
        # 未コミット変更をチェック
        $status = git status --porcelain 2>$null
        if ($status) {
            Write-ColorOutput "  [スキップ] 未コミットの変更があります" "Yellow"
            return "skipped"
        }
        
        # 現在のブランチを取得
        $currentBranch = git branch --show-current 2>$null
        if (-not $currentBranch) {
            Write-ColorOutput "  [スキップ] HEADがデタッチされています" "Yellow"
            return "skipped"
        }
        
        Write-Host "  現在のブランチ: $currentBranch"
        
        # リモートを取得
        git fetch --all 2>&1 | Out-Null
        
        # 現在のブランチのリモート追跡ブランチを確認
        $remoteBranch = git rev-parse --abbrev-ref "$currentBranch@{upstream}" 2>$null
        
        if (-not $remoteBranch) {
            Write-ColorOutput "  [警告] リモート追跡ブランチが設定されていません" "Yellow"
            
            # デフォルトブランチに切り替え
            $defaultBranch = Get-DefaultBranch -RepoPath $RepoPath
            if ($defaultBranch) {
                Write-Host "  デフォルトブランチ ($defaultBranch) に切り替えます..."
                git checkout $defaultBranch 2>&1 | Out-Null
                
                if ($LASTEXITCODE -ne 0) {
                    Write-ColorOutput "  [失敗] ブランチ切り替えに失敗しました" "Red"
                    return "failed"
                }
                
                $currentBranch = $defaultBranch
            } else {
                Write-ColorOutput "  [スキップ] デフォルトブランチが見つかりません" "Yellow"
                return "skipped"
            }
        }
        
        # pull実行
        Write-Host "  Pulling..."
        $pullOutput = git pull 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            if ($pullOutput -match "Already up to date") {
                Write-ColorOutput "  [完了] 既に最新です" "Green"
            } else {
                Write-ColorOutput "  [完了] 更新しました" "Green"
            }
            return "success"
        } else {
            Write-ColorOutput "  [失敗] Pull中にエラーが発生しました" "Red"
            Write-Host "  $pullOutput"
            return "failed"
        }
    }
    catch {
        Write-ColorOutput "  [エラー] $_" "Red"
        return "failed"
    }
    finally {
        Pop-Location
    }
}

# メイン処理
Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "Git リポジトリ一括更新スクリプト" "Cyan"
Write-ColorOutput "========================================" "Cyan"

# パスの解決
$targetPath = Resolve-Path $Path -ErrorAction SilentlyContinue
if (-not $targetPath) {
    Write-ColorOutput "エラー: 指定されたパスが見つかりません: $Path" "Red"
    exit 1
}

# .slnファイルの場合は親フォルダを対象にする
if ($targetPath -match "\.sln$") {
    $targetPath = Split-Path $targetPath -Parent
    Write-Host "slnファイルが指定されました。親フォルダを探索します: $targetPath"
}

Write-Host "`n探索パス: $targetPath`n"

# .gitフォルダを探索
Write-Host "リポジトリを探索中..."
$gitDirs = Get-ChildItem -Path $targetPath -Directory -Recurse -Filter ".git" -Force -ErrorAction SilentlyContinue
$repositories = $gitDirs | ForEach-Object { Split-Path $_.FullName -Parent }

if ($repositories.Count -eq 0) {
    Write-ColorOutput "`nGitリポジトリが見つかりませんでした。" "Yellow"
    exit 0
}

Write-ColorOutput "`n見つかったリポジトリ数: $($repositories.Count)" "Green"

# 各リポジトリを更新
$results = @{
    success = 0
    skipped = 0
    failed = 0
}

foreach ($repo in $repositories) {
    $result = Update-Repository -RepoPath $repo
    $results[$result]++
}

# サマリー表示
Write-ColorOutput "`n========================================" "Cyan"
Write-ColorOutput "処理完了" "Cyan"
Write-ColorOutput "========================================" "Cyan"
Write-ColorOutput "成功: $($results.success)" "Green"
Write-ColorOutput "スキップ: $($results.skipped)" "Yellow"
Write-ColorOutput "失敗: $($results.failed)" "Red"
Write-ColorOutput "合計: $($repositories.Count)" "White"
