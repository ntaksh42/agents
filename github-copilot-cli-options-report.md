# GitHub Copilot CLI オプション引数レポート

## 目次

1. [概要](#概要)
2. [インストールと認証](#インストールと認証)
3. [コマンドラインオプション](#コマンドラインオプション)
4. [インタラクティブモードのスラッシュコマンド](#インタラクティブモードのスラッシュコマンド)
5. [使用例](#使用例)
6. [セキュリティに関する注意事項](#セキュリティに関する注意事項)
7. [システム要件](#システム要件)

---

## 概要

GitHub Copilot CLIは、GitHubのCopilot AIエージェントをターミナルから直接利用できるコマンドラインツールです。2025年9月にパブリックプレビューとなり、継続的に機能強化されています。

### 主な特徴

- **インタラクティブモード**: 対話的にCopilotとやり取りできるモード
- **プログラマティックモード**: 単一のプロンプトをコマンドラインから直接渡せるモード
- **マルチモデル対応**: Claude Sonnet 4.5、Claude Sonnet 4、GPT-5などのモデルを選択可能
- **MCP（Model Context Protocol）サーバー対応**: 拡張性のある統合が可能
- **GitHub統合**: リポジトリ、Issue、プルリクエストとの統合

---

## インストールと認証

### インストール

```bash
npm install -g @github/copilot
```

### 起動

```bash
copilot
```

初回起動時にアニメーションバナーが表示されます。

### 認証方法

#### 1. インタラクティブログイン

CLIを起動後、`/login`スラッシュコマンドを使用してGitHubアカウントで認証します。

#### 2. Personal Access Token (PAT)

1. https://github.com/settings/personal-access-tokens/new でfine-grained PATを作成
2. "Copilot Requests"権限を追加
3. 環境変数を設定:
   ```bash
   export GH_TOKEN=your_token_here
   # または
   export GITHUB_TOKEN=your_token_here
   ```
   ※環境変数は`GH_TOKEN`、`GITHUB_TOKEN`の順でチェックされます

---

## コマンドラインオプション

### 基本オプション

| オプション | 説明 |
|----------|------|
| `-h, --help` | ヘルプを表示 |
| `-v, --version` | バージョン情報を表示 |
| `--banner` | アニメーションバナーを表示して起動 |

ヘルプの確認:
```bash
copilot --help
# または、インタラクティブセッション内で
copilot help
# または、プロンプトボックスで
?
```

### モード関連オプション

#### プログラマティックモード

| オプション | 説明 |
|----------|------|
| `-p, --prompt <text>` | 単一のプロンプトをコマンドラインから直接渡す |

**使用例:**
```bash
copilot -p "Revert the last commit"
copilot --prompt "Show me the git log for the last 5 commits"
```

### ツール許可制御オプション

これらのオプションは、Copilotが実行できるコマンドやツールを制御します。

| オプション | 説明 |
|----------|------|
| `--allow-all-tools` | すべてのツールを承認なしで使用可能にする |
| `--allow-tool <tool>` | 特定のツールを承認なしで使用可能にする |
| `--deny-tool <tool>` | 特定のツールの使用を禁止（他の許可オプションより優先） |

#### ツール指定の構文

**基本的なツール指定:**
```bash
--allow-tool 'shell'              # すべてのシェルコマンドを許可
--deny-tool 'shell(rm)'           # rmコマンドのみ禁止
```

**Globパターンによるマッチング:**
```bash
--allow-tool 'shell(npm run test:*)'  # test:で始まるnpmスクリプトを許可
--deny-tool 'shell(git *)'            # すべてのgitコマンドを禁止
```

**MCPサーバーのツール制御:**
```bash
--deny-tool 'My-MCP-Server(tool_name)'  # MCPサーバーの特定ツールを禁止
```

**組み合わせ使用例:**
```bash
copilot -p 'A prompt here' \
  --allow-all-tools \
  --deny-tool 'shell(cd)' \
  --deny-tool 'shell(git)' \
  --deny-tool 'fetch' \
  --deny-tool 'websearch'
```

### セッション管理オプション

| オプション | 説明 |
|----------|------|
| `--resume` | 以前のインタラクティブセッションに戻って会話を続ける |
| `--continue` | 最後に閉じたセッションを即座に再開 |

**使用例:**
```bash
copilot --continue                    # 直前のセッションを再開
copilot --resume <session-id>         # 特定のセッションを再開
```

### エージェント関連オプション

| オプション | 説明 |
|----------|------|
| `--agent <agent-name>` | 使用するカスタムエージェントを指定 |

**使用例:**
```bash
copilot --agent=refactor-agent --prompt "Refactor this code block"
```

---

## インタラクティブモードのスラッシュコマンド

インタラクティブモード中に`/`を入力すると利用可能なコマンドが表示されます。

### 主要なスラッシュコマンド

| コマンド | 説明 |
|---------|------|
| `/login` | GitHubアカウントで認証 |
| `/model` | 利用可能なAIモデルを切り替え（Claude Sonnet 4.5、GPT-5など） |
| `/delegate <TASK>` | Copilot coding agentにタスクを委任（未ステージの変更を新ブランチにコミットし、ドラフトPRを作成） |
| `/agent` | エージェントを明示的に呼び出す |
| `/usage` | 使用状況を表示 |
| `/share` | セッションを共有 |
| `/clear` | 画面をクリア |
| `/feedback` | フィードバックを送信 |

### コントロールキー

| キー | 機能 |
|-----|------|
| `Ctrl+R` | Copilotが実行したコマンドのログを表示 |

---

## 使用例

### 1. 基本的なインタラクティブ使用

```bash
copilot
# プロンプトが表示されたら質問やコマンドを入力
```

### 2. プログラマティックモードでの単発実行

```bash
# 単純なプロンプト
copilot -p "What is my current git branch?"

# すべてのツールを許可
copilot -p "Revert the last commit" --allow-all-tools

# 特定のツールのみ許可
copilot -p "Run the tests" --allow-tool 'shell(npm run test)'
```

### 3. セキュアな実行（制限付き）

```bash
# readコマンドのみ許可、writeコマンドは禁止
copilot -p "Show me the package.json contents" \
  --allow-tool 'shell(cat)' \
  --allow-tool 'shell(less)' \
  --deny-tool 'shell(rm)' \
  --deny-tool 'shell(mv)'
```

### 4. カスタムエージェントの使用

```bash
copilot --agent=refactor-agent --prompt "Optimize this function"
```

### 5. セッション管理

```bash
# 新規セッション開始
copilot

# 前回のセッションを再開
copilot --continue

# バナー表示付きで起動
copilot --banner
```

### 6. モデル切り替え（インタラクティブモード内）

```
/model
# 表示されるリストからClaude Sonnet 4.5、GPT-5などを選択
```

### 7. Copilot coding agentへの委任

```
/delegate Implement user authentication with JWT
# 変更が新ブランチにコミットされ、ドラフトPRが作成される
```

---

## セキュリティに関する注意事項

### ⚠️ 重要な警告

`--allow-all-tools`オプションを使用すると、Copilotはユーザーと同じレベルのファイルアクセス権限を持ち、事前承認なしに任意のシェルコマンドを実行できるようになります。

### ベストプラクティス

1. **最小権限の原則**: 必要なツールのみを許可する
   ```bash
   # 良い例
   copilot -p "Run tests" --allow-tool 'shell(npm test)'

   # 避けるべき例（過度な権限）
   copilot -p "Run tests" --allow-all-tools
   ```

2. **危険なコマンドの明示的な禁止**:
   ```bash
   copilot --allow-all-tools \
     --deny-tool 'shell(rm)' \
     --deny-tool 'shell(sudo)' \
     --deny-tool 'shell(chmod)'
   ```

3. **実行前のプレビュー**: インタラクティブモードでは、すべてのアクションが実行前にプレビューされます

4. **本番環境での使用**: 本番環境では特に慎重に権限を設定してください

### deny-toolの優先順位

`--deny-tool`は`--allow-all-tools`と`--allow-tool`より優先されます:
```bash
# rmは禁止される（deny-toolが優先）
copilot --allow-all-tools --deny-tool 'shell(rm)'
```

---

## システム要件

### 必須要件

- **Node.js**: v22以上
- **npm**: v10以上
- **PowerShell**: v6以上（Windowsのみ）
- **GitHub Copilotサブスクリプション**: アクティブなサブスクリプションが必要

### その他の要件

- 組織/エンタープライズの管理者がアクセスを無効化している場合は利用不可
- 各プロンプトは月間のプレミアムリクエストクォータから1リクエストを消費

---

## 追加情報

### 利用可能なコマンド（レガシー）

初期バージョンでは以下のサブコマンドが存在していましたが、現在の統合版では単一の`copilot`コマンドに統合されています:

- `config`: オプションの設定
- `explain`: コマンドの説明を取得
- `suggest`: コマンドの提案を取得

### モデル選択の強化

2025年10月のアップデートで、モデル選択が強化されました:
- Claude Sonnet 4.5
- Claude Sonnet 4
- GPT-5
- その他のモデル

### 画像サポート

GitHub Copilot CLIは画像の入力にも対応しており、スクリーンショットやダイアグラムを含むプロンプトも処理できます。

### コード検索の強化

2025年11月のアップデートで、コード検索機能が強化され、より高速で正確な検索が可能になりました。

---

## まとめ

GitHub Copilot CLIは、豊富なコマンドラインオプションを提供し、柔軟な使用方法を実現しています:

- **インタラクティブモード**で対話的に作業
- **プログラマティックモード**（`-p/--prompt`）でスクリプト化可能
- **ツール制御オプション**（`--allow-tool`, `--deny-tool`）でセキュアな実行
- **セッション管理**（`--resume`, `--continue`）で作業の継続性を確保
- **カスタムエージェント**（`--agent`）で専門的なタスクに対応

適切なオプションを組み合わせることで、安全かつ効率的にAI支援の開発作業が可能になります。

---

## 参考資料

### 公式ドキュメント

- [About GitHub Copilot CLI - GitHub Docs](https://docs.github.com/en/copilot/concepts/agents/about-copilot-cli)
- [Using GitHub Copilot CLI - GitHub Docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli)
- [GitHub Copilot CLI - GitHub Repository](https://github.com/github/copilot-cli)
- [GitHub Copilot CLI - Product Page](https://github.com/features/copilot/cli)

### アップデート情報

- [GitHub Copilot CLI is now in public preview - GitHub Changelog](https://github.blog/changelog/2025-09-25-github-copilot-cli-is-now-in-public-preview/)
- [GitHub Copilot CLI: Enhanced model selection, image support, and streamlined UI](https://github.blog/changelog/2025-10-03-github-copilot-cli-enhanced-model-selection-image-support-and-streamlined-ui/)
- [GitHub Copilot CLI: Faster, more concise, and prettier](https://github.blog/changelog/2025-10-10-github-copilot-cli-faster-more-concise-and-prettier/)
- [GitHub Copilot CLI: Use custom agents and delegate to Copilot coding agent](https://github.blog/changelog/2025-10-28-github-copilot-cli-use-custom-agents-and-delegate-to-copilot-coding-agent/)
- [GitHub Copilot CLI: New models, enhanced code search, and better image support](https://github.blog/changelog/2025-11-18-github-copilot-cli-new-models-enhanced-code-search-and-better-image-support/)

### ブログ記事

- [GitHub Copilot CLI: How to get started - The GitHub Blog](https://github.blog/ai-and-ml/github-copilot/github-copilot-cli-how-to-get-started/)
- [GitHub Copilot CLI 101: How to use GitHub Copilot from the command line](https://github.blog/ai-and-ml/github-copilot-cli-101-how-to-use-github-copilot-from-the-command-line/)
- [Boost your CLI skills with GitHub Copilot - The GitHub Blog](https://github.blog/developer-skills/programming-languages-and-frameworks/boost-your-cli-skills-with-github-copilot/)

### コミュニティ記事

- [Getting Started with GitHub Copilot in the CLI - DEV Community](https://dev.to/github/stop-struggling-with-terminal-commands-github-copilot-in-the-cli-is-here-to-help-4pnb)
- [Automating the Github Copilot Agent from the command line with Copilot CLI - R-bloggers](https://www.r-bloggers.com/2025/10/automating-the-github-copilot-agent-from-the-command-line-with-copilot-cli/)
- [GitHub Copilot CLI: Terminal AI Agent Development Guide 2025](https://vladimirsiedykh.com/blog/github-copilot-cli-terminal-ai-agent-development-workflow-complete-guide-2025)

---

**レポート作成日**: 2025年11月30日
**対象バージョン**: GitHub Copilot CLI (2025年11月時点の最新情報)
