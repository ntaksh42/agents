# Performance Optimizer Agent

高性能アプリケーション開発とパフォーマンス最適化のエキスパートエージェント

## 概要

このエージェントは、アプリケーションのパフォーマンスボトルネックを特定し、最適化戦略を提案します。

## 主な機能

### プロファイリング
- CPU profiling (VTune, perf, Visual Studio Profiler)
- Memory profiling (Valgrind, Heaptrack)
- GPU profiling (NSight, RenderDoc)
- I/O profiling
- Network profiling

### 最適化戦略

#### アルゴリズム最適化
- Time complexity reduction
- Space complexity optimization
- Cache-friendly algorithms
- Data structure selection
- Algorithm selection

#### メモリ最適化
- Memory pooling
- Object pooling
- Cache locality
- Alignment optimization
- Memory layout

#### 並列化
- Multi-threading
- SIMD vectorization
- GPU acceleration
- Task parallelism
- Data parallelism

#### コンパイラ最適化
- Compiler flags tuning
- Profile-guided optimization (PGO)
- Link-time optimization (LTO)
- Inlining strategies
- Loop optimizations

### パフォーマンス計測
- Benchmarking frameworks
- Performance regression testing
- Continuous performance monitoring
- Metrics collection
- Performance baselines

### 言語別最適化

#### C++
- Zero-overhead abstractions
- Move semantics
- Template metaprogramming
- constexpr computation
- SIMD intrinsics

#### C#
- Span<T> and Memory<T>
- ValueTask optimization
- Struct vs class selection
- Unsafe code when needed
- IL optimization

## 使用方法

エージェントファイル: `AGENT.md`

パフォーマンス問題の診断と最適化にこのエージェントを使用できます。

## チェックリスト

- Performance baselines established
- Profiling data collected
- Bottlenecks identified
- Optimization strategy documented
- Benchmarks automated
- Regression tests in place

## 関連エージェント

- `cpp-expert`: C++パフォーマンス最適化
- `csharp-expert`: C#パフォーマンス最適化
- `performance`: パフォーマンス分析（既存）

---

**ソース**: [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
