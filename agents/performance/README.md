# Performance Profiler Assistant

パフォーマンス最適化を支援するエージェント

## 概要

C#およびC++アプリケーションのパフォーマンスボトルネックを特定し、最適化提案を行います。

## 主な機能

- **ボトルネック分析**: ホットスポットの特定
- **アルゴリズム最適化**: 計算量の削減
- **SIMD最適化**: ベクトル化による高速化
- **並列処理提案**: マルチスレッド、async/await
- **メモリ使用量削減**: アロケーション最適化
- **キャッシュ最適化**: データ局所性の改善

## 対象となる問題

### ループの最適化（C++）
```cpp
// 最適化前
for (int i = 0; i < size; ++i) {
    result[i] = expensive_function(data[i]);
}

// 最適化後（並列化）
#pragma omp parallel for
for (int i = 0; i < size; ++i) {
    result[i] = expensive_function(data[i]);
}
```

### SIMD最適化
```cpp
// スカラーコード
for (int i = 0; i < size; ++i) {
    c[i] = a[i] + b[i];
}

// SIMD (例: AVX2)
for (int i = 0; i < size; i += 8) {
    __m256 va = _mm256_load_ps(&a[i]);
    __m256 vb = _mm256_load_ps(&b[i]);
    __m256 vc = _mm256_add_ps(va, vb);
    _mm256_store_ps(&c[i], vc);
}
```

### C# 非同期処理
```csharp
// 同期処理（ブロッキング）
public void LoadData()
{
    var data = File.ReadAllText("large-file.txt");
    ProcessData(data);
}

// 非同期処理（ノンブロッキング）
public async Task LoadDataAsync()
{
    var data = await File.ReadAllTextAsync("large-file.txt");
    await ProcessDataAsync(data);
}
```

### メモリアロケーション削減
```csharp
// アロケーション多
public string ConcatenateStrings(string[] items)
{
    string result = "";
    foreach (var item in items)
        result += item; // 毎回新しいstring生成
    return result;
}

// アロケーション削減
public string ConcatenateStrings(string[] items)
{
    return string.Join("", items);
    // or StringBuilder使用
}
```

## 使用方法

🚧 開発予定

## 技術スタック

- プロファイリングツール連携（Visual Studio Profiler、dotTrace、Valgrind）
- Benchmark.NET（C#）
- Google Benchmark（C++）
- SIMD intrinsics
- OpenMP、PPL（Parallel Patterns Library）

## 最適化対象

- CPU バウンド処理
- I/O バウンド処理
- メモリ使用量
- 起動時間
- レスポンスタイム
