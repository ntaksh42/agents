# 既存エージェント強化計画

**作成日**: 2025-11-22
**目的**: 発見したリソース（obra/superpowers、VoltAgent、wshobson/agents）を活用して既存の6つのエージェントを強化する

---

## 📊 現状分析

### 既存エージェント一覧
1. **memory-safety** (agents/memory-safety/) - 開発予定
2. **interop-expert** (agents/interop-expert/) - 開発予定
3. **build-helper** (agents/build-helper/) - 開発予定
4. **windows-desktop** (agents/windows-desktop/) - 開発予定
5. **performance** (agents/performance/) - 開発予定
6. **test-generator** (agents/test-generator/) - 開発予定

### 新規追加エージェント
1. **cpp-expert** - VoltAgentから追加
2. **csharp-expert** - VoltAgentから追加
3. **build-engineer** - VoltAgentから追加
4. **legacy-modernizer** - VoltAgentから追加
5. **performance-optimizer** - VoltAgentから追加

### 新規追加スキル（obra/superpowers）
1. systematic-debugging
2. test-driven-development
3. verification-before-completion
4. subagent-driven-development
5. brainstorming
6. writing-plans
7. executing-plans
8. using-git-worktrees
9. requesting-code-review
10. receiving-code-review

---

## 🎯 エージェント別強化計画

### 1. memory-safety エージェント強化

**現状**: 開発予定（README.mdのみ）

**強化リソース**:
- **VoltAgent**: cpp-expertのメモリ管理セクション
- **superpowers**: systematic-debugging, verification-before-completion

**強化内容**:

#### フェーズ1: コア機能実装
```markdown
prompts/
├── analyze-memory-leaks.md       # メモリリーク検出
├── detect-dangling-pointers.md   # ダングリングポインタ検出
├── buffer-overflow-check.md      # バッファオーバーフロー防止
├── suggest-smart-pointers.md     # スマートポインタ推奨
└── apply-raii-pattern.md         # RAIIパターン適用
```

#### フェーズ2: ツール統合
- Valgrind統合
- AddressSanitizer統合
- clang-tidy メモリチェック
- cppcheck統合

#### フェーズ3: ベストプラクティス
- C++ Core Guidelinesメモリセクション
- スマートポインタ選択ガイド
- カスタムアロケータ設計
- メモリプールパターン

**参考リソース**:
- `/tmp/awesome-claude-code-subagents/categories/02-language-specialists/cpp-pro.md` (Memory management excellence セクション)
- `.claude/skills/systematic-debugging/SKILL.md` (Phase 1: Root Cause Investigation)

---

### 2. build-helper エージェント強化

**現状**: 開発予定（README.mdのみ）

**強化リソース**:
- **VoltAgent**: build-engineer
- **wshobson/agents**: Kubernetes, CI/CDスキル

**強化内容**:

#### フェーズ1: Modern CMake サポート
```markdown
prompts/
├── generate-cmake-modern.md      # Modern CMake 3.20+ 生成
├── optimize-build-time.md        # ビルド時間最適化
├── configure-vcpkg.md            # vcpkg統合
├── setup-conan.md                # Conan統合
└── troubleshoot-linker.md        # リンカー問題解決
```

#### フェーズ2: MSBuild / Visual Studio
```markdown
prompts/
├── generate-vcxproj.md           # Visual Studioプロジェクト生成
├── configure-msbuild.md          # MSBuild設定
├── optimize-incremental-build.md # インクリメンタルビルド最適化
└── manage-nuget-packages.md      # NuGetパッケージ管理
```

#### フェーズ3: クロスプラットフォーム
```markdown
prompts/
├── cross-compile-setup.md        # クロスコンパイル設定
├── target-multiple-arch.md       # マルチアーキテクチャ対応
├── ci-cd-integration.md          # CI/CD統合
└── docker-build.md               # Dockerビルド
```

**新規統合エージェント**:
- build-engineerエージェントと連携
- 役割分担: build-helper（基本）、build-engineer（高度な最適化）

---

### 3. interop-expert エージェント強化

**現状**: 開発予定

**強化リソース**:
- **VoltAgent**: cpp-expert, csharp-expert
- **wshobson/agents**: Python非同期パターン（参考）

**強化内容**:

#### フェーズ1: P/Invoke マスタリー
```markdown
prompts/
├── generate-pinvoke.md           # P/Invokeコード生成
├── optimize-marshalling.md       # マーシャリング最適化
├── handle-callbacks.md           # コールバック処理
├── manage-memory-ownership.md    # メモリ所有権管理
└── error-handling-interop.md     # エラーハンドリング
```

#### フェーズ2: C++/CLI 統合
```markdown
prompts/
├── create-cpp-cli-wrapper.md     # C++/CLIラッパー作成
├── managed-unmanaged-bridge.md   # マネージド・アンマネージドブリッジ
├── exception-translation.md      # 例外変換
└── type-conversion.md            # 型変換
```

#### フェーズ3: パフォーマンス最適化
```markdown
prompts/
├── minimize-marshalling.md       # マーシャリング最小化
├── use-blittable-types.md        # Blittable型活用
├── batch-interop-calls.md        # Interop呼び出しバッチ化
└── profile-interop-overhead.md   # Interopオーバーヘッド計測
```

**ベストプラクティス**:
- P/Invoke vs C++/CLI 選択ガイド
- パフォーマンスベンチマーク
- セキュリティ考慮事項

---

### 4. test-generator エージェント強化

**現状**: 開発予定

**強化リソース**:
- **superpowers**: test-driven-development, verification-before-completion
- **VoltAgent**: cpp-expert, csharp-expert

**強化内容**:

#### フェーズ1: C++ テストフレームワーク
```markdown
prompts/
├── generate-google-test.md       # Google Test生成
├── generate-catch2-test.md       # Catch2テスト生成
├── create-google-mock.md         # Google Mockオブジェクト作成
├── setup-test-fixtures.md        # テストフィクスチャ設定
└── parametrized-tests.md         # パラメータ化テスト
```

#### フェーズ2: C# テストフレームワーク
```markdown
prompts/
├── generate-xunit-test.md        # xUnitテスト生成
├── generate-nunit-test.md        # NUnitテスト生成
├── generate-mstest.md            # MSTestテスト生成
├── create-nsubstitute-mock.md    # NSubstituteモック作成
└── create-moq-mock.md            # Moqモック作成
```

#### フェーズ3: TDD ワークフロー統合
```markdown
prompts/
├── red-green-refactor.md         # RED-GREEN-REFACTORサイクル
├── test-coverage-analysis.md     # カバレッジ分析
├── mutation-testing.md           # ミューテーションテスト
└── integration-testing.md        # 統合テスト
```

**superpowers統合**:
- test-driven-developmentスキルを参照
- RED-GREEN-REFACTORサイクルの徹底
- 失敗するテストを最初に書く原則

---

### 5. performance エージェント強化

**現状**: 開発予定

**強化リソース**:
- **VoltAgent**: performance-optimizer
- **VoltAgent**: cpp-expert (Performance optimization セクション)
- **VoltAgent**: csharp-expert (Performance セクション)

**強化内容**:

#### フェーズ1: プロファイリングツール統合
```markdown
prompts/
├── setup-vtune.md                # Intel VTuneセットアップ
├── setup-visual-studio-profiler.md # Visual Studioプロファイラー
├── use-valgrind.md               # Valgrindメモリプロファイリング
├── use-perf.md                   # Linux perfツール
└── gpu-profiling.md              # GPUプロファイリング
```

#### フェーズ2: C++ 最適化
```markdown
prompts/
├── simd-optimization.md          # SIMD最適化
├── cache-optimization.md         # キャッシュ最適化
├── loop-optimization.md          # ループ最適化
├── move-semantics.md             # ムーブセマンティクス
└── compile-time-optimization.md  # コンパイル時最適化
```

#### フェーズ3: C# 最適化
```markdown
prompts/
├── span-memory-optimization.md   # Span<T>/Memory<T>最適化
├── valuetask-optimization.md     # ValueTask最適化
├── struct-vs-class.md            # struct vs class選択
├── stackalloc-usage.md           # stackalloc活用
└── zero-allocation.md            # ゼロアロケーション技術
```

#### フェーズ4: ベンチマーキング
```markdown
prompts/
├── setup-benchmark-dotnet.md     # BenchmarkDotNet セットアップ
├── setup-google-benchmark.md     # Google Benchmarkセットアップ
├── performance-regression-test.md # パフォーマンス回帰テスト
└── continuous-benchmarking.md    # 継続的ベンチマーキング
```

**新規統合エージェント**:
- performance-optimizerエージェントと連携
- 役割分担: performance（分析）、performance-optimizer（最適化実装）

---

### 6. windows-desktop エージェント強化

**現状**: 開発予定

**強化リソース**:
- **VoltAgent**: csharp-expert (WPF/WinForms セクション)
- **MCP**: Playwright MCP (UI自動化テスト)

**強化内容**:

#### フェーズ1: WPF マスタリー
```markdown
prompts/
├── generate-wpf-xaml.md          # WPF XAML生成
├── implement-mvvm-pattern.md     # MVVMパターン実装
├── create-custom-controls.md     # カスタムコントロール作成
├── data-binding-optimization.md  # データバインディング最適化
└── wpf-animations.md             # アニメーション実装
```

#### フェーズ2: WinForms サポート
```markdown
prompts/
├── generate-winforms-designer.md # WinFormsデザイナーコード生成
├── modernize-winforms.md         # WinFormsモダナイゼーション
├── custom-drawing.md             # カスタム描画
└── winforms-to-wpf-migration.md  # WinForms→WPF移行
```

#### フェーズ3: Win32 API 統合
```markdown
prompts/
├── pinvoke-win32-api.md          # Win32 API P/Invoke
├── window-message-handling.md    # ウィンドウメッセージ処理
├── com-interop.md                # COM相互運用
└── native-controls-integration.md # ネイティブコントロール統合
```

#### フェーズ4: UI自動化テスト
```markdown
prompts/
├── ui-automation-framework.md    # UI Automationフレームワーク
├── appium-windows-testing.md     # Appium Windowsテスト
├── white-framework-testing.md    # Whiteフレームワーク
└── playwright-webview-testing.md # PlaywrightによるWebViewテスト
```

**MCP統合**:
- Playwright MCPでWebView2コンポーネントテスト
- UI Automation MCPの開発検討

---

## 📅 実装スケジュール

### Q4 2025 (11月-12月)
- [x] 調査完了
- [x] 新規スキル追加（obra/superpowers: 10スキル）
- [x] 新規エージェント追加（VoltAgent: 5エージェント）
- [ ] memory-safety エージェント実装（フェーズ1-2）
- [ ] test-generator エージェント実装（フェーズ1-2）

### Q1 2026 (1月-3月)
- [ ] build-helper エージェント実装（フェーズ1-2）
- [ ] performance エージェント実装（フェーズ1-2）
- [ ] interop-expert エージェント実装（フェーズ1）
- [ ] windows-desktop エージェント実装（フェーズ1）

### Q2 2026 (4月-6月)
- [ ] 全エージェントフェーズ3実装
- [ ] MCP統合完了
- [ ] ドキュメント整備
- [ ] ベータテスト

### Q3 2026 (7月-9月)
- [ ] フィードバック反映
- [ ] パフォーマンスチューニング
- [ ] 本番環境展開
- [ ] コミュニティ公開

---

## 🎯 成功指標

### 定量的指標
- **エージェント実装率**: 6/6エージェント実装完了
- **プロンプト数**: 各エージェント10+プロンプト
- **テストカバレッジ**: 各エージェント80%以上
- **ドキュメント完成度**: 全エージェントREADME + ガイド完備

### 定性的指標
- **開発者体験**: スムーズなワークフロー
- **コード品質**: 自動チェック・提案の精度
- **学習曲線**: 新規開発者のオンボーディング時間短縮

---

## 🔗 参考リソース

### エージェント設計
- [agent-development-guide.md](./agent-development-guide.md)
- [VoltAgent cpp-expert](https://github.com/VoltAgent/awesome-claude-code-subagents/blob/main/categories/02-language-specialists/cpp-pro.md)
- [VoltAgent build-engineer](https://github.com/VoltAgent/awesome-claude-code-subagents/blob/main/categories/06-developer-experience/build-engineer.md)

### スキル統合
- [obra/superpowers](https://github.com/obra/superpowers)
- [systematic-debugging](../.claude/skills/systematic-debugging/SKILL.md)
- [test-driven-development](../.claude/skills/test-driven-development/SKILL.md)

### ベストプラクティス
- [research-findings.md](./research-findings.md)
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
- [.NET Design Guidelines](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/)

---

## 📝 次のステップ

### 即座に開始
1. **memory-safety エージェント実装開始**
   - prompts/ ディレクトリ作成
   - analyze-memory-leaks.md プロンプト作成
   - Valgrind統合ガイド作成

2. **test-generator エージェント実装開始**
   - Google Test生成プロンプト作成
   - TDDワークフローガイド作成
   - superpowersスキル統合

### 1週間以内
3. **build-helper エージェント実装**
   - Modern CMake生成プロンプト
   - build-engineerとの役割分担明確化

4. **ドキュメント整備**
   - 各エージェントの詳細ガイド作成
   - サンプルプロジェクト作成

### 1ヶ月以内
5. **残りエージェント実装**
   - interop-expert, performance, windows-desktop
   - MCP統合テスト
   - ベータテスト開始

---

**更新日**: 2025-11-22
**ステータス**: 計画完了 - 実装準備中
