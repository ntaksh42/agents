---
marp: true
theme: default
paginate: true
html: true
style: |
  section {
    font-family: 'Segoe UI', sans-serif;
    font-size: 28px;
  }
  h1 {
    color: #0366d6;
    font-size: 48px;
  }
  h2 {
    color: #24292e;
    border-bottom: 3px solid #0366d6;
    padding-bottom: 10px;
  }
  code {
    background: #f6f8fa;
    padding: 2px 6px;
    border-radius: 3px;
    color: #e36209;
  }
  table {
    font-size: 24px;
  }
---

# GitHub Copilot コマンドガイド

VSCode で使える Copilot のコマンド一覧

---

## スラッシュコマンド (`/`)

チャットで `/` を入力すると使えるコマンド

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/explain` | コードの説明 | `/explain この関数の処理内容` |
| `/fix` | 問題を修正 | `/fix このエラーを解決` |
| `/tests` | テストコード生成 | `/tests #file:utils.ts` |
| `/doc` | ドキュメント生成 | `/doc この関数のJSDoc` |
| `/new` | 新規ファイル作成 | `/new React component for user profile` |

---

## スラッシュコマンド - 続き

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/clear` | 会話履歴をクリア | `/clear` |
| `/help` | ヘルプ表示 | `/help` |
| `/search` | ワークスペース検索 | `/search @workspace 認証処理` |
| `/newNotebook` | Jupyter Notebook作成 | `/newNotebook データ分析` |
| `/setupTests` | テスト環境セットアップ | `/setupTests` |

---

## エージェント (`@`)

特定の機能やスコープを指定

| エージェント | 説明 | 使用例 |
|------------|------|--------|
| `@workspace` | ワークスペース全体を検索 | `@workspace 認証の実装場所は？` |
| `@vscode` | VSCode の機能について質問 | `@vscode デバッグの設定方法` |
| `@terminal` | ターミナル操作を支援 | `@terminal npm パッケージをインストール` |
| `@github` | GitHub操作（PR、Issue等） | `@github このブランチでPR作成` |

---

## コンテキスト指定 (`#`)

ファイルやシンボルを明示的に参照

| 構文 | 説明 | 使用例 |
|------|------|--------|
| `#file` | ファイルを参照 | `#file:src/utils.ts この関数を説明` |
| `#selection` | 選択範囲を参照 | `#selection をリファクタリング` |
| `#editor` | アクティブエディタ | `#editor のコードレビュー` |
| `#codebase` | コードベース全体 | `#codebase で認証処理を検索` |
| `#terminalLastCommand` | 最後のターミナルコマンド | `#terminalLastCommand のエラーを修正` |

---

## コンテキスト指定 - 続き

| 構文 | 説明 | 使用例 |
|------|------|--------|
| `#terminalSelection` | ターミナルの選択範囲 | `#terminalSelection を説明` |
| `#symbolName` | シンボル名で検索 | `#UserService このクラスを説明` |

---

## 組み合わせ例

### パターン 1: ファイル指定でテスト生成
```
/tests #file:src/auth/login.ts
```

### パターン 2: ワークスペース検索 + 修正
```
@workspace #file:config.ts の設定を環境変数に移行
```

### パターン 3: 選択範囲をリファクタリング
```
#selection を関数に切り出してテストも生成
```

---

## エディタコマンド

エディタ内で右クリックやショートカットで実行

| コマンド | ショートカット | 説明 |
|---------|---------------|------|
| Copilot: Explain This | - | 選択コードを説明 |
| Copilot: Fix This | - | 選択コードの問題を修正 |
| Copilot: Generate Tests | - | テストコード生成 |
| Copilot: Generate Docs | - | ドキュメント生成 |
| Copilot: Optimize Code | - | コード最適化 |

---

## インライン補完

コードエディタで自動的に表示される提案

| ショートカット | 動作 |
|--------------|------|
| `Tab` | 提案を受け入れ |
| `Esc` | 提案を却下 |
| `Alt + ]` | 次の提案を表示 |
| `Alt + [` | 前の提案を表示 |
| `Ctrl + Enter` | 別パネルで全提案を表示 |

---

## チャットショートカット

| ショートカット | 動作 |
|--------------|------|
| `Ctrl + Shift + I` | Copilot Chat を開く |
| `Ctrl + I` | インラインチャット起動 |
| `Ctrl + Alt + I` | Quick Chat を開く |

**Windows の場合**
- `Ctrl` を使用

**Mac の場合**
- `Cmd` を使用

---

## カスタムプロンプト (`.prompt.md`)

再利用可能なカスタムコマンドを作成

### 配置場所
- `.github/prompts/` (ワークスペース内)
- ユーザープロファイル (全ワークスペース共通)

### 基本構造
```markdown
---
name: review
description: コードレビューを実行
---
選択されたコードをレビューしてください。
```

### 使用方法
チャットで `/review` として実行

---

## 便利なコマンドの組み合わせ

### 新機能開発の流れ
```
1. @workspace 既存の実装パターンを確認
2. /new 新しいコンポーネント作成
3. /tests #file:新規ファイル.ts テスト生成
4. /doc ドキュメント追加
```

### バグ修正の流れ
```
1. #terminalLastCommand エラーを分析
2. @workspace 関連コードを検索
3. /fix #selection 問題を修正
4. /tests 修正箇所のテスト追加
```

---

## 効率的な使い方のコツ

### 1. コンテキストを明示する
❌ `この関数を説明して`
✅ `/explain #file:utils.ts の parseData 関数`

### 2. スコープを絞る
❌ `認証処理を探して`
✅ `@workspace #codebase JWT認証の実装場所`

### 3. 段階的にリクエスト
複雑なタスクは小さく分割して実行

---

## 注意点とベストプラクティス

### コンテキストの管理
- 不要なファイルは閉じる（3-5個推奨）
- 大きなタスクの前に `/clear` で会話をリセット

### モデル選択
- **Auto**: 自動で最適なモデルを選択
- **Claude Sonnet 4.5**: バランス型、汎用におすすめ
- **GPT-4o**: 複雑な推論に強い

### プレミアムリクエストの節約
- 簡単なタスクは軽量モデル（Haiku等）を選択
- 長い会話は定期的にクリア

---

## 参考リソース

### 公式ドキュメント
- [GitHub Copilot Docs](https://docs.github.com/copilot)
- [VS Code Copilot Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)

### 学習リソース
- [Copilot Tips & Tricks](https://github.com/github/awesome-copilot)
- [Prompt Engineering Guide](https://github.com/dair-ai/Prompt-Engineering-Guide)

---

# まとめ

- **`/`** でコマンド実行
- **`@`** でエージェント指定
- **`#`** でコンテキスト明示
- 組み合わせて効率的に活用

**Quality = Context × Prompt × Model**

