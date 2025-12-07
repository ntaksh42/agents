---
marp: true
theme: default
paginate: true
style: |
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&family=IBM+Plex+Sans:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap');

  section {
    background: #f8f9fa;
    color: #2c3e50;
    font-family: 'IBM Plex Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    padding: 60px 80px;
    font-size: 22px;
    line-height: 1.8;
  }

  h1 {
    font-family: 'Poppins', sans-serif;
    font-weight: 700;
    font-size: 52px;
    color: #34495e;
    margin-bottom: 30px;
    letter-spacing: -0.01em;
  }

  h2 {
    font-family: 'Poppins', sans-serif;
    font-weight: 600;
    font-size: 40px;
    color: #5a6c7d;
    margin-bottom: 35px;
    letter-spacing: -0.005em;
    border-bottom: 3px solid #95a5a6;
    padding-bottom: 15px;
  }

  h3 {
    font-family: 'Poppins', sans-serif;
    font-weight: 600;
    font-size: 28px;
    color: #7f8c8d;
    margin-top: 35px;
    margin-bottom: 18px;
  }

  p, li {
    font-size: 22px;
    line-height: 1.8;
    color: #4a5568;
  }

  strong {
    color: #2c3e50;
    font-weight: 600;
  }

  ul, ol {
    margin-left: 35px;
  }

  li {
    margin-bottom: 16px;
  }

  li::marker {
    color: #95a5a6;
    font-weight: 600;
  }

  code {
    background: #ecf0f1;
    color: #5a6c7d;
    padding: 3px 10px;
    border-radius: 4px;
    font-family: 'JetBrains Mono', 'Consolas', monospace;
    font-size: 20px;
    border: 1px solid #d5d8dc;
  }

  blockquote {
    border-left: 4px solid #95a5a6;
    padding-left: 25px;
    margin: 25px 0;
    font-style: italic;
    color: #6c7a89;
    background: #f5f7fa;
    padding: 20px 25px;
    border-radius: 6px;
  }

  footer {
    font-size: 18px;
    color: #95a5a6;
  }

  .highlight {
    color: #5a6c7d;
    font-weight: 600;
  }

  .card {
    background: #ffffff;
    border: 1px solid #e1e4e8;
    border-radius: 8px;
    padding: 25px;
    margin: 18px 0;
    box-shadow: 0 1px 3px rgba(0,0,0,0.06);
  }

  section.title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
    padding: 80px;
  }

  section.title h1 {
    font-size: 64px;
    margin-bottom: 35px;
  }

  section.title p {
    font-size: 26px;
    color: #6c7a89;
    max-width: 900px;
  }
---

<!-- _class: title -->

# VSCode × Github Copilot　　

---

## GitHub Copilotとは

**GitHubが提供しているAI Agent**

- コードの自動補完・自動編集・生成
- 自然言語での対話・質問

コーディングはもちろん、資料生成、情報整理など
いろんな業務に活用可能。VSCode×GithubCopilotが入門としてはやりやすいので紹介。

---

## Copilotのモード

| モード | 説明 |
|--------|------|
| **Ask** | 質問・調査モード。コードの説明や情報収集に最適 |
| **Edit** | 手動編集モード。ファイルを選択し、確認しながら編集 |
| **Agent** | 自律実行モード。ファイル選択から編集まで自動で実行 |
| **Plan** | 計画モード。タスクの計画を立ててから実行 |

Chatの左下から選択可能。基本はAgentModeがおすすめ。

---
## AIモデルの選び方

| タスク | おすすめモデル |
|--------|---------------|
| **汎用コーディング** | GPT-4.1、GPT-5 mini、Claude Sonnet 4.5 |
| **コード特化** | GPT-5-Codex、GPT-5.1-Codex |
| **高速・シンプル作業** | Claude Haiku 4.5、Grok Code Fast 1 |
| **深い推論・デバッグ** | Claude Opus 4.5、GPT-5、Gemini 3 Pro |

- **Auto** を選ぶと自動で最適なモデルを選択
- 迷ったら **Claude Sonnet 4.5** がバランス良くおすすめ
- 上位モデルはその分プレミアムリクエストを消費するので注意。

---

## Chat Syntax

- **`#`** でファイル・シンボルとしてコンテキストを明示

- **`@`** でエージェントやツールを指定
  - `@workspace` - ワークスペース全体を検索
  - `@vscode` - vscodeの機能について質問できる

- **`/`** でコマンドを実行
  - `/explain` - コードを説明
  - `/fix` - 問題を修正

---

## 効果的な使い方 - プロンプト戦略

### **精度を上げるコツ**

1. **具体的に指示** - 曖昧な質問より明確な要求
2. **段階的にリクエスト** - 複雑なタスクは小さく分割
3. **例を示す** - 「こういう形式で」と具体例を提示
4. **出力形式を指定** - テーブル、リスト、JSONなど形式を明示

---

## コンテキスト最適化のコツ

1. **開くファイルは3-5個に絞る** - 無関係なファイルを閉じる
2. **`/clear`で会話をリセット** - 作業切り替え時に実行

---

## 必須の設定

```json
{
  // カスタム指示ファイルを有効化
  "github.copilot.chat.codeGeneration.useInstructionFiles": true,
  
  // Next Edit Suggestions（次の編集を自動予測）
  "github.copilot.nextEditSuggestions.enabled": true,
  
  // エージェントモードを有効化
  "chat.agent.enabled": true,
  
  // コードアクションでCopilotコマンドを表示
  "github.copilot.editor.enableCodeActions": true
}
```

---
## 便利な設定

```json
{
  // 日本語でチャット応答
  "github.copilot.chat.localeOverride": "ja",
  
  // コミットメッセージを日本語で生成
  "github.copilot.chat.commitMessageGeneration.instructions": [
    { "text": "必ず日本語で簡潔に記述" }
  ],
  
  // リネーム時に自動提案
  "github.copilot.renameSuggestions.triggerAutomatically": true
}
```

---

## 高度な設定

```json
{
  // Claude 3.7 Sonnet等の高度な推論を有効化
  "copilot.chat.agent.thinkingTool": true,
  
  // 次の編集を自動予測（Cursor Tab風機能）
  "github.copilot.nextEditSuggestions.enabled": true,
  
  // 反復的な編集提案
  "github.copilot.editor.iterativeEditing": true,
  
  // 代替プロンプト戦略を有効化。完遂力が高まる（実験的機能）
  "github.copilot.chat.alternateGptPrompt.enabled": true,
  
  // ターミナルコマンドを自動承認
  "chat.tools.terminal.autoApprove": true
}
```

---

## Model Context Protocol (MCP)

**AIエージェントと外部データ・ツールを連携するオープンプロトコル**

### **MCPとは**

- GitHub CopilotのAgentモードで外部サービスと連携
- Azure、Dataverse、NuGetなどのMCPサーバーに接続可能
- 自然言語でリソース操作やデータ取得が可能

### **例**

- [Azure DevOps MCP](https://github.com/microsoft/azure-devops-mcp/blob/main/docs/GETTINGSTARTED.md#%EF%B8%8F-visual-studio-code--github-copilot)
  ※OneClickInstallが手軽でおすすめ。

---

## チャット履歴機能

### **履歴へのアクセス**

1. Chat View（`Ctrl+Shift+I`）を開く
2. 上部の **「Show Chats...」** ボタンをクリック
3. 履歴から過去の会話を選択して再開

### **活用例**

- 前日の調査を継続
- 過去の資料を再編集
- 複数アプローチの比較

---

## 履歴の保存・再利用

### **エクスポート**

- **JSON**: `Ctrl+Shift+P` → `Chat: Export Chat...`
- **Markdown**: Chat View右クリック → `Copy All`

### **プロンプト化**

`/savePrompt` コマンドで `.prompt.md` として保存
→ スラッシュコマンドで再利用可能に

---

## copilot-instructions.md

### **プロジェクト固有のルールをCopilotに学習させるファイル**

- **配置**: `.github/copilot-instructions.md`
- **適用**: すべてのCopilot Chatリクエストに自動適用

### **記載する内容**

1. **基本指示** - 回答言語、変更前の計画提案など
2. **プロジェクト概要** - 開発内容、目的、主要機能
3. **技術スタック** - バージョン、アーキテクチャ
4. **テスト方針** - フレームワーク、カバレッジ目標
5. **禁止事項** - `default export禁止`、`any型禁止`等

---

## copilot-instructions.md の書き方

### **ベストプラクティス**

**明確・簡潔に書く**: 長すぎるとAIが正確に実行できない

**肯定形で書く**:

- ❌ `any型を使わないでください`
- ✅ `型定義は具体的な型を使用してください`

**開発サイクルを整理**:

```markdown
# 開発フロー
1. 調査: 既存コードとドキュメントを確認
2. 計画: 変更影響範囲を特定し、計画を提示
3. 実装: 段階的に実装
4. デバッグ テスト実行とエラー修正
```

---

## 複数の指示ファイル活用

### **ファイル別の特化した指示**

`.github/instructions/` 内に配置し、YAMLフロントマターで対象指定

```markdown
---
applyTo: "**/*.test.ts"
---
# テストファイル用の指示
- テストフレームワークはVitestを使用
- カバレッジは80%以上を目標
```

---

## .prompt.md ファイル - 概要

### **再利用可能なプロンプトテンプレート**

頻繁に使うプロンプトをファイル化してスラッシュコマンドで実行

### **配置場所**

- **ワークスペース**: `.github/prompts/` に配置（そのワークスペース内のみ）
- **ユーザープロファイル**: 全ワークスペースで利用可能

### **ファイル構造**

1. **ヘッダー（YAML）** - `name`、`description`、`agent`、`model`、`tools` などを指定
2. **本文（Markdown）** - プロンプトの内容を記述
   - `${selection}`、`${file}` などの変数が使える
   - Markdownリンクでファイル参照可能

---

## .prompt.md ファイル - 使用方法

### **スラッシュコマンドとして利用可能**

- チャットで `/` + ファイル名（または `name` で指定した名前）を入力
- ファイル名が自動的にカスタムスラッシュコマンドになる

### **実行例**

- `review.prompt.md` → `/review` コマンドとして実行可能
- 追加情報も渡せる: `/review この関数の最適化提案をください`

---

## .prompt.md ファイル - 記述例

### **基本的な例 - コードレビュー**

```markdown
---
name: review
description: コードレビューを実行
agent: agent
---

選択されたコードまたは ${file} のコードレビューを実行してください。

以下の観点でチェック:
- コードの品質と可読性
- パフォーマンスの問題
- セキュリティの懸念
- ベストプラクティスからの逸脱
```

### **利用可能な変数**

- `${selection}` - 選択中のテキスト
- `${file}` - 現在のファイルパス
- `${workspaceFolder}` - ワークスペースのルートパス
- `${input:variableName}` - ユーザー入力を受け取る

---

## 参考リソース

- [GitHub Copilot 公式ドキュメント](https://docs.github.com/copilot)
- [Awesome GitHub Copilot](https://github.com/github/awesome-copilot)