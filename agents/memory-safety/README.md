# Memory Safety Analyzer

C++のメモリ安全性を分析・改善するエージェント

## 概要

このエージェントは、C++コードにおけるメモリ関連の問題を検出し、修正提案を行います。

## 主な機能

- **メモリリーク検出**: newとdeleteの不一致、スマートポインタの使用推奨
- **ダングリングポインタ検出**: 解放済みメモリへのアクセス
- **バッファオーバーフロー防止**: 配列境界チェック、std::array/std::vectorの推奨
- **RAIIパターン適用**: リソース管理の自動化
- **スマートポインタ推奨**: unique_ptr、shared_ptr、weak_ptrの適切な使用

## 対象となる問題

### メモリリーク
```cpp
// 問題のあるコード
void badFunction() {
    int* ptr = new int[100];
    // delete[] が呼ばれない
}

// 修正提案
void goodFunction() {
    std::unique_ptr<int[]> ptr(new int[100]);
    // 自動的に解放される
}
```

### ダングリングポインタ
```cpp
// 問題のあるコード
int* ptr = new int(42);
delete ptr;
*ptr = 10; // ダングリングポインタ

// 修正提案
std::unique_ptr<int> ptr = std::make_unique<int>(42);
ptr.reset(); // 明示的にnullptrに
// ptr.get() == nullptr をチェック可能
```

## 使用方法

🚧 開発予定

## 技術スタック

- 静的解析
- パターンマッチング
- C++11/14/17/20 標準ライブラリ知識

## 今後の拡張

- Valgrind等のツール連携
- カスタムルール定義
- プロジェクト全体の分析レポート生成
