# SVG図示パターン集

Marp資料で使用するSVG図のパターンとテンプレート。

## 目次

1. [パターン選択ガイド](#パターン選択ガイド)
2. [基本ルール](#基本ルール)
3. [アクセシビリティガイドライン](#アクセシビリティガイドライン)
4. [共通SVG定義](#共通svg定義)
5. [フロー図](#フロー図)
6. [比較図](#比較図)
7. [アーキテクチャ図](#アーキテクチャ図)
8. [マトリクス図](#マトリクス図)
9. [タイムライン図](#タイムライン図)

---

## パターン選択ガイド

| ユースケース | 推奨パターン | 理由 |
|------------|------------|------|
| 技術選定プロセス | フロー図（分岐） | 意思決定の流れを明示 |
| 2-3案の比較 | 比較図 | 視覚的な対比 |
| システム構成説明 | アーキテクチャ図（レイヤー/コンポーネント） | 構造の階層化 |
| コストvs効果分析 | マトリクス図 | 2軸での定量評価 |
| 導入ロードマップ | タイムライン図 | 時系列の明確化 |
| 複雑な依存関係 | コンポーネント図 | 関係性の可視化 |

---

## 基本ルール

### ファイル配置

- スライドと同じディレクトリに配置
- Markdownから相対パスで参照: `![説明](./diagram.svg)`

### 命名規則

```
[内容]-[種類].svg
例: architecture-overview.svg, comparison-cost.svg, flow-process.svg
```

### カラーパレット

```
プライマリ: #3498db (青)
セカンダリ: #2ecc71 (緑)
警告:       #e74c3c (赤)
中立:       #95a5a6 (グレー)
背景:       #ecf0f1 (薄いグレー)
テキスト:   #2c3e50 (濃紺)
```

### サイズガイドライン

- 推奨サイズ: 幅800px、高さ400-600px
- フォントサイズ: 最小14px
- 線の太さ: 2px以上

---

## アクセシビリティガイドライン

### 代替テキストの追加

スクリーンリーダー対応のため、title/desc要素を追加する：

```svg
<svg role="img" aria-labelledby="title desc" viewBox="0 0 800 200" xmlns="http://www.w3.org/2000/svg">
  <title id="title">プロセスフロー図</title>
  <desc id="desc">ステップ1からステップ2、最後に完了に至る3段階のプロセス</desc>
  <!-- SVG内容 -->
</svg>
```

### 色盲対応

- **色だけで情報を伝えない**: 形状・パターン・テキストラベルを併用
- **コントラスト比**: テキストと背景は4.5:1以上を確保
- **検証ツール**: [Color Oracle](https://colororacle.org/)で確認

### 推奨パターン

| 状態 | 色 | 形状 | ラベル |
|------|-----|------|--------|
| 成功/メリット | 緑 #2ecc71 | ○ 丸 | ○ または ✅ |
| 警告/デメリット | 赤 #e74c3c | × バツ | × または ❌ |
| 中立/普通 | グレー #95a5a6 | △ 三角 | △ |

---

## 共通SVG定義

すべてのSVGで使用する共通定義（コピーして使用）：

```svg
<defs>
  <!-- 矢印マーカー（青） -->
  <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
    <path d="M0,0 L0,6 L9,3 z" fill="#3498db"/>
  </marker>

  <!-- 矢印マーカー（グレー） -->
  <marker id="arrow-gray" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
    <path d="M0,0 L0,6 L9,3 z" fill="#2c3e50"/>
  </marker>
</defs>
```

---

## フロー図

プロセスや手順を可視化する。

### 基本フロー（横方向）

```svg
<svg viewBox="0 0 800 200" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#3498db"/>
    </marker>
  </defs>

  <!-- ステップ1 -->
  <rect x="50" y="70" width="120" height="60" rx="8" fill="#3498db"/>
  <text x="110" y="105" text-anchor="middle" fill="white" font-size="14">ステップ1</text>

  <!-- 矢印1 -->
  <line x1="170" y1="100" x2="230" y2="100" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>

  <!-- ステップ2 -->
  <rect x="240" y="70" width="120" height="60" rx="8" fill="#3498db"/>
  <text x="300" y="105" text-anchor="middle" fill="white" font-size="14">ステップ2</text>

  <!-- 矢印2 -->
  <line x1="360" y1="100" x2="420" y2="100" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>

  <!-- ステップ3 -->
  <rect x="430" y="70" width="120" height="60" rx="8" fill="#2ecc71"/>
  <text x="490" y="105" text-anchor="middle" fill="white" font-size="14">完了</text>
</svg>
```

### 分岐フロー

```svg
<svg viewBox="0 0 800 300" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#3498db"/>
    </marker>
  </defs>

  <!-- 開始 -->
  <rect x="300" y="20" width="120" height="50" rx="8" fill="#3498db"/>
  <text x="360" y="50" text-anchor="middle" fill="white" font-size="14">開始</text>

  <!-- 矢印 -->
  <line x1="360" y1="70" x2="360" y2="100" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>

  <!-- 分岐（ひし形） -->
  <polygon points="360,110 420,150 360,190 300,150" fill="#f39c12"/>
  <text x="360" y="155" text-anchor="middle" fill="white" font-size="12">条件?</text>

  <!-- Yes分岐 -->
  <line x1="420" y1="150" x2="500" y2="150" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>
  <text x="460" y="140" text-anchor="middle" fill="#2c3e50" font-size="12">Yes</text>
  <rect x="510" y="125" width="100" height="50" rx="8" fill="#2ecc71"/>
  <text x="560" y="155" text-anchor="middle" fill="white" font-size="14">案A</text>

  <!-- No分岐 -->
  <line x1="300" y1="150" x2="220" y2="150" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>
  <text x="260" y="140" text-anchor="middle" fill="#2c3e50" font-size="12">No</text>
  <rect x="110" y="125" width="100" height="50" rx="8" fill="#e74c3c"/>
  <text x="160" y="155" text-anchor="middle" fill="white" font-size="14">案B</text>
</svg>
```

---

## 比較図

2つ以上の案を並べて比較する。

### 2案比較

```svg
<svg viewBox="0 0 800 400" xmlns="http://www.w3.org/2000/svg">
  <!-- 案A -->
  <rect x="50" y="50" width="300" height="300" rx="10" fill="#ecf0f1" stroke="#3498db" stroke-width="3"/>
  <rect x="50" y="50" width="300" height="50" rx="10" fill="#3498db"/>
  <text x="200" y="82" text-anchor="middle" fill="white" font-size="18" font-weight="bold">案A</text>

  <text x="70" y="130" fill="#2c3e50" font-size="14">メリット:</text>
  <text x="90" y="155" fill="#27ae60" font-size="13">○ メリット1</text>
  <text x="90" y="180" fill="#27ae60" font-size="13">○ メリット2</text>

  <text x="70" y="220" fill="#2c3e50" font-size="14">デメリット:</text>
  <text x="90" y="245" fill="#e74c3c" font-size="13">× デメリット1</text>
  <text x="90" y="270" fill="#e74c3c" font-size="13">× デメリット2</text>

  <!-- VS -->
  <text x="400" y="210" text-anchor="middle" fill="#95a5a6" font-size="24" font-weight="bold">VS</text>

  <!-- 案B -->
  <rect x="450" y="50" width="300" height="300" rx="10" fill="#ecf0f1" stroke="#2ecc71" stroke-width="3"/>
  <rect x="450" y="50" width="300" height="50" rx="10" fill="#2ecc71"/>
  <text x="600" y="82" text-anchor="middle" fill="white" font-size="18" font-weight="bold">案B</text>

  <text x="470" y="130" fill="#2c3e50" font-size="14">メリット:</text>
  <text x="490" y="155" fill="#27ae60" font-size="13">○ メリット1</text>
  <text x="490" y="180" fill="#27ae60" font-size="13">○ メリット2</text>

  <text x="470" y="220" fill="#2c3e50" font-size="14">デメリット:</text>
  <text x="490" y="245" fill="#e74c3c" font-size="13">× デメリット1</text>
  <text x="490" y="270" fill="#e74c3c" font-size="13">× デメリット2</text>
</svg>
```

---

## アーキテクチャ図

システム構成を表現する。

### レイヤー構造

```svg
<svg viewBox="0 0 800 400" xmlns="http://www.w3.org/2000/svg">
  <!-- プレゼンテーション層 -->
  <rect x="100" y="30" width="600" height="70" rx="8" fill="#3498db"/>
  <text x="400" y="72" text-anchor="middle" fill="white" font-size="16">プレゼンテーション層</text>

  <!-- 矢印 -->
  <line x1="400" y1="100" x2="400" y2="120" stroke="#2c3e50" stroke-width="2"/>
  <polygon points="400,130 395,120 405,120" fill="#2c3e50"/>

  <!-- ビジネスロジック層 -->
  <rect x="100" y="140" width="600" height="70" rx="8" fill="#2ecc71"/>
  <text x="400" y="182" text-anchor="middle" fill="white" font-size="16">ビジネスロジック層</text>

  <!-- 矢印 -->
  <line x1="400" y1="210" x2="400" y2="230" stroke="#2c3e50" stroke-width="2"/>
  <polygon points="400,240 395,230 405,230" fill="#2c3e50"/>

  <!-- データアクセス層 -->
  <rect x="100" y="250" width="600" height="70" rx="8" fill="#f39c12"/>
  <text x="400" y="292" text-anchor="middle" fill="white" font-size="16">データアクセス層</text>

  <!-- 矢印 -->
  <line x1="400" y1="320" x2="400" y2="340" stroke="#2c3e50" stroke-width="2"/>
  <polygon points="400,350 395,340 405,340" fill="#2c3e50"/>

  <!-- データベース -->
  <ellipse cx="400" cy="380" rx="80" ry="20" fill="#95a5a6"/>
  <rect x="320" y="360" width="160" height="20" fill="#95a5a6"/>
  <ellipse cx="400" cy="360" rx="80" ry="20" fill="#bdc3c7"/>
  <text x="400" y="375" text-anchor="middle" fill="white" font-size="12">Database</text>
</svg>
```

### コンポーネント図

```svg
<svg viewBox="0 0 800 350" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="10" refX="9" refY="3" orient="auto">
      <path d="M0,0 L0,6 L9,3 z" fill="#3498db"/>
    </marker>
  </defs>

  <!-- クライアント -->
  <rect x="50" y="130" width="120" height="80" rx="8" fill="#3498db"/>
  <text x="110" y="175" text-anchor="middle" fill="white" font-size="14">クライアント</text>

  <!-- 矢印 -->
  <line x1="170" y1="170" x2="230" y2="170" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>

  <!-- APIサーバー -->
  <rect x="240" y="130" width="120" height="80" rx="8" fill="#2ecc71"/>
  <text x="300" y="175" text-anchor="middle" fill="white" font-size="14">APIサーバー</text>

  <!-- 矢印（DB） -->
  <line x1="360" y1="170" x2="420" y2="170" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>

  <!-- データベース -->
  <rect x="430" y="130" width="120" height="80" rx="8" fill="#f39c12"/>
  <text x="490" y="175" text-anchor="middle" fill="white" font-size="14">データベース</text>

  <!-- 外部サービス -->
  <rect x="240" y="30" width="120" height="60" rx="8" fill="#9b59b6"/>
  <text x="300" y="65" text-anchor="middle" fill="white" font-size="14">外部API</text>

  <!-- 矢印（外部） -->
  <line x1="300" y1="130" x2="300" y2="100" stroke="#3498db" stroke-width="2" marker-end="url(#arrow)"/>
</svg>
```

---

## マトリクス図

2軸で分類を表現する。

```svg
<svg viewBox="0 0 800 500" xmlns="http://www.w3.org/2000/svg">
  <!-- 軸 -->
  <line x1="100" y1="400" x2="700" y2="400" stroke="#2c3e50" stroke-width="2"/>
  <line x1="100" y1="400" x2="100" y2="50" stroke="#2c3e50" stroke-width="2"/>

  <!-- 軸ラベル -->
  <text x="400" y="450" text-anchor="middle" fill="#2c3e50" font-size="16">コスト →</text>
  <text x="40" y="225" text-anchor="middle" fill="#2c3e50" font-size="16" transform="rotate(-90, 40, 225)">効果 →</text>

  <!-- グリッド線 -->
  <line x1="400" y1="400" x2="400" y2="50" stroke="#ecf0f1" stroke-width="1" stroke-dasharray="5,5"/>
  <line x1="100" y1="225" x2="700" y2="225" stroke="#ecf0f1" stroke-width="1" stroke-dasharray="5,5"/>

  <!-- 象限ラベル -->
  <text x="250" y="130" text-anchor="middle" fill="#27ae60" font-size="14" font-weight="bold">高効果・低コスト</text>
  <text x="550" y="130" text-anchor="middle" fill="#f39c12" font-size="14" font-weight="bold">高効果・高コスト</text>
  <text x="250" y="320" text-anchor="middle" fill="#95a5a6" font-size="14" font-weight="bold">低効果・低コスト</text>
  <text x="550" y="320" text-anchor="middle" fill="#e74c3c" font-size="14" font-weight="bold">低効果・高コスト</text>

  <!-- プロット例 -->
  <circle cx="220" cy="150" r="30" fill="#27ae60" opacity="0.8"/>
  <text x="220" y="155" text-anchor="middle" fill="white" font-size="12">案A</text>

  <circle cx="500" cy="180" r="30" fill="#3498db" opacity="0.8"/>
  <text x="500" y="185" text-anchor="middle" fill="white" font-size="12">案B</text>

  <circle cx="350" cy="300" r="30" fill="#95a5a6" opacity="0.8"/>
  <text x="350" y="305" text-anchor="middle" fill="white" font-size="12">案C</text>
</svg>
```

---

## タイムライン図

スケジュールや時系列を表現する。

```svg
<svg viewBox="0 0 800 200" xmlns="http://www.w3.org/2000/svg">
  <!-- タイムライン軸 -->
  <line x1="50" y1="100" x2="750" y2="100" stroke="#2c3e50" stroke-width="3"/>

  <!-- マイルストーン1 -->
  <circle cx="150" cy="100" r="10" fill="#3498db"/>
  <text x="150" y="70" text-anchor="middle" fill="#2c3e50" font-size="12">Phase 1</text>
  <text x="150" y="130" text-anchor="middle" fill="#95a5a6" font-size="11">1月</text>

  <!-- マイルストーン2 -->
  <circle cx="350" cy="100" r="10" fill="#3498db"/>
  <text x="350" y="70" text-anchor="middle" fill="#2c3e50" font-size="12">Phase 2</text>
  <text x="350" y="130" text-anchor="middle" fill="#95a5a6" font-size="11">3月</text>

  <!-- マイルストーン3 -->
  <circle cx="550" cy="100" r="10" fill="#f39c12"/>
  <text x="550" y="70" text-anchor="middle" fill="#2c3e50" font-size="12">Phase 3</text>
  <text x="550" y="130" text-anchor="middle" fill="#95a5a6" font-size="11">6月</text>

  <!-- 完了 -->
  <circle cx="700" cy="100" r="12" fill="#2ecc71"/>
  <text x="700" y="70" text-anchor="middle" fill="#2c3e50" font-size="12" font-weight="bold">完了</text>
  <text x="700" y="130" text-anchor="middle" fill="#95a5a6" font-size="11">9月</text>

  <!-- 進行中の区間 -->
  <rect x="150" y="95" width="200" height="10" fill="#3498db" opacity="0.5"/>
  <rect x="350" y="95" width="200" height="10" fill="#ecf0f1"/>
</svg>
```

---

## 使用上の注意

1. **色の一貫性**: 同じ意味には同じ色を使う（成功=緑、警告=赤など）
2. **シンプルに**: 1つの図に詰め込みすぎない
3. **テキストの可読性**: 背景とのコントラストを確保
4. **レスポンシブ**: viewBoxを使用してサイズ調整可能に
