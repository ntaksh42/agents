# LSP 環境構築ガイド（Windows）

このガイドでは、Claude Code で C# と C++ の LSP（Language Server Protocol）を使用するための環境構築手順を説明します。

## 目次

1. [LSP とは](#lsp-とは)
2. [Claude Code での LSP の利点](#claude-code-での-lsp-の利点)
3. [csharp-lsp のセットアップ](#csharp-lsp-のセットアップ)
4. [clangd のセットアップ](#clangd-のセットアップ)
5. [Claude Code での LSP プラグイン設定](#claude-code-での-lsp-プラグイン設定)
6. [動作確認](#動作確認)
7. [トラブルシューティング](#トラブルシューティング)

---

## LSP とは

Language Server Protocol（LSP）は、エディタ/IDE と言語サーバー間の通信プロトコルです。これにより、コード補完、定義ジャンプ、参照検索などの高度なコード分析機能を利用できます。

## Claude Code での LSP の利点

Claude Code で LSP を有効にすると、以下の機能が利用可能になります：

- **goToDefinition**: シンボルの定義箇所を検索
- **findReferences**: シンボルの参照箇所を検索
- **hover**: シンボルのドキュメント・型情報を表示
- **documentSymbol**: ファイル内のシンボル一覧を取得
- **workspaceSymbol**: ワークスペース全体のシンボル検索
- **goToImplementation**: インターフェース・抽象メソッドの実装を検索
- **prepareCallHierarchy**: 関数・メソッドのコール階層を取得
- **incomingCalls**: 呼び出し元を検索
- **outgoingCalls**: 呼び出し先を検索

これらの機能により、Claude がコードベースをより正確に理解し、的確な提案ができるようになります。

---

## csharp-lsp のセットアップ

C# の LSP には **csharp-ls** を使用します。

### 前提条件

- .NET SDK 6.0 以降がインストールされていること

### インストール手順

```powershell
# csharp-ls をグローバルツールとしてインストール
dotnet tool install --global csharp-ls
```

### 確認

```powershell
# インストール確認
where.exe csharp-ls

# バージョン確認
csharp-ls --version
```

---

## clangd のセットアップ

C/C++ の LSP には **clangd** を使用します。

### 前提条件

- Visual Studio 2022 の「C++ によるデスクトップ開発」ワークロードがインストールされていること
- または LLVM/Clang がインストールされていること

### インストール手順

```powershell
# winget を使用してインストール（推奨）
winget install LLVM.LLVM
```

インストーラーを使用する場合は、「Add LLVM to the system PATH」オプションを有効にしてください。

### 確認

```powershell
# インストール確認
where.exe clangd

# バージョン確認
clangd --version
```

### compile_commands.json の生成（C++ プロジェクト用）

clangd が正しく動作するには、`compile_commands.json` が必要です。

#### CMake プロジェクトの場合

```powershell
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

生成された `build/compile_commands.json` をプロジェクトルートにコピー：

```powershell
Copy-Item "build\compile_commands.json" -Destination "."
```

---

## Claude Code での LSP プラグイン設定

Claude Code では、LSP は**プラグイン**として提供されています。

### 方法1: 対話的インストール（推奨）

```bash
claude
/plugin
# Discover タブで "csharp-lsp" と "clangd-lsp" を検索してインストール
```

### 方法2: CLI でインストール

```powershell
claude plugin install csharp-lsp@claude-plugins-official --scope user
claude plugin install clangd-lsp@claude-plugins-official --scope user
```

### 方法3: settings.json に直接記述

`.claude/settings.json` または `.claude/settings.local.json` に以下を追加：

```json
{
  "enabledPlugins": {
    "csharp-lsp@claude-plugins-official": true,
    "clangd-lsp@claude-plugins-official": true
  }
}
```

### 設定ファイルの場所

| スコープ | ファイル位置 | 用途 |
|---------|------------|------|
| User | `~/.claude/settings.json` | 個人が全プロジェクトで使用 |
| Project | `.claude/settings.json` | チーム共有（git管理） |
| Local | `.claude/settings.local.json` | プロジェクト個別（gitignored） |

---

## 動作確認

### LSP ツールの使用

Claude Code で以下の LSP 操作をテスト：

```
# C# ファイルの定義にジャンプ
LSP goToDefinition MyClass.cs 10 5

# 参照を検索
LSP findReferences MyClass.cs 10 5

# ホバー情報を取得
LSP hover MyClass.cs 10 5

# ファイル内のシンボル一覧
LSP documentSymbol MyClass.cs 1 1
```

### C++ の動作確認

```
LSP goToDefinition main.cpp 15 10
LSP findReferences main.cpp 15 10
LSP documentSymbol main.cpp 1 1
```

---

## トラブルシューティング

### 共通の問題

#### LSP サーバーが見つからない

```
Error: LSP server not found
```

**解決策:**

1. コマンドが PATH に含まれているか確認

```powershell
where.exe csharp-ls
where.exe clangd
```

2. 新しいターミナルを開いて PATH が更新されているか確認

3. PC を再起動して PATH の変更を反映

#### プラグインが有効にならない

**解決策:**

1. Claude Code を再起動
2. `/plugin` コマンドでプラグインの状態を確認
3. settings.json の構文エラーを確認

### csharp-lsp 固有の問題

#### ソリューションが見つからない

```
Error: No solution found
```

**解決策:**

1. プロジェクトディレクトリに `.sln` ファイルがあることを確認
2. `.csproj` ファイルのみの場合でも動作しますが、ソリューションファイルがあると安定します

#### NuGet パッケージが解決されない

**解決策:**

```powershell
# パッケージの復元
dotnet restore
```

### clangd 固有の問題

#### compile_commands.json が見つからない

```
Error: Could not find compile commands
```

**解決策:**

1. プロジェクトルートに `compile_commands.json` を配置
2. CMake の場合: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` を使用

#### ヘッダーファイルが見つからない

**解決策:**

`.clangd` 設定ファイルをプロジェクトルートに作成：

```yaml
CompileFlags:
  Add:
    - -IC:/path/to/include
    - -std=c++17
```

または `compile_flags.txt` を作成：

```
-IC:/path/to/include
-std=c++17
-Wall
```

---

## 参考リンク

- [csharp-ls GitHub](https://github.com/razzmatazz/csharp-language-server)
- [clangd 公式ドキュメント](https://clangd.llvm.org/)
- [LLVM ダウンロード](https://releases.llvm.org/)
- [Claude Code Plugins ドキュメント](https://docs.anthropic.com/en/docs/claude-code/plugins)
- [Language Server Protocol 仕様](https://microsoft.github.io/language-server-protocol/)
