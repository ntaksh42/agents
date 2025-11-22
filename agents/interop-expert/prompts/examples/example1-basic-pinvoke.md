# Example 1: Basic P/Invoke - Simple Function Calls

## シナリオ
C++ネイティブDLLの関数をC#から呼び出す基本的なP/Invoke実装

## 要件
- 数値計算関数（加算、乗算）
- プリミティブ型の受け渡し
- クロスプラットフォーム対応（Windows/Linux/macOS）

## 実装

### C++ 側の実装

#### ヘッダーファイル (MathLibrary.h)

```cpp
#ifndef MATH_LIBRARY_H
#define MATH_LIBRARY_H

// プラットフォーム依存のエクスポートマクロ
#ifdef _WIN32
    #define EXPORT __declspec(dllexport)
#else
    #define EXPORT __attribute__((visibility("default")))
#endif

// C言語リンケージ（C++の名前修飾を防ぐ）
#ifdef __cplusplus
extern "C" {
#endif

// 基本的な算術関数
EXPORT int Add(int a, int b);
EXPORT int Multiply(int a, int b);
EXPORT double Divide(double a, double b);

// ポインタを使用する関数
EXPORT void AddWithOutParam(int a, int b, int* result);

// bool型の扱い
EXPORT bool IsPositive(int value);

#ifdef __cplusplus
}
#endif

#endif // MATH_LIBRARY_H
```

#### 実装ファイル (MathLibrary.cpp)

```cpp
#include "MathLibrary.h"
#include <stdexcept>

extern "C" {

EXPORT int Add(int a, int b) {
    return a + b;
}

EXPORT int Multiply(int a, int b) {
    return a * b;
}

EXPORT double Divide(double a, double b) {
    if (b == 0.0) {
        // P/Invokeを通して例外は投げられないので、
        // NaNを返すか、エラーコードを使用
        return 0.0; // または NAN
    }
    return a / b;
}

EXPORT void AddWithOutParam(int a, int b, int* result) {
    if (result != nullptr) {
        *result = a + b;
    }
}

EXPORT bool IsPositive(int value) {
    return value > 0;
}

} // extern "C"
```

#### CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.15)
project(MathLibrary VERSION 1.0.0 LANGUAGES CXX)

# 共有ライブラリとしてビルド
add_library(MathLibrary SHARED
    MathLibrary.cpp
    MathLibrary.h
)

# C++17を使用
target_compile_features(MathLibrary PRIVATE cxx_std_17)

# Windowsの場合、エクスポート用の定義
if(WIN32)
    target_compile_definitions(MathLibrary PRIVATE _WIN32)
endif()

# インストール設定
install(TARGETS MathLibrary
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)
install(FILES MathLibrary.h DESTINATION include)
```

---

### C# 側の実装

#### P/Invoke 宣言 (MathLibrary.cs)

```csharp
using System;
using System.Runtime.InteropServices;

namespace MathInterop
{
    public static class MathLibrary
    {
        // プラットフォーム別のライブラリ名
        private const string LibraryName = "MathLibrary";

        // Windows: MathLibrary.dll
        // Linux: libMathLibrary.so
        // macOS: libMathLibrary.dylib
        // DllImportは自動的にプレフィックス/サフィックスを付ける

        /// <summary>
        /// 2つの整数を加算します
        /// </summary>
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern int Add(int a, int b);

        /// <summary>
        /// 2つの整数を乗算します
        /// </summary>
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern int Multiply(int a, int b);

        /// <summary>
        /// 2つの浮動小数点数を除算します
        /// </summary>
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern double Divide(double a, double b);

        /// <summary>
        /// 加算結果をoutパラメータで返します
        /// </summary>
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        public static extern void AddWithOutParam(int a, int b, out int result);

        /// <summary>
        /// 値が正かどうかを判定します
        /// </summary>
        /// <remarks>
        /// C++のboolは1バイト、C#のboolは4バイトなので、
        /// UnmanagedType.I1を指定して1バイトにマーシャリング
        /// </remarks>
        [DllImport(LibraryName, CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.I1)]
        public static extern bool IsPositive(int value);
    }
}
```

#### 使用例 (Program.cs)

```csharp
using System;
using MathInterop;

class Program
{
    static void Main(string[] args)
    {
        Console.WriteLine("=== P/Invoke Math Library Demo ===\n");

        // 加算
        int sum = MathLibrary.Add(10, 20);
        Console.WriteLine($"Add(10, 20) = {sum}");

        // 乗算
        int product = MathLibrary.Multiply(7, 6);
        Console.WriteLine($"Multiply(7, 6) = {product}");

        // 除算
        double quotient = MathLibrary.Divide(10.0, 3.0);
        Console.WriteLine($"Divide(10.0, 3.0) = {quotient}");

        // ゼロ除算の扱い
        double zeroDiv = MathLibrary.Divide(10.0, 0.0);
        Console.WriteLine($"Divide(10.0, 0.0) = {zeroDiv}");

        // outパラメータ
        MathLibrary.AddWithOutParam(15, 25, out int result);
        Console.WriteLine($"AddWithOutParam(15, 25) = {result}");

        // bool型
        bool isPos = MathLibrary.IsPositive(42);
        Console.WriteLine($"IsPositive(42) = {isPos}");

        bool isNeg = MathLibrary.IsPositive(-5);
        Console.WriteLine($"IsPositive(-5) = {isNeg}");

        Console.WriteLine("\n=== Demo Complete ===");
    }
}
```

#### プロジェクトファイル (.csproj)

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net6.0</TargetFramework>
    <AllowUnsafeBlocks>false</AllowUnsafeBlocks>
  </PropertyGroup>

  <!-- ネイティブライブラリを出力ディレクトリにコピー -->
  <ItemGroup>
    <None Include="$(SolutionDir)native\build\**\*.*">
      <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
    </None>
  </ItemGroup>

</Project>
```

---

## 期待される出力

```
=== P/Invoke Math Library Demo ===

Add(10, 20) = 30
Multiply(7, 6) = 42
Divide(10.0, 3.0) = 3.333333333333333
Divide(10.0, 0.0) = 0
AddWithOutParam(15, 25) = 40
IsPositive(42) = True
IsPositive(-5) = False

=== Demo Complete ===
```

---

## ⚠️ 重要なポイント

### 1. 呼び出し規約（CallingConvention）

```csharp
// Cdecl: C/C++の標準的な呼び出し規約（推奨）
[DllImport("lib.dll", CallingConvention = CallingConvention.Cdecl)]

// StdCall: Win32 API用（__stdcall）
[DllImport("lib.dll", CallingConvention = CallingConvention.StdCall)]

// デフォルトはStdCallなので、C/C++の場合は明示的にCdeclを指定
```

### 2. bool型のサイズ不一致

```cpp
// C++: boolは1バイト
bool IsValid() { return true; }
```

```csharp
// 必ずUnmanagedType.I1を指定
[DllImport("lib.dll")]
[return: MarshalAs(UnmanagedType.I1)]
public static extern bool IsValid();
```

### 3. ライブラリの配置

ネイティブDLLは以下のいずれかに配置：
- 実行ファイルと同じディレクトリ
- システムのPATH
- `DllImport`の`LoadLibrary`で探索されるパス

**.NET 5+** では`NativeLibrary.SetDllImportResolver`でカスタムロード可能：

```csharp
static Program()
{
    NativeLibrary.SetDllImportResolver(
        typeof(MathLibrary).Assembly,
        (libraryName, assembly, searchPath) =>
        {
            if (libraryName == "MathLibrary")
            {
                // カスタムパスからロード
                string path = Path.Combine(AppContext.BaseDirectory, "native", libraryName);
                return NativeLibrary.Load(path);
            }
            return IntPtr.Zero;
        });
}
```

### 4. エラーハンドリング

P/Invokeでは、C++の例外は伝播しません：

```cpp
// ❌ Bad: 例外は C# に到達しない
extern "C" EXPORT int Divide(int a, int b) {
    if (b == 0) {
        throw std::invalid_argument("Division by zero");
    }
    return a / b;
}
```

```cpp
// ✅ Good: エラーコードを返す
extern "C" EXPORT int Divide(int a, int b, int* result) {
    if (b == 0) {
        return -1; // エラーコード
    }
    if (result != nullptr) {
        *result = a / b;
    }
    return 0; // 成功
}
```

```csharp
// C# 側でエラーコードをチェック
int result;
int errorCode = NativeLib.Divide(10, 2, out result);
if (errorCode != 0) {
    throw new DivideByZeroException();
}
```

---

## 🚀 最適化とベストプラクティス

### 1. Blittable型の使用

以下の型はマーシャリング不要（高速）：
- `int`, `long`, `float`, `double`
- `IntPtr`, `UIntPtr`
- 参照型を含まない構造体

### 2. .NET 7+ の LibraryImport

```csharp
// .NET 7以降は LibraryImport を推奨（ソース生成）
[LibraryImport(LibraryName)]
public static partial int Add(int a, int b);

// DllImportよりも高速でトリム可能
```

### 3. 関数ポインタの再利用

頻繁に呼び出す場合：

```csharp
// デリゲートとして取得して再利用
private static IntPtr _libraryHandle;
private delegate int AddDelegate(int a, int b);
private static AddDelegate _addFunc;

static void InitializeLibrary()
{
    _libraryHandle = NativeLibrary.Load("MathLibrary");
    IntPtr funcPtr = NativeLibrary.GetExport(_libraryHandle, "Add");
    _addFunc = Marshal.GetDelegateForFunctionPointer<AddDelegate>(funcPtr);
}

public static int Add(int a, int b) => _addFunc(a, b);
```

---

## 📚 トラブルシューティング

### DllNotFoundException

```
System.DllNotFoundException: Unable to load DLL 'MathLibrary'
```

**原因**:
- DLLが見つからない
- プラットフォーム不一致（x86/x64）
- 依存DLLが不足

**解決策**:
1. DLLを実行ファイルと同じフォルダに配置
2. プラットフォームターゲットを確認（AnyCPU → x64）
3. Dependency Walkerで依存関係確認（Windows）

### EntryPointNotFoundException

```
System.EntryPointNotFoundException: Unable to find an entry point named 'Add'
```

**原因**:
- 関数名が間違っている
- `extern "C"`がない（C++の名前修飾）
- 呼び出し規約の不一致

**解決策**:
1. `dumpbin /EXPORTS MathLibrary.dll`（Windows）で関数名確認
2. `nm -D libMathLibrary.so`（Linux）で関数名確認
3. `extern "C"`を確認
4. `CallingConvention`を確認

---

## 学習ポイント

このサンプルから学べること：
1. P/Invokeの基本構文
2. プラットフォーム間のライブラリ名の違い
3. 呼び出し規約の重要性
4. bool型のサイズ不一致への対処
5. エラーハンドリングの方法
6. Blittable型によるパフォーマンス最適化
