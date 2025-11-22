# Document Formatter Skill - 使い方ガイド

ドキュメントの体裁を整え、美しく読みやすいフォーマットに変換するスキルです。

## クイックスタート

### 1. 基本的な整形

Claude Codeで以下のようにリクエストします：

```
以下のMarkdownを整形してください：

[乱れたMarkdownを貼り付け]
```

### 2. 目次の追加

```
このドキュメントに目次を追加してください。
```

### 3. HTML変換

```
このMarkdownをGitHub風のHTMLに変換してください。
```

## ファイル構成

```
.claude/skills/document-formatter/
├── skill.md                  # スキルの説明
├── template-formatted.html   # 整形されたHTMLテンプレート
├── example-before-after.html # 整形前後の比較サンプル
└── README.md                 # このファイル
```

## 整形機能

### 見出しの整形

**問題のある見出し構造**:
```markdown
### はじめに
# プロジェクト名
#### 詳細
## 機能
```

**リクエスト**:
```
この見出し構造を修正してください。
```

**整形後**:
```markdown
# プロジェクト名

## はじめに

## 機能

### 詳細
```

### リストの整形

**乱れたリスト**:
```markdown
* 項目1
  - サブ項目1-1
    * サブサブ項目
-項目2
   + サブ項目2-1
```

**リクエスト**:
```
このリストを整形してください。
マーカー: ハイフン統一
インデント: 2スペース
```

**整形後**:
```markdown
- 項目1
  - サブ項目1-1
    - サブサブ項目
- 項目2
  - サブ項目2-1
```

### コードブロックの整形

**言語指定なし**:
```markdown
```
function hello() {
console.log("Hello");
}
```
```

**リクエスト**:
```
コードブロックに言語指定を追加して、フォーマットしてください。
```

**整形後**:
```markdown
​```javascript
function hello() {
  console.log("Hello");
}
​```
```

### テーブルの整形

**崩れたテーブル**:
```markdown
|名前|年齢|職業|
|-|-|-|
|田中|30|エンジニア|
|佐藤|25|デザイナー|
```

**リクエスト**:
```
このテーブルを整列してください。
```

**整形後**:
```markdown
| 名前 | 年齢 | 職業         |
|------|------|--------------|
| 田中 | 30   | エンジニア   |
| 佐藤 | 25   | デザイナー   |
```

## 目次生成

### 自動目次

**リクエスト**:
```
このドキュメントに目次を追加してください。
```

**生成される目次**:
```markdown
## 目次

1. [はじめに](#はじめに)
2. [インストール](#インストール)
   1. [前提条件](#前提条件)
   2. [手順](#手順)
3. [使用方法](#使用方法)
4. [FAQ](#faq)
```

### カスタム目次

**リクエスト**:
```
目次を生成してください：
- H2とH3のみ含める
- 番号なし（箇条書き）
- 「謝辞」セクションは除外
```

**生成例**:
```markdown
## 目次

- [はじめに](#はじめに)
  - [背景](#背景)
  - [目的](#目的)
- [機能](#機能)
  - [主要機能](#主要機能)
  - [追加機能](#追加機能)
```

## スタイルガイド適用

### Google Style Guide

**リクエスト**:
```
Google Developer Style Guideに従って整形してください。
```

**整形内容**:
- アクティブボイスを使用
- 第二人称（you）で記述
- 簡潔で明確な文章
- 手順は命令形

**整形前**:
```markdown
The installation can be performed by running the command.
It is recommended that you backup your data.
```

**整形後**:
```markdown
Run the command to install.
Back up your data before proceeding.
```

### Microsoft Style Guide

**リクエスト**:
```
Microsoft Writing Style Guideを適用してください。
```

**整形内容**:
- 見出しは文頭のみ大文字（Sentence case）
- 並列構造のリスト
- 明確な指示語

**整形前**:
```markdown
## How To Install The Software

Steps:
- Installing
- Configuration
- To run the application
```

**整形後**:
```markdown
## How to install the software

Steps:
1. Install the software
2. Configure the settings
3. Run the application
```

## HTML変換

### GitHub風スタイル

**リクエスト**:
```
このMarkdownをGitHub風のHTMLに変換してください。
```

**生成されるHTML**:
- GitHub Markdownと同じスタイル
- シンタックスハイライト付きコード
- レスポンシブテーブル
- 印刷最適化

### プロフェッショナルスタイル

**リクエスト**:
```
ビジネス文書用のHTMLに変換：
- ヘッダー: 会社名
- フッター: ページ番号
- 目次: 自動生成
- 印刷: A4サイズ最適化
```

### 技術文書スタイル

**リクエスト**:
```
API仕様書スタイルのHTMLに変換：
- サイドバーナビゲーション
- コードのコピーボタン
- 検索機能
- ダークモード対応
```

## 実践例

### 例1: 乱れたREADMEの整形

**元のREADME**（問題点多数）:
```markdown
###My Project
This is my project

##Install
Run npm install

Features
* feature 1
  - sub feature
*feature 2

##Usage
```
const app = require('./app')
```

|Name|Description|
|-|-|
|app|main app|
|config|config file|
```

**リクエスト**:
```
このREADMEを整形してください：
- 見出し構造を修正
- 目次を追加
- コードブロックに言語指定
- テーブルを整列
- リストのインデント統一
```

**整形後**:
```markdown
# My Project

## 目次

1. [概要](#概要)
2. [インストール](#インストール)
3. [機能](#機能)
4. [使用方法](#使用方法)

## 概要

This is my project

## インストール

Run npm install

## 機能

- Feature 1
  - Sub feature
- Feature 2

## 使用方法

​```javascript
const app = require('./app');
​```

## API

| Name   | Description |
|--------|-------------|
| app    | Main app    |
| config | Config file |
```

### 例2: 技術文書のHTML化

**リクエスト**:
```
このAPI仕様書を技術文書スタイルのHTMLに変換：
- サイドバーナビゲーション
- コードハイライト（Monokai テーマ）
- 各エンドポイントにアンカーリンク
- コピーボタン付きコード例
```

### 例3: 会議メモの整形

**元のメモ**（箇条書きのみ）:
```
会議メモ
日時 2024-06-15
参加者 田中、佐藤、鈴木

議題
新機能について
スケジュール
予算

決定事項
新機能Aを実装する
7月末リリース
予算500万円

TODO
田中: 要件定義 6/20
佐藤: デザイン 6/25
```

**リクエスト**:
```
この会議メモを整形されたドキュメントに：
- 適切な見出し構造
- テーブル形式の参加者リスト
- チェックボックス付きTODOリスト
- フロントマター追加
```

**整形後**:
```markdown
---
title: 新機能に関する会議
date: 2024-06-15
attendees: [田中, 佐藤, 鈴木]
---

# 新機能に関する会議

## 会議情報

| 項目     | 内容           |
|----------|----------------|
| 日時     | 2024-06-15     |
| 参加者   | 田中、佐藤、鈴木 |

## 議題

1. 新機能について
2. スケジュール
3. 予算

## 決定事項

- 新機能Aを実装する
- リリース予定: 2024年7月末
- 予算: 500万円

## アクションアイテム

- [ ] **要件定義** - 担当: 田中 - 期限: 6/20
- [ ] **デザイン** - 担当: 佐藤 - 期限: 6/25
```

### 例4: 複数ファイルの統一

**リクエスト**:
```
以下の3つのMarkdownファイルを統一されたスタイルで整形：

ファイル1: README.md
ファイル2: API.md
ファイル3: CONTRIBUTING.md

統一ルール:
- スタイルガイド: Google
- 見出し: ATXスタイル
- リスト: ハイフン、2スペースインデント
- コード: 言語指定必須
- 目次: すべてのファイルに追加
```

## コードハイライト

### 基本的な使い方

**リクエスト**:
```
コードブロックに適切なシンタックスハイライトを追加してください。
```

### 特定行のハイライト

**リクエスト**:
```
このコードブロックで2-3行目をハイライトしてください：

​```javascript
function calculate(a, b) {
  const sum = a + b;
  const product = a * b;
  return { sum, product };
}
​```
```

**整形後**:
```markdown
​```javascript {2-3}
function calculate(a, b) {
  const sum = a + b;       // ← ハイライト
  const product = a * b;   // ← ハイライト
  return { sum, product };
}
​```
```

### 差分表示

**リクエスト**:
```
変更前後のコードを差分形式で表示してください。
```

**出力**:
```diff
  function hello(name) {
-   console.log("Hello");
+   console.log(`Hello, ${name}!`);
  }
```

## リンク検証

**リクエスト**:
```
このドキュメントのリンクを検証してください。
```

**出力例**:
```
リンク検証結果:

✓ [GitHub](https://github.com) - OK (200)
✓ [Documentation](#documentation) - OK (内部リンク)
✗ [Old API](https://api.old-domain.com) - Not Found (404)
? [Section](#nonexistent) - アンカーが見つかりません

修正提案:
1. https://api.old-domain.com → https://api.new-domain.com
2. #nonexistent → 削除または正しいアンカーに修正
```

## 画像最適化

**リクエスト**:
```
画像のaltテキストを追加し、適切なサイズ指定をしてください。
```

**整形前**:
```markdown
![](screenshot.png)
![](logo.png)
```

**整形後**:
```markdown
![アプリケーションのスクリーンショット](screenshot.png)

<p align="center">
  <img src="logo.png" alt="プロジェクトロゴ" width="200">
</p>
```

## 特殊機能

### フロントマター追加

**リクエスト**:
```
このドキュメントにYAMLフロントマターを追加してください。
```

**出力**:
```yaml
---
title: "ドキュメントタイトル"
author: "作成者名"
date: 2024-06-15
tags: [markdown, documentation, guide]
version: 1.0
---

# ドキュメント本文
```

### 脚注の追加

**リクエスト**:
```
この文章に脚注を追加してください：
「TypeScriptは型安全なJavaScriptのスーパーセットです。」
```

**出力**:
```markdown
TypeScriptは型安全なJavaScriptのスーパーセット[^1]です。

[^1]: TypeScript は Microsoft によって開発された
      オープンソースのプログラミング言語です。
```

### タスクリスト

**リクエスト**:
```
このTODOリストをMarkdownのタスクリストに変換してください。
```

**出力**:
```markdown
## タスク

- [x] プロジェクト初期化
- [x] 環境構築
- [ ] 機能実装
  - [x] ユーザー認証
  - [ ] データベース設計
  - [ ] API実装
- [ ] テスト作成
- [ ] ドキュメント作成
```

## カスタマイズ

### カスタムルールの定義

**リクエスト**:
```
以下のカスタムルールで整形してください：

- 見出し: すべてタイトルケース（各単語の頭文字を大文字）
- リスト: 常に番号付き
- コード: 必ず言語指定 + 行番号
- リンク: すべて新しいタブで開く
- 改行: 見出しの前後は3行空ける
```

### テンプレートの使用

**リクエスト**:
```
このMarkdownをカスタムHTMLテンプレートで変換：

テンプレート:
- ヘッダー: ロゴ + ナビゲーション
- サイドバー: 目次
- メイン: コンテンツ
- フッター: コピーライト
```

## トラブルシューティング

### テーブルが崩れる

**問題**: パイプ文字が含まれるセル

**解決**:
```markdown
整形前: | Code | Description |
        | `a|b` | OR operator |  ← 崩れる

整形後: | Code  | Description  |
        | `a\|b` | OR operator |  ← エスケープ
```

### コードブロックが正しく表示されない

**問題**: バックティックの数が不足

**解決**:
```markdown
整形前:
```
code with ` backtick
```  ← 正しく閉じない

整形後:
​````
code with ` backtick
​````  ← 4つのバックティックで囲む
```

### 日本語の折り返しがおかしい

**リクエスト**:
```
HTML変換時に日本語の折り返しを最適化してください。
```

**CSS追加**:
```css
word-break: keep-all;
overflow-wrap: break-word;
```

## ベストプラクティス

### 1. 整形前にバックアップ

```
重要: 元のファイルは必ずバックアップしてください。

整形によって意図しない変更が発生する可能性があります。
```

### 2. 段階的な整形

```
一度にすべてを整形せず、段階的に：

1. まず見出し構造を修正
2. 次にリストを整形
3. コードブロックを修正
4. 最後に細かい調整
```

### 3. スタイルガイドの選択

```
プロジェクトの性質に合わせて選択：

- 技術文書 → Google Style Guide
- ビジネス文書 → Microsoft Style Guide
- 学術論文 → APA Style
- ニュース記事 → AP Stylebook
```

### 4. 一貫性の維持

```
同じプロジェクト内では：

- 同じスタイルガイドを使用
- 同じインデント設定
- 同じリストマーカー
- 同じ見出しスタイル
```

## コマンド例集

### クイックコマンド

```bash
# 基本整形
"このMarkdownを整形してください"

# 目次追加
"目次を追加してください"

# HTML変換
"GitHub風のHTMLに変換してください"

# テーブル整形
"テーブルを綺麗に整列してください"

# コードハイライト
"コードブロックに言語指定を追加してください"

# リンク検証
"リンクを検証して、壊れたリンクを報告してください"

# スタイル適用
"Google Style Guideを適用してください"

# 総合整形
"このドキュメントを完全に整形してください：
- 見出し構造修正
- 目次追加
- コードハイライト
- テーブル整列
- リンク検証
- HTML変換"
```

## よくある質問

### Q: どのMarkdown形式をサポートしていますか？

**A:** 以下の形式をサポートしています：
- CommonMark（標準）
- GitHub Flavored Markdown (GFM)
- Markdown Extra
- MultiMarkdown

### Q: PDFに変換できますか？

**A:** はい、可能です：
```
このMarkdownをPDFに変換してください：
ページサイズ: A4
マージン: 標準
目次: 有効
ページ番号: 下部中央
```

### Q: 既存のスタイルを保持できますか？

**A:** はい、オプションで指定できます：
```
このドキュメントを整形してください：
保持: 既存の強調表示、カスタムHTML
変更: 見出し構造、リストのみ
```

### Q: 大量のファイルを一括整形できますか？

**A:** 複数ファイルの指定が可能です：
```
以下のファイルを一括整形：
- docs/*.md
スタイル: Google
出力先: docs/formatted/
```

## 参考リンク

- [CommonMark Spec](https://commonmark.org/)
- [GitHub Flavored Markdown Spec](https://github.github.com/gfm/)
- [Google Developer Documentation Style Guide](https://developers.google.com/style)
- [Microsoft Writing Style Guide](https://docs.microsoft.com/style-guide)
- [Markdown Guide](https://www.markdownguide.org/)

## ライセンス

- このスキル: MIT License

---

**美しいドキュメントを作成してください！** ✨📄
