# .NET & C++ Localizer Skill

.NETとC++アプリケーションの国際化（i18n）と地域化（l10n）を完全サポートするClaude Code スキルです。

## 概要

エンタープライズレベルの多言語対応を**.NET**と**C++**の両方で実現します。リソースファイル生成、翻訳管理、ベストプラクティス適用まで完全自動化。

## 主な機能

- ✅ **.NET サポート**: .resx、IStringLocalizer、ASP.NET Core
- ✅ **C++ サポート**: gettext (.po)、ICU、Boost.Locale
- ✅ **自動リソース生成**: ハードコード文字列の検出と変換
- ✅ **翻訳管理**: 進捗トラッキング、品質チェック
- ✅ **複数形対応**: 言語別の複数形ルール
- ✅ **文化対応フォーマット**: 日付・通貨・数値
- ✅ **本番環境対応**: パフォーマンス最適化、キャッシング

## 対応技術

### .NET ファミリー
- .NET Core / .NET 6/7/8/9
- ASP.NET Core (MVC, Razor, Blazor)
- WPF、WinForms
- Xamarin、.NET MAUI
- Unity (C#)

### C++ フレームワーク
- **gettext** - GNU翻訳システム（最も人気）
- **ICU** - Unicode、日付・通貨フォーマット
- **Boost.Locale** - C++標準風API
- **Qt Linguist** - Qtフレームワーク

## クイックスタート

### .NET 例

```
ASP.NET Core MVCに国際化追加：
言語: 英語、日本語、中国語
リソース: Resources/
機能: IStringLocalizer、言語切り替え
```

### C++ 例

```
C++ アプリにgettext統合：
ライブラリ: gettext
言語: 英語、日本語、フランス語
出力: .po/.mo ファイル
```

## 主要機能

### 1. .NET リソースファイル生成

**.resx ファイル構造**:
```
Resources/
├── Controllers/
│   ├── HomeController.en.resx
│   └── HomeController.ja.resx
└── Views/
    └── Home/
        ├── Index.en.resx
        └── Index.ja.resx
```

**使用方法**:
```csharp
// IStringLocalizer
private readonly IStringLocalizer<HomeController> _localizer;

public IActionResult Index()
{
    ViewData["Message"] = _localizer["Welcome"];
    return View();
}
```

### 2. C++ gettext 統合

**ファイル構造**:
```
myapp/
├── po/
│   ├── myapp.pot        # テンプレート
│   ├── ja/myapp.po      # 日本語
│   └── fr/myapp.po      # フランス語
└── locale/
    └── ja/LC_MESSAGES/
        └── myapp.mo     # コンパイル済み
```

**使用方法**:
```cpp
#include "i18n.h"

int main() {
    initI18n("myapp", "./locale");

    std::cout << _("Welcome!") << std::endl;
    printf(_("Hello, %s!\n"), name.c_str());

    // 複数形
    printf(_n("You have %d message",
              "You have %d messages", count), count);
}
```

### 3. ICU 高度なフォーマット

```cpp
// 日付フォーマット
DateFormat* fmt = DateFormat::createDateInstance(
    DateFormat::kFull, Locale("ja_JP"));
fmt->format(now, dateStr);
// 出力: 2025年11月22日金曜日

// 通貨フォーマット
NumberFormat* currency = NumberFormat::createCurrencyInstance(
    Locale("ja_JP"), status);
currency->format(1234.56, result);
// 出力: ¥1,235
```

## ベストプラクティス

### .NET
1. **IStringLocalizer 使用** - ResourceManager より推奨
2. **リソース整理** - コントローラー/ビュー別
3. **ハードコード回避** - すべて文字列リソース化
4. **文化フォールバック** - ja-JP → ja → デフォルト
5. **キャッシング** - パフォーマンス向上

### C++
1. **gettext 優先** - 翻訳管理に最適
2. **ICU 併用** - 日付・通貨はICU
3. **UTF-8 統一** - 文字エンコーディング
4. **マクロ使用** - `_()` でシンプルに
5. **自動抽出** - xgettext 活用

## 翻訳ワークフロー

### 1. 文字列抽出
```bash
# .NET
dotnet run --project LocalizationTool extract

# C++
xgettext --keyword=_ --output=messages.pot src/**/*.cpp
```

### 2. 翻訳ファイル生成
```bash
# C++ (.po ファイル作成)
msginit --input=myapp.pot --locale=ja_JP --output=ja/myapp.po
```

### 3. コンパイル
```bash
# C++ (.mo ファイル生成)
msgfmt --output-file=locale/ja/LC_MESSAGES/myapp.mo po/ja/myapp.po
```

### 4. 進捗確認
```
Translation Progress
====================
Japanese (ja):   100% ✅ (250/250)
Chinese (zh):     85% ⚠️  (213/250)
Spanish (es):     60% ❌ (150/250)
```

## 使用例

### 例1: ASP.NET Core Web API

```
ASP.NET Core Web APIを多言語化:
- APIレスポンスメッセージ
- バリデーションエラー
- Accept-Language ヘッダー対応
言語: 英語、日本語、中国語
```

### 例2: WPF デスクトップアプリ

```
WPF アプリに多言語対応:
- すべてのUI要素（ラベル、ボタン）
- メッセージボックス
- ランタイム言語切り替え
言語: 英語、日本語、ドイツ語
```

### 例3: C++ クロスプラットフォームCLI

```
C++ CLIツールにgettext統合:
- ヘルプメッセージ
- エラーメッセージ
- 進捗表示
言語: 英語、日本語、フランス語
```

## 対応言語

- 日本語 (ja)
- 英語 (en)
- 中国語 (zh-CN, zh-TW)
- 韓国語 (ko)
- スペイン語 (es)
- フランス語 (fr)
- ドイツ語 (de)
- イタリア語 (it)
- ポルトガル語 (pt)
- その他50以上

## ツール

### .NET
- **ResXManager** - Visual Studio拡張
- **Zeta Resource Editor** - エディター

### C++
- **Poedit** - .po ファイルGUIエディター
- **xgettext** - 文字列抽出
- **msgfmt** - .po → .mo コンパイル

## 詳細ドキュメント

完全な実装例、コードサンプル、高度な機能は [SKILL.md](SKILL.md) を参照してください。

## 参考リンク

- [.NET Localization (Microsoft)](https://learn.microsoft.com/en-us/dotnet/core/extensions/localization)
- [ASP.NET Core Localization](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/localization)
- [GNU gettext Manual](https://www.gnu.org/software/gettext/manual/)
- [ICU Documentation](https://unicode-org.github.io/icu/)

## バージョン

- Version: 1.0.0
- .NET: .NET Core 3.1+, .NET 6/7/8/9
- C++: C++11+
- Last Updated: 2025-11-22
