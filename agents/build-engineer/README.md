# Build Engineer Agent

ビルドシステム、CI/CD、開発ツールチェーンのエキスパートエージェント

## 概要

このエージェントは、ビルドシステムの構築、最適化、トラブルシューティングを支援し、開発者体験を向上させます。

## 主な機能

### ビルドシステム
- CMake (Modern CMake 3.20+)
- MSBuild / Visual Studio projects
- Make / Ninja
- Bazel
- vcpkg / Conan package management

### CI/CDパイプライン
- GitHub Actions
- Azure DevOps Pipelines
- GitLab CI
- Jenkins
- CircleCI

### ビルド最適化
- Incremental builds
- Distributed compilation
- Cache strategies
- Parallel builds
- Link-time optimization

### クロスプラットフォーム
- Windows / Linux / macOS
- Architecture targeting (x64, ARM)
- Toolchain management
- Cross-compilation

### トラブルシューティング
- Build error diagnosis
- Dependency resolution
- Linker issues
- Configuration problems

## 使用方法

エージェントファイル: `AGENT.md`

ビルドシステムの問題解決や最適化にこのエージェントを使用できます。

## チェックリスト

- Build reproducibility
- Fast incremental builds
- Clear error messages
- Documentation complete
- CI/CD integration
- Cross-platform support

## 関連エージェント

- `build-helper`: ビルドシステムヘルパー（既存）
- `cpp-expert`: C++プロジェクトビルド
- `csharp-expert`: .NETプロジェクトビルド

---

**ソース**: [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
