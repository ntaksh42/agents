# HTML Presentation Skill - 使い方ガイド

このスキルを使用して、reveal.jsベースの美しいHTMLプレゼンテーションを作成できます。

## クイックスタート

### 1. スキルの使用

Claude Codeで以下のようにリクエストします：

```
HTMLプレゼンテーションを作成してください。
タイトル: "C++のメモリ管理"
テーマ: night
スライド:
1. イントロダクション
2. メモリリークの問題
3. スマートポインタ
4. まとめ
```

### 2. プレゼンテーションの表示

生成された`index.html`をブラウザで開くだけで動作します。

または、ローカルサーバーを起動：

```bash
# Python 3
python -m http.server 8000

# Node.js
npx http-server

# PHP
php -S localhost:8000
```

ブラウザで `http://localhost:8000` を開きます。

### 3. サンプルを見る

`example-presentation.html` をブラウザで開いて、実際のプレゼンテーションを確認できます。

## ファイル構成

```
.claude/skills/html-presentation/
├── skill.md                    # スキルの説明
├── template.html               # プレゼンテーションテンプレート
├── example-presentation.html   # サンプルプレゼンテーション
└── README.md                   # このファイル
```

## テンプレートのカスタマイズ

### テーマの変更

`template.html` の以下の行を編集：

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4.5.0/dist/theme/night.css">
```

利用可能なテーマ:
- `black.css` - ダークテーマ（デフォルト）
- `white.css` - ライトテーマ
- `league.css` - グレーベース
- `beige.css` - ベージュ
- `sky.css` - ブルー系
- `night.css` - ダーク + コントラスト
- `serif.css` - セリフフォント
- `simple.css` - シンプル
- `solarized.css` - Solarizedカラー

### トランジション効果の変更

JavaScript初期化部分を編集：

```javascript
Reveal.initialize({
    transition: 'slide', // none/fade/slide/convex/concave/zoom
    // ...
});
```

### コードハイライトテーマ

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4.5.0/plugin/highlight/monokai.css">
```

利用可能なテーマ:
- `monokai.css`
- `zenburn.css`
- `github.css`
- `atom-one-dark.css`
など

## スライドの種類

### 基本スライド

```html
<section>
    <h2>タイトル</h2>
    <p>コンテンツ</p>
</section>
```

### 縦方向のスライド（ドリルダウン）

```html
<section>
    <section>
        <h2>メイントピック</h2>
    </section>
    <section>
        <h3>詳細1</h3>
    </section>
    <section>
        <h3>詳細2</h3>
    </section>
</section>
```

### コードスライド

```html
<section>
    <h3>コード例</h3>
    <pre><code class="language-cpp" data-line-numbers>
int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
    </code></pre>
</section>
```

サポートする言語:
- `language-cpp` - C++
- `language-csharp` - C#
- `language-python` - Python
- `language-javascript` - JavaScript
- `language-java` - Java
- その他多数

### 2カラムレイアウト

```html
<section>
    <div class="two-columns">
        <div>
            <h4>左側</h4>
            <p>内容</p>
        </div>
        <div>
            <h4>右側</h4>
            <p>内容</p>
        </div>
    </div>
</section>
```

### フラグメント（段階的表示）

```html
<section>
    <ul>
        <li class="fragment">最初に表示</li>
        <li class="fragment">次に表示</li>
        <li class="fragment">最後に表示</li>
    </ul>
</section>
```

フラグメントのスタイル:
- `fragment fade-in` - フェードイン
- `fragment fade-out` - フェードアウト
- `fragment highlight-red` - 赤でハイライト
- `fragment highlight-blue` - 青でハイライト
- `fragment grow` - 拡大
- `fragment shrink` - 縮小

### スピーカーノート

```html
<section>
    <h2>スライド内容</h2>
    <aside class="notes">
        これは発表者だけに見えるノートです。
        プレゼン中に「S」キーを押すとノートウィンドウが開きます。
    </aside>
</section>
```

### 背景のカスタマイズ

```html
<!-- 単色背景 -->
<section data-background-color="#ff6b6b">
    <h2>赤い背景</h2>
</section>

<!-- グラデーション背景 -->
<section data-background-gradient="linear-gradient(to bottom, #283b95, #17b2c3)">
    <h2>グラデーション</h2>
</section>

<!-- 画像背景 -->
<section data-background-image="image.jpg">
    <h2>画像背景</h2>
</section>

<!-- 動画背景 -->
<section data-background-video="video.mp4">
    <h2>動画背景</h2>
</section>
```

## キーボードショートカット

プレゼンテーション実行時:

| キー | 動作 |
|------|------|
| `→` / `Space` | 次のスライド |
| `←` | 前のスライド |
| `↑` / `↓` | 縦方向のナビゲーション |
| `Home` / `End` | 最初/最後のスライド |
| `ESC` / `O` | スライド一覧表示 |
| `S` | スピーカーノート表示 |
| `F` | フルスクリーン |
| `B` / `.` | 画面を黒く/白く |
| `?` | ヘルプ表示 |

## PDF出力

1. ChromeまたはChromiumベースのブラウザで開く
2. URLに `?print-pdf` を追加
   - 例: `index.html?print-pdf`
3. ブラウザの印刷機能（Ctrl+P / Cmd+P）
4. 「PDFとして保存」を選択

**注意**: 印刷用CSSが自動的に適用されます。

## 高度な機能

### 数式の表示（KaTeX）

```html
<section>
    <h3>数式</h3>
    <p>
        インライン数式: $E = mc^2$
    </p>
    <p>
        ブロック数式:
        $$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$
    </p>
</section>
```

### マークダウンでスライド作成

```html
<section data-markdown>
    <textarea data-template>
        ## スライドタイトル

        - 項目1
        - 項目2
        - 項目3

        ```javascript
        console.log('Hello');
        ```
    </textarea>
</section>
```

### オートスライド（自動再生）

```javascript
Reveal.initialize({
    autoSlide: 5000, // 5秒ごとに自動スライド
    loop: true,      // 最後まで行ったら最初に戻る
    // ...
});
```

## トラブルシューティング

### reveal.jsが読み込まれない

**問題**: スライドが表示されない

**解決策**:
1. インターネット接続を確認（CDNを使用）
2. ブラウザのコンソールでエラー確認
3. オフライン使用の場合、reveal.jsをローカルにダウンロード

### コードハイライトが機能しない

**問題**: コードが単色で表示される

**解決策**:
1. `class="language-xxx"` が正しいか確認
2. highlight.jsのCSSが読み込まれているか確認
3. `<code>` タグが `<pre>` の中にあるか確認

### スライドが縦に並ばない

**問題**: 縦方向のスライドが機能しない

**解決策**:
```html
<!-- 正しい構造 -->
<section>
    <section>親</section>
    <section>子1</section>
    <section>子2</section>
</section>
```

### フルスクリーンが機能しない

**問題**: `F`キーでフルスクリーンにならない

**解決策**:
- ブラウザの設定でフルスクリーンAPIが有効か確認
- ローカルファイルの場合、HTTPサーバー経由で開く

## ベストプラクティス

### デザイン

1. **1スライド1メッセージ**: 情報を詰め込まない
2. **大きな文字**: 最小24px以上
3. **コントラスト**: 背景と文字の明度差を確保
4. **画像活用**: 視覚的に訴える
5. **アニメーション控えめ**: 過度な動きは避ける

### コンテンツ

1. **簡潔に**: 箇条書きは3〜5項目
2. **コード例**: 実用的で短いコード
3. **進行**: ストーリー性を持たせる
4. **まとめ**: 重要ポイントを再確認

### パフォーマンス

1. **画像最適化**: 大きすぎる画像は避ける
2. **動画は慎重に**: 背景動画はファイルサイズに注意
3. **スライド数**: 多すぎると読み込みが遅くなる

## 参考リンク

- [reveal.js 公式ドキュメント](https://revealjs.com/)
- [reveal.js デモ](https://revealjs.com/demo/)
- [reveal.js GitHub](https://github.com/hakimel/reveal.js)
- [KaTeX サポート](https://katex.org/)
- [highlight.js 対応言語](https://github.com/highlightjs/highlight.js/blob/main/SUPPORTED_LANGUAGES.md)

## ライセンス

- reveal.js: MIT License
- このスキル: MIT License

---

**楽しいプレゼンテーションを！** 🎉
