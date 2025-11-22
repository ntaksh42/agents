# セットアップガイド

このガイドでは、エージェントを使用するための環境構築手順を説明します。

## 目次

1. [前提条件](#前提条件)
2. [Claude Code / Claude Agent SDK のインストール](#claude-code--claude-agent-sdk-のインストール)
3. [リポジトリのクローン](#リポジトリのクローン)
4. [開発環境の準備](#開発環境の準備)
5. [エージェントの使用](#エージェントの使用)
6. [トラブルシューティング](#トラブルシューティング)

## 前提条件

### 必須

- **Claude Code CLI** または **Claude Agent SDK**
- Git
- 基本的なコマンドライン操作の知識

### エージェント別の要件

#### C++ エージェント用
- C++コンパイラ（GCC 9+, Clang 10+, MSVC 2019+）
- CMake 3.15+（Build System Helper用）
- vcpkg（オプション、パッケージ管理用）

#### C# エージェント用
- .NET SDK 6.0+ または .NET Framework 4.7.2+
- Visual Studio 2022 または VS Code（推奨）
- NuGet CLI（オプション）

## Claude Code / Claude Agent SDK のインストール

### Claude Code CLI

```bash
# インストール方法は公式ドキュメントを参照
# https://github.com/anthropics/claude-code
```

### Claude Agent SDK

```bash
# インストール方法は公式ドキュメントを参照
# https://github.com/anthropics/claude-agent-sdk
```

## リポジトリのクローン

```bash
# HTTPSでクローン
git clone https://github.com/yourusername/agents.git
cd agents

# または SSH
git clone git@github.com:yourusername/agents.git
cd agents
```

## 開発環境の準備

### C++ 開発環境

#### Windows

```powershell
# Visual Studio 2022 をインストール
# "C++によるデスクトップ開発" ワークロードを選択

# CMake のインストール（オプション）
winget install Kitware.CMake

# vcpkg のインストール（オプション）
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install
```

#### Linux

```bash
# GCC/Clang のインストール
sudo apt-get update
sudo apt-get install build-essential cmake

# vcpkg のインストール（オプション）
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg integrate install
```

#### macOS

```bash
# Xcode Command Line Tools
xcode-select --install

# CMake のインストール
brew install cmake

# vcpkg のインストール（オプション）
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg integrate install
```

### C# 開発環境

#### Windows

```powershell
# .NET SDK のインストール
winget install Microsoft.DotNet.SDK.8

# Visual Studio 2022 または VS Code
winget install Microsoft.VisualStudio.2022.Community
# または
winget install Microsoft.VisualStudioCode
```

#### Linux / macOS

```bash
# .NET SDK のインストール
# https://dotnet.microsoft.com/download

# VS Code（推奨）
# https://code.visualstudio.com/download

# C# 拡張機能をインストール
code --install-extension ms-dotnettools.csharp
```

## エージェントの使用

### 基本的な使用方法

```bash
# Claude Code でエージェントを指定
claude-code --agent agents/memory-safety

# または対話モードで
claude-code
> use agent agents/memory-safety
```

### エージェント別の使用例

#### 1. Memory Safety Analyzer

```bash
# C++ファイルのメモリ安全性をチェック
claude-code --agent agents/memory-safety

# プロンプト例:
"以下のC++コードのメモリリークを検出して修正してください"
```

#### 2. Interop Expert

```bash
# C#とC++の相互運用コードを生成
claude-code --agent agents/interop-expert

# プロンプト例:
"以下のC++関数をC#から呼び出すP/Invokeコードを生成してください"
```

#### 3. Build System Helper

```bash
# CMake設定を生成
claude-code --agent agents/build-helper

# プロンプト例:
"このプロジェクトのCMakeLists.txtを作成してください。依存関係はfmtとspdlogです"
```

#### 4. Windows Desktop Expert

```bash
# WPFアプリのコード生成
claude-code --agent agents/windows-desktop

# プロンプト例:
"データバインディングを使用したユーザーリストを表示するWPFウィンドウを作成してください"
```

#### 5. Performance Profiler Assistant

```bash
# パフォーマンス最適化提案
claude-code --agent agents/performance

# プロンプト例:
"以下のコードのボトルネックを特定し、最適化案を提案してください"
```

#### 6. Unit Test Generator

```bash
# ユニットテスト生成
claude-code --agent agents/test-generator

# プロンプト例:
"以下のC#クラスのxUnitテストを生成してください"
```

## プロジェクトへの統合

### VS Code 統合

`.vscode/settings.json` を作成：

```json
{
  "claude.agents": [
    {
      "name": "Memory Safety",
      "path": "./agents/memory-safety"
    },
    {
      "name": "Interop Expert",
      "path": "./agents/interop-expert"
    }
  ]
}
```

### Git フック統合

`.git/hooks/pre-commit` でコミット前にチェック：

```bash
#!/bin/bash
# メモリ安全性チェックを実行
claude-code --agent agents/memory-safety --check-only
```

### CI/CD 統合

GitHub Actions の例 (`.github/workflows/agent-check.yml`):

```yaml
name: Agent Checks

on: [push, pull_request]

jobs:
  memory-safety:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Memory Safety Check
        run: |
          claude-code --agent agents/memory-safety --batch
```

## 設定のカスタマイズ

### エージェント設定

各エージェントディレクトリに `config.json` を作成（オプション）：

```json
{
  "strictness": "high",
  "auto_fix": false,
  "output_format": "markdown",
  "include_explanations": true
}
```

### グローバル設定

`~/.claude/config.json`:

```json
{
  "default_agent_path": "./agents",
  "preferred_language": "ja",
  "verbose": true
}
```

## トラブルシューティング

### よくある問題

#### 1. エージェントが見つからない

```
Error: Agent not found at path: agents/memory-safety
```

**解決策:**
- パスが正しいか確認
- `ls agents/` でディレクトリが存在するか確認
- 絶対パスで指定してみる

#### 2. 権限エラー

```
Permission denied: cannot access agents/memory-safety
```

**解決策:**
```bash
chmod -R 755 agents/
```

#### 3. Claude Code が動作しない

**解決策:**
- Claude Code が正しくインストールされているか確認
- `claude-code --version` でバージョン確認
- 最新版にアップデート

#### 4. C++/C# ツールが見つからない

**解決策:**
- 環境変数 PATH が正しく設定されているか確認
- コンパイラが正しくインストールされているか確認
- `which gcc` / `where cl` でコンパイラの場所確認

### ログの確認

```bash
# 詳細ログを有効化
claude-code --verbose --agent agents/memory-safety

# ログファイルの確認
cat ~/.claude/logs/agent.log
```

### デバッグモード

```bash
# デバッグモードで実行
claude-code --debug --agent agents/memory-safety
```

## パフォーマンス最適化

### キャッシュの有効化

```bash
# エージェントの結果をキャッシュ
claude-code --cache --agent agents/memory-safety
```

### 並列実行

```bash
# 複数ファイルを並列処理
claude-code --agent agents/memory-safety --parallel=4 src/**/*.cpp
```

## 次のステップ

1. **簡単なエージェントから試す**: Memory Safety Analyzer や Test Generator がおすすめ
2. **実際のプロジェクトで使用**: 小規模なコードから試してフィードバックを得る
3. **カスタマイズ**: ニーズに合わせてエージェントを調整
4. **新しいエージェント作成**: [Agent開発ガイド](agent-development-guide.md) を参照

## サポート

問題が解決しない場合：

1. GitHub Issues で報告
2. ドキュメントを再確認
3. Claude Code の公式ドキュメントを参照

---

**ハッピーコーディング！** 🚀
