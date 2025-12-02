# AI活用のススメ其の一 GitHub Copilot Instructions & Prompts

VSCodeから始めるGihub Copilot

---

## 1. 基本概念：2つのファイルタイプ

### `.instructions.md` - 継続的な自動ルール

```
用途: 「こうしてほしいを定める」
適用: 自動
例: XXXフォルダ以下は編集不可
```

### `.prompt.md` - カスタムコマンド

```
用途: 「定型タスクをコマンドとして実行」
適用: 手動
例: APIドキュメント生成
```

/Hoge のようにコマンドとして実行可能。

### 覚え方

- **instructions** = 交通ルール（常に守る）
- **prompts** = カーナビ（必要な時使う）

---

## 2. いつ使うか？

### Instructions を書くべき時

✅ **Copilotにこう動いてほしい。を決めたい時。**

- 「推測は推測と言って」
- 「テストはAAA形式で」
- 「この部分は編集しないで」

### Prompts を書くべき時

✅ **プロンプト何度も入力するの面倒な時。**
- APIドキュメント生成
- コードレビュー
- テストケース追加

---

## 3. ファイル配置

### 基本構成

```
.github/
├── copilot-instructions.md              # プロジェクト全体の共通ルール
│
├── instructions/                        # 自動適用ルール
│   ├── typescript.instructions.md       # TS専用
│   ├── testing.instructions.md          # テスト専用
│   └── react.instructions.md            # React専用
│
└── prompts/                             # 手動実行タスク
    ├── api-docs.prompt.md               # API文書生成
    ├── code-review.prompt.md            # コードレビュー
    └── generate-tests.prompt.md         # テスト生成
```

---

## 4. Instructions の書き方

### テンプレート

```markdown
---
applyTo:
  - "src/**/*.ts"        # 適用対象
  - "!**/*.test.ts"      # 除外対象
---

# ルール名

## カテゴリ1
- ルール1
- ルール2

## カテゴリ2
- ルール3
```

### 実例：TypeScript

**ファイル**: `.github/instructions/typescript.instructions.md`

```markdown
---
applyTo:
  - "src/**/*.ts"
  - "src/**/*.tsx"
  - "!**/*.test.ts"
---

# TypeScript開発ルール

## 型定義
- すべての関数に引数と戻り値の型を明示
- `any`は禁止、`unknown`を使用
- Optional Chaining (`?.`) を優先

## 命名規則
- Interface/Type: PascalCase
- 変数/関数: camelCase
- 定数: UPPER_SNAKE_CASE
```

### 実例：テスト

**ファイル**: `.github/instructions/testing.instructions.md`

```markdown
---
applyTo:
  - "**/*.test.ts"
  - "**/*.spec.ts"
---

# テスト作成ルール

## AAA Pattern 必須

```typescript
test('テスト内容を日本語で', () => {
  // Arrange（準備）
  const data = ...;

  // Act（実行）
  const result = ...;

  // Assert（検証）
  expect(result).toBe(...);
});
```

## モック
- 外部APIは必ずモック
- `jest.mock()`を使用
```

---

## 5. Prompts の書き方

### テンプレート

```markdown
---
mode: 'agent'
tools: ['githubRepo', 'search/codebase']
description: '何をするか'
---

# プロンプト名

タスクの説明: ${input:変数名:説明}

## 要件
1. ...
2. ...

## 出力形式
...
```

### 実例:APIドキュメント生成

**ファイル**: `.github/prompts/api-docs.prompt.md`

```markdown
---
mode: 'agent'
tools: ['githubRepo', 'search/codebase']
description: 'Generate API documentation'
---

# API Documentation Generator

対象エンドポイント: ${input:endpoint:/api/users/{id}}

## 生成内容
- HTTPメソッドとパス
- リクエスト/レスポンススキーマ
- エラーコード
- 使用例

## 出力形式
OpenAPI 3.0 YAML
```

**使い方**:
```
1. VS Code Copilot Chatを開く
2. /api-docs と入力
3. エンドポイント入力
4. 自動生成
```

### 実例：コードレビュー

**ファイル**: `.github/prompts/code-review.prompt.md`

```markdown
---
mode: 'agent'
tools: ['problems', 'search/codebase']
description: 'Perform code review'
---

# Code Review Checklist

対象: ${input:target:#selection or #file:path}

## チェック項目

### コード品質
- [ ] 命名規則は適切か
- [ ] 重複コードはないか
- [ ] 関数の責任は単一か

### 型安全性
- [ ] anyは使用していないか
- [ ] 型定義は完全か

### セキュリティ
- [ ] XSS対策は十分か
- [ ] 機密情報のハードコードはないか

## 出力
各項目に ✅ / ⚠️ / ❌ で評価
```

**使い方**:
```
1. レビュー対象コードを選択
2. /code-review と入力
3. #selection と入力
4. 自動レビュー実行
```

---
## 6. よくある質問

### Q1: Instructionsが適用されない

**確認事項**:
```
1. ファイルパターン（applyTo）は正しいか
2. VS Code設定で有効化されているか
   "github.copilot.chat.codeGeneration.useInstructionFiles": true
3. Copilot Chatのレスポンスで「References」に表示されるか
```

### Q2: Promptが見つからない

**確認事項**:
```
1. 配置: .github/prompts/ 配下か
2. 拡張子: *.prompt.md か
3. VS Code再起動
```

### Q3: Instructions vs Prompts どっち？

**判断フロー**:
```
質問: このルール/タスクは...

ファイル編集のたびに適用すべき？
└─ YES → instructions

必要な時だけ実行したい？
└─ YES → prompts
```

---

## 7. 実践編

### 最初にやること

- [ ] `.github/copilot-instructions.md` 作成
- [ ] よく使うタスクを1つ `.prompt.md` 化
- [ ] 100行を超えたらファイル分割検討

### 形になってきたら

- [ ] チーム全体に展開

### 継続的改善

- [ ] 月次でチームレビュー実施
- [ ] 使用頻度の低いルールを削除
- [ ] 新規ルール/プロンプトの提案受付
- [ ] 効果測定（コードレビュー時間、PR品質）

---

## 8. 参考リソース

### 公式サンプル
- [Awesome GitHub Copilot](https://github.com/github/awesome-copilot) - コミュニティのベストプラクティス集
- [VS Code Copilot Docs](https://code.visualstudio.com/docs/copilot/copilot-customization)
- [Azure DevOps MCP Server](https://github.com/microsoft/azure-devops-mcp)
