# 技術情報管理スキル群 - 設計ドキュメント

**作成日:** 2025-11-22
**ステータス:** 設計完了
**目的:** チーム協業における最新技術の情報収集と共有を支援する4つのスキルの設計

---

## 概要

最新技術の情報収集と共有を効率化するため、以下の4つの新規スキルを開発します：

1. **tech-newsletter-generator** - 技術ニュースレター生成
2. **tech-stack-comparator** - 技術スタック比較分析
3. **tech-learning-path-generator** - 技術学習パス生成
4. **tech-knowledge-curator** - 技術ナレッジキュレーション

これらのスキルは独立して動作しつつ、相互に連携して包括的な技術情報管理エコシステムを構築します。

---

## 背景と課題

### 解決すべき課題
- 公式ドキュメント・リリースノートの更新情報を効率的に追跡したい
- 技術ブログ・記事から有用な情報を収集・共有したい
- 収集した情報をチーム全体で活用できる形で蓄積したい
- 新技術の学習パスを体系的に設計したい
- 技術選定時の比較・評価を効率化したい

### ターゲットユーザー
- 開発チーム（C#/C++中心）
- 技術リード・アーキテクト
- 新メンバーのオンボーディング担当者

---

## スキル詳細設計

### 1. tech-newsletter-generator（技術ニュースレター生成）

#### 目的
週次/月次で技術アップデート情報を自動収集・要約し、チームに共有しやすい形で提供する。

#### 主要機能

**1.1 情報源の自動収集**
- 指定した技術スタック（C#, .NET, C++, TypeScript など）のリリースノートを監視
- 技術ブログ（Qiita, Zenn, Medium, dev.to など）から関連記事を収集
- GitHub Releasesページからバージョンアップ情報を取得

**1.2 コンテンツの要約と分類**
- 各情報を自動要約（3-5行のサマリー）
- カテゴリ分類（新機能、破壊的変更、バグ修正、パフォーマンス改善など）
- 重要度スコアリング（プロジェクトへの影響度を自動判定）

**1.3 レポート生成**
- Markdown形式で読みやすいニュースレター作成
- セクション構成: ハイライト → 詳細 → 参考リンク
- HTML形式でのメール送信用フォーマットも対応

**1.4 カスタマイズ機能**
- 監視対象の技術スタックを設定可能
- 配信頻度（日次/週次/月次）を選択
- フィルタリング条件（言語、最小スター数、特定キーワード除外など）

#### 入力パラメータ例
```yaml
tech_stack: [".NET", "C++20", "TypeScript", "React"]
period: "weekly"
sources: ["official_docs", "qiita", "github_releases"]
min_importance: "medium"
```

#### 出力形式
```markdown
# 技術週報 (2025-11-15 ~ 2025-11-22)

## ハイライト
- .NET 9がリリース - パフォーマンス30%向上
- C++26の新機能提案が承認

## 詳細情報
### .NET
- [重要] .NET 9.0.0リリース...

### C++
- [情報] C++26 Reflection提案が承認...

## 参考リンク
- [.NET 9 Release Notes](...)
```

#### 技術実装ノート
- WebFetch/WebSearchツールで情報収集
- Context7 MCPサーバーで公式ドキュメント参照
- 重要度判定にはキーワードマッチング + AI分析

---

### 2. tech-stack-comparator（技術スタック比較分析）

#### 目的
ライブラリ/フレームワーク/ツールの多角的な比較評価を行い、技術選定の意思決定を支援する。

#### 主要機能

**2.1 多角的な比較分析**
- **パフォーマンス**: ベンチマーク結果、メモリ使用量、起動速度
- **開発者体験**: 学習曲線、ドキュメント品質、IDE サポート
- **エコシステム**: ライブラリ数、コミュニティサイズ、Stack Overflow投稿数
- **保守性**: 更新頻度、セキュリティ対応、バックワード互換性
- **ライセンスとコスト**: 商用利用の可否、サポートコスト
- **採用トレンド**: GitHub Stars、求人数、企業採用事例

**2.2 プロジェクト要件とのマッチング**
- プロジェクトの制約条件を考慮（パフォーマンス要件、チームスキル、予算）
- リスク評価（技術的負債、ロックイン、移行コスト）
- 将来性スコア（コミュニティの成長率、ロードマップ）
- 推奨度ランキング

**2.3 データソースの統合**
- GitHub APIで統計情報取得（Stars, Forks, Issues, Contributors）
- npm/NuGet/PyPIなどのダウンロード数
- Stack Overflow Trendsデータ
- ベンチマークサイト（TechEmpower, benchmarksgame）
- tech-knowledge-curatorから過去の評価記事参照

**2.4 レポート生成**
- 比較表（マトリクス形式）
- レーダーチャート（視覚的比較）
- 意思決定サポートサマリー（推奨理由、注意点）
- 移行パス（現在の技術からの移行手順）

#### 入力パラメータ例
```yaml
compare:
  - "Entity Framework Core"
  - "Dapper"
  - "NHibernate"
context:
  project_type: "エンタープライズWebアプリ"
  team_size: 5
  performance_priority: "高"
  learning_curve_tolerance: "中"
criteria_weights:
  performance: 0.4
  developer_experience: 0.3
  ecosystem: 0.2
  maintenance: 0.1
```

#### 出力形式
```markdown
# ORM比較分析レポート

## 総合評価
**推奨: Dapper** （スコア: 8.2/10）

プロジェクトのパフォーマンス重視の要件に最も適合。
チームの学習コストも許容範囲内。

## 詳細比較

| 項目 | EF Core | Dapper | NHibernate |
|------|---------|--------|------------|
| パフォーマンス | ★★★☆☆ | ★★★★★ | ★★★☆☆ |
| 開発者体験 | ★★★★★ | ★★★☆☆ | ★★☆☆☆ |
| エコシステム | ★★★★★ | ★★★★☆ | ★★★☆☆ |
| 保守性 | ★★★★★ | ★★★★☆ | ★★★☆☆ |

## 各技術の詳細

### Dapper (推奨)
**長所:**
- 極めて高いパフォーマンス（EF Coreの3-5倍高速）
- シンプルで学習しやすい
- Stack Overflowで実績あり

**短所:**
- 生SQLを書く必要がある
- マイグレーション機能なし（別ツール必要）

**移行パス:**
1. 既存のEF Coreモデルを参考にDapperクラス作成
2. リポジトリパターンで段階移行
3. パフォーマンステスト実施

## 意思決定サマリー

**推奨理由:**
1. パフォーマンス要件（重み40%）でDapperが圧倒的
2. チームサイズ5名なら学習コスト許容可能
3. 既存の.NETエコシステムと相性良好

**注意点:**
- マイグレーションツール（FluentMigrator等）の併用推奨
- 複雑なクエリはストアドプロシージャ検討
```

#### インタラクティブ機能
- 重み付け調整で再計算
- 新しい候補技術の追加比較
- 過去の比較レポート参照

#### 技術実装ノート
- WebSearch/WebFetchで公開データ収集
- mermaid-diagramスキル活用でレーダーチャート生成
- data-converterスキルで各種データ形式を統合

---

### 3. tech-learning-path-generator（技術学習パス生成）

#### 目的
新技術の段階的学習プランを自動生成し、チームメンバーの効率的なスキルアップを支援する。

#### 主要機能

**3.1 学習パスの自動設計**
- 技術トピック（例: "C# LINQ", "React Hooks", "C++20コルーチン"）を指定すると段階的学習プランを生成
- 前提知識の自動検出（「この技術を学ぶには○○の知識が必要」）
- 難易度別のステップ分割（初級→中級→上級→実践）
- 推定学習時間の算出

**3.2 リソースのキュレーション**
- 公式ドキュメント、チュートリアル、動画、書籍を自動収集
- tech-knowledge-curatorから関連記事を参照
- 日本語/英語リソースの両方に対応
- コミュニティ評価の高いリソースを優先

**3.3 ハンズオン資料の生成**
- 各ステップごとの実践課題を自動生成
- サンプルコード、演習問題を含む
- 解答例と解説付き
- プロジェクトベース学習用のミニプロジェクト提案

**3.4 カスタマイズ機能**
- 学習者のスキルレベルに応じた調整（初心者/経験者向け）
- 目標設定（「3週間で基礎を習得」「1ヶ月で実務投入可能に」）
- 学習スタイル（理論重視/実践重視）の選択
- チーム向け学習プラン（複数人で進捗共有）

#### 入力パラメータ例
```yaml
topic: "C++20 Ranges"
learner_level: "intermediate"  # C++の基礎はある
goal: "実務で使えるレベル"
timeframe: "2週間"
style: "実践重視"
language: "日本語"
```

#### 出力形式
```markdown
# C++20 Ranges 学習パス

## 学習目標
2週間でC++20 Rangesを実務で使えるレベルに到達する

## 前提知識
- C++11/14の基礎（ラムダ式、auto、範囲for）
- STLアルゴリズムの基本的な使い方

## 学習ステップ

### Week 1: 基礎編
#### Day 1-2: Rangesの基本概念
- [ ] 公式ドキュメント読解 (2h)
  - [C++20 Ranges overview](...)
- [ ] 基本的なRangeアダプタを試す (3h)
  - views::filter, views::transform
  - ハンズオン: 配列操作をRangesで書き直す

#### Day 3-4: パイプライン操作
- [ ] チュートリアル (2h)
- [ ] 演習問題: データ変換パイプライン作成 (4h)

### Week 2: 実践編
#### Day 5-7: カスタムRangeアダプタ
...

## リソース
### 必須
- [cppreference - Ranges](...)
- [C++20の新機能解説](...)

### 推奨
- [Rangesを使った実践例](...)

## 実践課題
1. ログファイル解析ツールをRangesで実装
2. 既存コードをRangesでリファクタリング

## 評価基準
- [ ] 基本的なRangeアダプタを使いこなせる
- [ ] パイプライン操作で複雑な変換を記述できる
- [ ] カスタムRangeアダプタを作成できる
```

#### 進捗トラッキング
- チェックリスト形式で進捗管理
- Azure DevOps Boardsと連携可能
- 完了時にバッジ/証明書生成オプション

#### 技術実装ノート
- Context7 MCPサーバーで最新ドキュメント参照
- WebSearchで評価の高い学習リソース検索
- markdown-table-generatorスキルで体系的な学習計画表生成

---

### 4. tech-knowledge-curator（技術ナレッジキュレーション）

#### 目的
技術情報を収集・整理・分類し、検索可能な形でチームのナレッジベースを構築する。

#### 主要機能

**4.1 情報の収集と取り込み**
- 技術記事URL、ドキュメントページを指定して取り込み
- tech-newsletter-generatorからの自動連携（重要な記事を自動保存）
- ローカルMarkdownファイル、PDF、コードスニペットの取り込み

**4.2 メタデータの自動付与**
- タグ自動生成（技術スタック、カテゴリ、難易度）
- キーワード抽出
- 関連度スコアリング（既存ナレッジとの関連性）
- 作成日、最終更新日、情報鮮度の追跡

**4.3 整理と分類**
- フォルダ/カテゴリ階層の自動提案
- 重複検出と統合
- 古くなった情報の検出とアラート
- トピッククラスタリング（類似記事のグルーピング）

**4.4 出力と統合**
- Azure DevOps Wiki形式
- Confluence形式
- ローカルMarkdown（Obsidian/Logseq互換）
- 全文検索インデックス生成

#### 入力パラメータ例
```yaml
sources:
  - url: "https://example.com/article"
  - file: "docs/tech-notes.md"
auto_tag: true
output_format: "azure_wiki"
knowledge_base_path: "docs/knowledge-base/"
```

#### ナレッジエントリ形式
```markdown
---
title: ".NET 9の新機能解説"
tags: [".NET", "C#", "パフォーマンス"]
category: "フレームワーク/ランタイム"
difficulty: "中級"
created: 2025-11-20
source: "https://example.com/..."
freshness: "最新"
related: ["dotnet8-migration", "performance-tips"]
---

## 概要
.NET 9の主要な新機能について...

## キーポイント
- パフォーマンス30%向上
- 新しいAOTコンパイル機能

## 関連リソース
- [公式ドキュメント](...)

## 実践例
```csharp
// コードサンプル
```

## 参考記事
- 関連記事1
- 関連記事2
```

#### 検索機能
- フルテキスト検索
- タグフィルタリング
- 日付範囲指定
- 関連記事の推奨

#### 技術実装ノート
- document-summarizerスキルで記事要約
- WebFetchツールでURL取り込み
- Grepツールで全文検索インデックス

---

## スキル間連携設計

### データ共有の仕組み

**共通データフォーマット**
```yaml
# .tech-intelligence/metadata.json
{
  "version": "1.0",
  "items": [
    {
      "id": "tech-2025-11-22-001",
      "type": "article|release|comparison|learning_path",
      "title": ".NET 9リリース",
      "source_skill": "tech-newsletter-generator",
      "created_at": "2025-11-22T10:00:00Z",
      "tags": [".NET", "パフォーマンス"],
      "importance": "high",
      "content_path": "docs/tech-intelligence/articles/dotnet9.md",
      "metadata": {
        // スキル固有のメタデータ
      }
    }
  ]
}
```

### 連携パターン

**パターンA: パイプライン連携**
```
newsletter-generator → knowledge-curator → learning-path-generator
```
例: 週報で見つけた重要記事を自動的にナレッジベースに保存し、新技術の学習パスを生成

**パターンB: 参照連携**
```
stack-comparator ← knowledge-curator（過去の評価記事参照）
learning-path-generator ← knowledge-curator（関連リソース参照）
```

**パターンC: トリガー連携**
```
newsletter-generator [重要度: 高] → 自動的にlearning-path生成を提案
stack-comparator [新技術検出] → newsletter-generatorの監視対象に追加
```

### 具体的な連携シナリオ

**シナリオ1: 新技術の発見から習得まで**
1. `tech-newsletter-generator`が.NET 9リリースを検出
2. 重要度が高いため`tech-knowledge-curator`に自動保存
3. ユーザーが「学びたい」を選択
4. `tech-learning-path-generator`が学習パス自動生成
5. ナレッジベースから関連記事を参照して充実化

**シナリオ2: 技術選定プロセス**
1. `tech-stack-comparator`でORM比較を実施
2. 選定結果を`tech-knowledge-curator`に意思決定記録として保存
3. 選定技術の`tech-newsletter-generator`監視リストに追加
4. 採用技術の`tech-learning-path-generator`で学習プラン作成

**シナリオ3: 継続的な知識アップデート**
1. `tech-newsletter-generator`が毎週情報収集
2. 重要記事を`tech-knowledge-curator`に自動蓄積
3. 月次で`tech-learning-path-generator`が新しいトピック提案
4. 四半期で`tech-stack-comparator`が技術スタック見直し提案

### 設定ファイルでの連携管理

```yaml
# .tech-intelligence/config.yml
integrations:
  auto_save_to_knowledge_base:
    enabled: true
    min_importance: "medium"

  auto_suggest_learning_path:
    enabled: true
    trigger_on: ["new_major_release", "high_importance_article"]

  auto_add_to_monitoring:
    enabled: true
    trigger_on: ["technology_selected_in_comparison"]

shared_storage:
  path: "docs/tech-intelligence/"
  format: "markdown"
```

---

## 実装計画

### 実装順序: トップダウン型

**優先度1: tech-newsletter-generator**
- 理由: 即座に価値提供、単独で完結
- 期待される効果: チームが最新情報をキャッチアップできる
- 実装規模: 中

**優先度2: tech-stack-comparator**
- 理由: 意思決定支援で高い価値
- 期待される効果: 技術選定の質と速度が向上
- 実装規模: 大

**優先度3: tech-learning-path-generator**
- 理由: チーム育成で頻繁に使用
- 期待される効果: オンボーディングとスキルアップの効率化
- 実装規模: 大

**優先度4: tech-knowledge-curator**
- 理由: 他スキルと連携して価値最大化
- 期待される効果: 長期的なナレッジ蓄積
- 実装規模: 中

### マイルストーン

**Phase 1: 基本スキル実装（1-3ヶ月）**
- tech-newsletter-generator実装
- tech-stack-comparator実装
- 各スキル単独での動作確認

**Phase 2: 高度機能とスキル追加（3-5ヶ月）**
- tech-learning-path-generator実装
- tech-knowledge-curator実装
- 基本的な連携機能実装

**Phase 3: 統合と最適化（5-6ヶ月）**
- スキル間の高度な連携実装
- パフォーマンス最適化
- ユーザーフィードバック反映

---

## 技術スタック

### 使用するツール・スキル

**Claude Code標準ツール:**
- WebFetch: Web情報収集
- WebSearch: 検索エンジン活用
- Read/Write/Edit: ファイル操作
- Bash: 自動化スクリプト

**既存スキル活用:**
- `document-summarizer`: 記事要約
- `mermaid-diagram`: チャート生成
- `markdown-table-generator`: 表形式データ
- `data-converter`: データ形式変換

**外部API/サービス:**
- GitHub API: リポジトリ統計
- Stack Overflow API: トレンドデータ
- NuGet/npm API: パッケージ情報

**MCPサーバー:**
- Context7: 公式ドキュメント参照

---

## 成功指標

### 定量的指標
- 週報生成時間: 手動30分 → 自動5分（83%削減）
- 技術比較レポート作成: 手動3時間 → 自動30分（83%削減）
- 学習パス設計: 手動5時間 → 自動1時間（80%削減）
- ナレッジ検索時間: 手動10分 → 自動1分（90%削減）

### 定性的指標
- チームの技術情報キャッチアップ率向上
- 技術選定の意思決定品質向上
- 新メンバーのオンボーディング期間短縮
- チーム全体の技術知識の可視化

---

## リスクと対策

### リスク1: 情報の正確性
- **リスク**: 自動収集した情報に誤りがある
- **対策**:
  - 信頼できる情報源に限定
  - 重要な情報は人間による確認推奨
  - 情報源の明示

### リスク2: 情報過多
- **リスク**: 大量の情報でユーザーが overwhelm される
- **対策**:
  - 重要度フィルタリング機能
  - サマリー機能の充実
  - カスタマイズ可能な設定

### リスク3: メンテナンスコスト
- **リスク**: 外部API変更でスキルが動作しなくなる
- **対策**:
  - 複数の情報源に対応
  - フォールバック機能実装
  - 定期的な動作確認

### リスク4: スキル間連携の複雑化
- **リスク**: 連携が複雑になりすぎてメンテナンス困難
- **対策**:
  - シンプルな連携インターフェース設計
  - 各スキルの独立性維持
  - 段階的な連携機能追加

---

## 次のステップ

1. **tech-newsletter-generator**の詳細実装仕様策定
2. プロトタイプ実装
3. チームフィードバック収集
4. 本実装開始

---

## 参考資料

- 既存スキル: `.claude/skills/` 配下の各スキル定義
- プロジェクト構造: `docs/agent-development-guide.md`
- コミュニティリサーチ: `docs/research-findings.md`

---

## 変更履歴

| 日付 | 変更内容 | 担当者 |
|------|---------|--------|
| 2025-11-22 | 初版作成 | brainstorming session |
