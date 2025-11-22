# Test Generator Skill

包括的なテストコードを自動生成するClaude Code スキルです。

## 概要

ソースコードから高品質なユニットテスト、統合テスト、E2Eテストを自動生成します。TDDをサポートし、エッジケース、モック、アサーションを適切に含んだテストを作成します。

## 主な機能

- ✅ ユニットテスト、統合テスト、E2Eテスト生成
- ✅ Jest, pytest, JUnit等の主要フレームワーク対応
- ✅ エッジケースと境界値テストの自動検出
- ✅ モックオブジェクトの生成
- ✅ AAA パターン（Arrange-Act-Assert）
- ✅ テストデータとフィクスチャの生成
- ✅ 高カバレッジを達成するテスト設計

## クイックスタート

```
この関数のテストを生成してください：

function add(a, b) {
  return a + b;
}

フレームワーク: Jest
```

## サポートフレームワーク

- JavaScript/TypeScript: Jest, Vitest, Mocha, Cypress, Playwright
- Python: pytest, unittest
- Java: JUnit 5, TestNG, Mockito
- Go: testing, testify
- その他多数

## 詳細ドキュメント

詳しい使い方、生成例、ベストプラクティスは [skill.md](skill.md) を参照してください。

## バージョン

- Version: 1.0.0
- Last Updated: 2025-01-22
