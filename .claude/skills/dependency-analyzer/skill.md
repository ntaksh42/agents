# Dependency Analyzer Skill

プロジェクトの依存関係を分析するスキルです。

## 概要

依存関係のバージョン、脆弱性、ライセンス、アップデート可否を分析します。

## 主な機能

- **バージョン確認**: 最新版との比較
- **脆弱性スキャン**: CVE検出
- **ライセンス確認**: 互換性チェック
- **依存関係ツリー**: 視覚化
- **重複検出**: 同じパッケージの複数バージョン
- **未使用検出**: 使われていない依存関係

## 分析例

### package.json分析

```json
{
  "dependencies": {
    "express": "4.17.1",      // ⚠️ 最新: 4.18.2
    "lodash": "4.17.15",      // 🔴 CVE-2020-8203
    "react": "18.2.0",        // ✅ 最新
    "axios": "0.21.1"         // ⚠️ 最新: 1.6.0
  }
}
```

**分析結果**:

```markdown
## 依存関係分析レポート

### 🔴 Critical Issues (2)

1. **lodash@4.17.15**
   - CVE: CVE-2020-8203
   - 重大度: High
   - 推奨: 4.17.21以上にアップデート
   - 影響: Prototype Pollution

2. **axios@0.21.1**
   - CVE: CVE-2021-3749
   - 重大度: Medium
   - 推奨: 1.6.0にアップデート

### ⚠️ 更新可能 (2)

- express: 4.17.1 → 4.18.2
- axios: 0.21.1 → 1.6.0

### ライセンス確認

| Package | Version | License | Compatible |
|---------|---------|---------|------------|
| express | 4.17.1 | MIT | ✅ |
| lodash | 4.17.15 | MIT | ✅ |
| react | 18.2.0 | MIT | ✅ |

### 推奨アクション

```bash
npm update lodash
npm update axios
npm update express
```

### 依存関係ツリー

```
myapp
├── express@4.17.1
│   ├── body-parser@1.19.0
│   └── cookie@0.4.0
├── lodash@4.17.15 (⚠️ 脆弱性あり)
├── react@18.2.0
│   └── loose-envify@1.4.0
└── axios@0.21.1 (⚠️ 更新必要)
```
```

## コマンド例

### npm

```bash
# 脆弱性スキャン
npm audit

# 修正
npm audit fix

# 強制修正
npm audit fix --force

# 更新確認
npm outdated

# 依存関係ツリー
npm list

# 特定パッケージの依存
npm list express
```

### yarn

```bash
# 脆弱性スキャン
yarn audit

# 更新確認
yarn outdated

# 依存関係ツリー
yarn list

# 重複検出
yarn dedupe
```

### Python (pip)

```bash
# 更新確認
pip list --outdated

# 脆弱性スキャン
pip-audit

# 依存関係
pipdeptree
```

## ライセンス互換性

### MIT License
- ✅ 商用利用可能
- ✅ 改変可能
- ✅ 配布可能

### GPL License
- ⚠️ コピーレフト
- 派生物もGPL必須

### Apache 2.0
- ✅ 商用利用可能
- ✅ 特許保護

## バージョン情報

- スキルバージョン: 1.0.0
