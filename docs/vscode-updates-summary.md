# VSCode 最新アップデート内容まとめ

## 概要

Visual Studio Code（VSCode）の最新バージョンにおける主要なアップデート内容をまとめたドキュメントです。特にC#/C++開発者やGitHub Copilotユーザーに関連する機能を中心に解説しています。

## 最新バージョンの主要機能

### 1. GitHub Copilot の機能強化

#### 1.1 マルチモデル対応
- **複数のAIモデルを選択可能**
  - GPT-4.1, GPT-5, Claude Sonnet 4.5, Claude Opus 4.5など
  - Autoモードで自動的に最適なモデルを選択
  - タスクに応じて適切なモデルを使い分け可能

#### 1.2 Agentモードの強化
- **4つのモードから選択可能**
  - **Ask**: 質問・調査モード
  - **Edit**: 手動編集モード
  - **Agent**: 自律実行モード（推奨）
  - **Plan**: 計画モード
- ファイル選択から編集まで自動化された開発体験

#### 1.3 Next Edit Suggestions
- Cursor Tab風の編集予測機能
- 次に編集すべき箇所を自動で提案
- 設定: `github.copilot.nextEditSuggestions.enabled: true`

#### 1.4 反復的編集機能
- 複数の編集を連続して実行
- コンテキストを保持しながら段階的な改善が可能
- 設定: `github.copilot.editor.iterativeEditing: true`

#### 1.5 カスタム指示ファイル対応
- `.github/copilot-instructions.md` でプロジェクト固有のルールを定義
- すべてのCopilot Chatリクエストに自動適用
- チーム全体で一貫した開発スタイルを維持

#### 1.6 .prompt.md ファイル対応
- 再利用可能なカスタムプロンプトをファイル化
- スラッシュコマンドとして実行可能
- YAML frontmatterで詳細設定が可能

### 2. Model Context Protocol (MCP) 統合

#### 2.1 外部サービス連携
- AIエージェントと外部データ・ツールを接続
- Azure DevOps, Dataverse, NuGetなどのMCPサーバーに対応
- 自然言語で外部リソースを操作可能

#### 2.2 ワンクリックインストール
- MCPサーバーの簡単なセットアップ
- Azure DevOps MCPなどが利用可能
- GitHub Copilotから直接外部サービスにアクセス

### 3. チャット履歴管理

#### 3.1 履歴の保存と再開
- 過去の会話を保存・検索・再開
- Chat Viewから「Show Chats...」で履歴にアクセス
- 長期的なプロジェクト管理に便利

#### 3.2 エクスポート機能
- JSON形式でのエクスポート
- Markdown形式でのコピー
- プロンプトとして保存して再利用可能

### 4. エディタ機能の改善

#### 4.1 コードアクション統合
- Copilotコマンドがコードアクションに統合
- 右クリックメニューから直接実行
- 設定: `github.copilot.editor.enableCodeActions: true`

#### 4.2 リネーム提案
- 変数・関数名のリネーム時に自動提案
- コンテキストに基づいた適切な命名
- 設定: `github.copilot.renameSuggestions.triggerAutomatically: true`

#### 4.3 インライン補完の改善
- より高精度な補完提案
- 複数の提案を比較可能（Ctrl + Enter）
- コンテキストを理解した長文の補完

### 5. ターミナル統合

#### 5.1 @terminal エージェント
- ターミナル操作をAIが支援
- コマンドの自動生成と実行
- エラーの自動解析と修正提案

#### 5.2 コマンドの自動承認
- よく使うコマンドを自動実行
- 設定: `chat.tools.terminal.autoApprove: true`
- セキュリティとのバランスを考慮

#### 5.3 ターミナルコンテキスト参照
- `#terminalLastCommand`: 最後に実行したコマンド
- `#terminalSelection`: ターミナルの選択範囲
- エラー解決が迅速化

### 6. ワークスペース検索の強化

#### 6.1 @workspace エージェント
- ワークスペース全体を横断検索
- セマンティック検索による高精度な結果
- コードベース全体の理解を支援

#### 6.2 シンボル検索
- `#symbolName` で特定のクラス・関数を参照
- 定義箇所へのジャンプ
- 関連コードの自動収集

### 7. C#/C++ 開発者向け機能

#### 7.1 言語サーバー統合
- C#: OmniSharp, C# Dev Kit対応
- C++: clangd, Microsoft C/C++ Extension対応
- インテリセンスとCopilotの連携強化

#### 7.2 ビルドシステム対応
- CMake統合の改善
- MSBuildプロジェクトのサポート
- vcpkgパッケージ管理の支援

#### 7.3 デバッグ体験の向上
- デバッガーとCopilotの連携
- エラーメッセージの自動解析
- 修正提案の精度向上

### 8. パフォーマンス最適化

#### 8.1 起動速度の改善
- 拡張機能の遅延読み込み
- 軽量化されたエディタコア
- より高速なファイル検索

#### 8.2 メモリ使用量の削減
- 大規模プロジェクトでの安定性向上
- キャッシュ管理の最適化
- バックグラウンドプロセスの効率化

### 9. UI/UX の改善

#### 9.1 チャットインターフェース
- より直感的なチャットUI
- コードブロックのシンタックスハイライト
- 実行可能なコマンドボタン

#### 9.2 インラインチャット
- エディタ内で直接対話
- ショートカット: `Ctrl + I`
- コンテキストを保持した編集

#### 9.3 Quick Chat
- 軽量なチャットウィンドウ
- ショートカット: `Ctrl + Alt + I`
- 素早い質問に最適

### 10. セキュリティとプライバシー

#### 10.1 コード除外設定
- 特定のファイル・フォルダをCopilotから除外
- 機密情報の保護
- 設定ファイルで細かく制御

#### 10.2 ローカル実行オプション
- 一部の機能をローカルで実行
- クラウド送信を最小化
- エンタープライズ向けセキュリティ強化

## 推奨設定

### 必須設定

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

### 便利な設定

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

### 高度な設定

```json
{
  // Claude 3.7 Sonnet等の高度な推論を有効化
  "copilot.chat.agent.thinkingTool": true,
  
  // 反復的な編集提案
  "github.copilot.editor.iterativeEditing": true,
  
  // 代替プロンプト戦略を有効化（実験的機能）
  "github.copilot.chat.alternateGptPrompt.enabled": true,
  
  // ターミナルコマンドを自動承認
  "chat.tools.terminal.autoApprove": true
}
```

## C#/C++ 開発者向けのベストプラクティス

### 1. プロジェクト構造の最適化

```markdown
# .github/copilot-instructions.md

## プロジェクト概要
C#とC++を組み合わせたデスクトップアプリケーション開発プロジェクト

## 技術スタック
- C#: .NET 8.0, WPF
- C++: C++20, CMake, vcpkg
- テスト: xUnit (C#), Google Test (C++)

## コーディング規約
- C#: Microsoft C# Coding Conventions
- C++: C++ Core Guidelines
- すべてのpublicメソッドにXMLコメント/Doxygenコメントを記述

## 禁止事項
- C#: dynamic型の使用は最小限に、型安全性を優先
- C++: rawポインタの使用を避け、スマートポインタ（unique_ptr、shared_ptr）を使用
- C++: void*ポインタの使用は最小限に
```

### 2. 効率的なワークフロー

```
# 新機能開発
1. @workspace 既存の実装パターンを確認
2. /new 新しいクラス・コンポーネント作成
3. /tests テストコード生成
4. /doc ドキュメント追加

# バグ修正
1. #terminalLastCommand エラーを分析
2. @workspace 関連コードを検索
3. /fix 問題を修正
4. /tests 修正箇所のテスト追加

# リファクタリング
1. #selection をリファクタリング対象として指定
2. /explain まず現在の実装を理解
3. 段階的に改善を指示
4. /tests テストで動作確認
```

### 3. カスタムプロンプトの活用

```markdown
# .github/prompts/review-cpp.prompt.md
---
name: review-cpp
description: C++コードレビュー実行
agent: agent
---

選択されたC++コードをレビューしてください。

## チェック項目
- メモリ安全性（メモリリーク、ダングリングポインタ）
- RAII パターンの適用
- スマートポインタの使用
- const correctness
- 例外安全性
- パフォーマンス最適化の余地
- C++ Core Guidelinesへの準拠
```

## まとめ

VSCodeの最新アップデートは、特にAI支援開発機能において大幅な改善が行われています。GitHub Copilotのマルチモデル対応、MCPによる外部サービス連携、カスタム指示ファイルなど、開発者の生産性を大きく向上させる機能が追加されました。

C#/C++開発者にとっては、言語サーバー統合の強化、ビルドシステム対応の改善、デバッグ体験の向上など、実用的な改善が多く含まれています。

これらの新機能を活用することで、より効率的で高品質な開発が可能になります。

## 参考リソース

- [VSCode Release Notes](https://code.visualstudio.com/updates)
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Visual Studio Code Tips and Tricks](https://code.visualstudio.com/docs/getstarted/tips-and-tricks)
- [C# Dev Kit Documentation](https://code.visualstudio.com/docs/csharp/get-started)
- [C/C++ Extension Documentation](https://code.visualstudio.com/docs/languages/cpp)

## 更新履歴

- 2025-12-13: 初版作成 - 最新のVSCode機能とGitHub Copilot統合についてまとめ
