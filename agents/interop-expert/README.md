# Interop Expert

C#とC++の相互運用を支援するエージェント

## 概要

C#とC++間のシームレスな統合を実現するためのコード生成と最適化を行います。

## 主な機能

- **P/Invoke コード生成**: DllImport属性を使用したネイティブコール
- **C++/CLI ラッパー作成**: マネージドとアンマネージドの橋渡し
- **マーシャリング最適化**: データ型変換の効率化
- **構造体マッピング**: C++構造体とC#構造体の対応付け
- **コールバック実装**: ネイティブからマネージドへのコールバック

## 対象となる問題

### P/Invoke の基本
```csharp
// C++ 側 (native.dll)
extern "C" __declspec(dllexport) int Add(int a, int b) {
    return a + b;
}

// C# 側
[DllImport("native.dll", CallingConvention = CallingConvention.Cdecl)]
public static extern int Add(int a, int b);
```

### 複雑な型のマーシャリング
```csharp
// C++ 構造体
struct Point {
    double x;
    double y;
};

// C# 構造体 (マーシャリング対応)
[StructLayout(LayoutKind.Sequential)]
public struct Point {
    public double X;
    public double Y;
}
```

### 文字列のマーシャリング
```csharp
// C++ 関数
extern "C" __declspec(dllexport) void ProcessString(const char* str);

// C# P/Invoke
[DllImport("native.dll", CharSet = CharSet.Ansi)]
public static extern void ProcessString(string str);
```

## 使用方法

🚧 開発予定

## 技術スタック

- P/Invoke
- C++/CLI
- Platform Invocation Services
- COM Interop (将来的に)

## サポートするシナリオ

- Windows デスクトップアプリ
- ハイパフォーマンスライブラリの統合
- レガシーC++コードの.NET統合
- クロスプラットフォーム対応（.NET Core）
