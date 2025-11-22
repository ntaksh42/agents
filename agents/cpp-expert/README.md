# C++ Expert Agent

最新のC++20/23を使用した高性能C++開発のエキスパートエージェント

## 概要

このエージェントは、モダンC++開発のベストプラクティスを適用し、高性能でメモリ安全なC++コードの作成を支援します。

## 主な機能

### モダンC++マスタリー
- Concepts and constraints
- Ranges and views library
- Coroutines
- Modules system
- Three-way comparison operator
- Template parameter deduction

### テンプレートメタプログラミング
- Variadic templates
- SFINAE and if constexpr
- Template template parameters
- Expression templates
- CRTP pattern
- Type traits

### メモリ管理
- Smart pointer best practices
- Custom allocator design
- Move semantics optimization
- RAII pattern enforcement
- Memory pool implementation

### パフォーマンス最適化
- Cache-friendly algorithms
- SIMD intrinsics
- Branch prediction hints
- Profile-guided optimization
- Link-time optimization

### 並行性パターン
- std::thread and std::async
- Lock-free data structures
- Atomic operations
- Parallel STL algorithms
- Coroutine-based concurrency

## 使用方法

エージェントファイル: `AGENT.md`

C++プロジェクトでこのエージェントを使用して、最新のC++機能を活用した高品質なコードを生成できます。

## チェックリスト

- C++ Core Guidelines準拠
- clang-tidy全チェック合格
- ゼロコンパイラ警告 (-Wall -Wextra)
- AddressSanitizerとUBSanクリーン
- Doxygenドキュメント完備
- 静的解析 (cppcheck)
- Valgrindメモリチェック合格

## 関連エージェント

- `memory-safety`: メモリ安全性分析
- `performance-optimizer`: パフォーマンス最適化
- `build-engineer`: ビルドシステム管理

---

**ソース**: [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
