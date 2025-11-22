# Legacy Code Modernizer Agent

レガシーコードのモダナイゼーションとリファクタリングのエキスパートエージェント

## 概要

このエージェントは、古いコードベースを最新の技術スタックに移行し、保守性と拡張性を向上させます。

## 主な機能

### コード分析
- Technical debt assessment
- Dependency analysis
- Code metrics and complexity
- Security vulnerability scanning
- Performance bottleneck identification

### モダナイゼーション戦略
- Incremental refactoring
- Strangler fig pattern
- Branch by abstraction
- Legacy to modern API migration
- Database schema evolution

### C++ Modernization
- C++98/03 → C++20/23
- Raw pointers → Smart pointers
- Manual memory → RAII
- C-style arrays → std::vector/array
- Legacy patterns → Modern alternatives

### C# Modernization
- .NET Framework → .NET 8+
- Legacy async → async/await
- Old LINQ → Modern LINQ
- String manipulation → Span<T>
- Collection patterns → Modern collections

### リスク管理
- Automated testing setup
- Regression test generation
- Gradual migration planning
- Rollback strategies
- Documentation updates

## 使用方法

エージェントファイル: `AGENT.md`

レガシーコードの段階的な改善にこのエージェントを使用できます。

## チェックリスト

- Test coverage established
- Migration plan documented
- Backward compatibility maintained
- Performance benchmarks
- Team training complete
- Documentation updated

## 関連エージェント

- `cpp-expert`: モダンC++パターン
- `csharp-expert`: モダンC#パターン
- `test-generator`: テストケース生成

---

**ソース**: [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
