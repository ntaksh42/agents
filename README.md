# Agents for C#/C++ Development

C#およびC++のPCアプリケーション開発を支援するAIエージェントのコレクションです。

## 📋 概要

このリポジトリは、デスクトップアプリケーション開発における様々な課題を解決するための専門的なAIエージェントを提供します。各エージェントは特定の開発タスクに特化しており、開発効率の向上とコード品質の改善を目指しています。

## 🎯 対象開発者

- **C#開発者**: WPF、WinForms、.NET Core/5+ アプリケーション
- **C++開発者**: Windows デスクトップアプリ、クロスプラットフォームアプリ
- **ハイブリッド開発者**: C#とC++を組み合わせたアプリケーション

## 🤖 利用可能なエージェント

### 優先度：高

#### 1. Memory Safety Analyzer
C++のメモリ関連問題を検出・修正するエージェント
- メモリリーク検出
- ダングリングポインタの識別
- バッファオーバーフロー防止
- スマートポインタ使用の推奨
- RAII パターンの適用支援

**状態**: 🚧 開発予定

#### 2. Interop Expert
C#とC++の相互運用を支援するエージェント
- P/Invoke コード生成
- C++/CLI インターフェース作成
- マーシャリング最適化
- 型変換の自動化
- パフォーマンス最適化提案

**状態**: 🚧 開発予定

#### 3. Build System Helper
ビルドシステムの構築・最適化を支援するエージェント
- CMake 設定生成・最適化
- MSBuild プロジェクト管理
- vcpkg パッケージ管理
- クロスプラットフォームビルド設定
- ビルドエラーのトラブルシューティング

**状態**: 🚧 開発予定

### 優先度：中

#### 4. Windows Desktop Expert
Windows デスクトップUI開発支援エージェント
- WPF XAML コード生成
- WinForms デザイン支援
- Win32 API 活用ガイド
- MVVMパターン実装支援
- UI/UXベストプラクティス

**状態**: 🚧 開発予定

#### 5. Performance Profiler Assistant
パフォーマンス最適化支援エージェント
- ボトルネック分析
- アルゴリズム最適化提案
- SIMD最適化
- 並列処理の提案
- メモリ使用量削減

**状態**: 🚧 開発予定

#### 6. Unit Test Generator
単体テストコード自動生成エージェント
- C# テスト生成（xUnit, NUnit, MSTest）
- C++ テスト生成（Google Test, Catch2）
- モックオブジェクト作成
- テストカバレッジ向上支援

**状態**: 🚧 開発予定

### 優先度：低（将来計画）

7. **Legacy Code Modernizer** - レガシーコードの現代化
8. **API Documentation Generator** - API ドキュメント自動生成
9. **Cross-Platform Compatibility Checker** - クロスプラットフォーム互換性チェック
10. **Dependency Analyzer** - 依存関係分析・最適化

## 📁 リポジトリ構造

```
agents/
├── README.md                    # このファイル
├── docs/                        # ドキュメント
│   ├── setup.md                # セットアップガイド
│   └── agent-development-guide.md  # Agent開発ガイド
├── agents/                      # Agentディレクトリ
│   ├── memory-safety/          # Memory Safety Analyzer
│   ├── interop-expert/         # Interop Expert
│   ├── build-helper/           # Build System Helper
│   ├── windows-desktop/        # Windows Desktop Expert
│   ├── performance/            # Performance Profiler Assistant
│   └── test-generator/         # Unit Test Generator
├── templates/                   # 再利用可能なテンプレート
│   ├── cmake/                  # CMake テンプレート
│   ├── csharp-project/         # C# プロジェクトテンプレート
│   └── cpp-project/            # C++ プロジェクトテンプレート
└── examples/                    # 使用例
    └── sample-projects/        # サンプルプロジェクト
```

## 🚀 クイックスタート

### 前提条件

- Claude Code CLI またはClaude Agent SDK
- （エージェントによって）C#開発環境、C++開発環境

### 使用方法

各エージェントのディレクトリに移動し、READMEの指示に従ってください。

```bash
# 例: Memory Safety Analyzer の使用
cd agents/memory-safety
# エージェントのREADMEを参照
```

詳細は [セットアップガイド](docs/setup.md) を参照してください。

## 📖 ドキュメント

- [セットアップガイド](docs/setup.md) - 環境構築手順
- [LSP 環境構築ガイド](docs/lsp-setup-guide.md) - Claude Code での LSP 設定
- [Agent開発ガイド](docs/agent-development-guide.md) - 新しいAgentの作成方法

## 🤝 貢献

このリポジトリは個人的なAgentコレクションとして管理されていますが、アイデアや改善提案は歓迎します。

## 📝 ライセンス

MIT License

## 🔄 更新履歴

- 2025-11-22: リポジトリ初期化、基本構造作成

---

**開発者ノート**: C#/C++のPCアプリケーション開発における実際の課題解決を目的として構築されています。
