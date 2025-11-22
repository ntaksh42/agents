# Example 3: Buffer Overflow Detection

## シナリオ
配列の境界を超えたアクセスによるバッファオーバーフロー問題

## 入力コード

```cpp
#include <iostream>
#include <cstring>

// 問題1: C配列の境界チェックなし
void unsafeCArray() {
    int arr[10];
    for (int i = 0; i <= 10; ++i) { // i=10でオーバーフロー
        arr[i] = i * 2;
    }
}

// 問題2: strcpyによるバッファオーバーフロー
void unsafeStringCopy() {
    char buffer[10];
    const char* source = "This is a very long string";
    strcpy(buffer, source); // バッファオーバーフロー
}

// 問題3: ポインタ演算のミス
void unsafePointerArithmetic() {
    int arr[5] = {1, 2, 3, 4, 5};
    int* ptr = arr;

    for (int i = 0; i < 10; ++i) { // 配列は5要素のみ
        *(ptr + i) = i;
    }
}

// 問題4: 文字列連結によるオーバーフロー
void unsafeStringConcat() {
    char dest[20] = "Hello";
    const char* src1 = " World";
    const char* src2 = " This is too long";

    strcat(dest, src1); // OK
    strcat(dest, src2); // バッファオーバーフロー
}

// 問題5: ユーザー入力の検証なし
void unsafeUserInput() {
    char buffer[100];
    std::cout << "Enter text: ";
    std::cin >> buffer; // 100文字以上入力されるとオーバーフロー
}

// 問題6: 多次元配列のミス
void unsafeMultiDimArray() {
    int matrix[3][3];

    for (int i = 0; i < 4; ++i) { // 範囲外
        for (int j = 0; j < 4; ++j) { // 範囲外
            matrix[i][j] = i + j;
        }
    }
}

int main() {
    unsafeCArray();
    unsafeStringCopy();
    unsafePointerArithmetic();
    unsafeStringConcat();
    unsafeUserInput();
    unsafeMultiDimArray();
    return 0;
}
```

## 期待される出力

```markdown
## 分析結果

### 🔍 検出された問題

#### 問題 1: 配列境界外アクセス (重要度: 🔴 Critical)

**場所**: example.cpp:5-10 (unsafeCArray)

**問題のあるコード**:
```cpp
void unsafeCArray() {
    int arr[10];
    for (int i = 0; i <= 10; ++i) { // i=10でオーバーフロー
        arr[i] = i * 2;
    }
}
```

**問題点**:
- 配列`arr`は0〜9のインデックスのみ有効（10要素）
- ループは`i <= 10`なので、`i=10`のときに境界外アクセス
- 未定義動作、クラッシュ、データ破損の可能性

**修正案**:
```cpp
// オプション1: ループ条件を修正
void safeCArray() {
    int arr[10];
    for (int i = 0; i < 10; ++i) { // i < 10 に修正
        arr[i] = i * 2;
    }
}

// オプション2: std::array を使用（推奨）
void safeWithStdArray() {
    std::array<int, 10> arr;
    for (size_t i = 0; i < arr.size(); ++i) {
        arr[i] = i * 2;
    }
}

// オプション3: 範囲for を使用（最も安全）
void safeWithRangeFor() {
    std::array<int, 10> arr;
    int value = 0;
    for (auto& elem : arr) {
        elem = value * 2;
        ++value;
    }
}

// オプション4: std::generate を使用
void safeWithGenerate() {
    std::array<int, 10> arr;
    int value = 0;
    std::generate(arr.begin(), arr.end(), [&value]() {
        return (value++) * 2;
    });
}

// オプション5: 境界チェック付きアクセス
void safeWithBoundsCheck() {
    std::array<int, 10> arr;
    for (int i = 0; i <= 10; ++i) {
        try {
            arr.at(i) = i * 2; // at()は境界チェックあり
        } catch (const std::out_of_range& e) {
            std::cerr << "Index out of range: " << i << std::endl;
        }
    }
}
```

**説明**:
- C配列よりも`std::array`を使用
- `operator[]`は境界チェックなし、`at()`は境界チェックあり
- 範囲forやアルゴリズムを使うとインデックスミスを防げる

---

#### 問題 2: strcpyによるバッファオーバーフロー (重要度: 🔴 Critical)

**場所**: example.cpp:13-17 (unsafeStringCopy)

**問題のあるコード**:
```cpp
void unsafeStringCopy() {
    char buffer[10];
    const char* source = "This is a very long string";
    strcpy(buffer, source); // バッファオーバーフロー
}
```

**問題点**:
- `buffer`は10バイトしかない
- `source`は26文字+ null終端で27バイト必要
- `strcpy`は境界チェックをしないため、オーバーフロー発生

**修正案**:
```cpp
// オプション1: std::string を使用（推奨）
void safeWithString() {
    std::string buffer;
    const char* source = "This is a very long string";
    buffer = source; // 自動的に適切なサイズに
}

// オプション2: strncpy を使用（C言語スタイル）
void safeWithStrncpy() {
    char buffer[10];
    const char* source = "This is a very long string";
    strncpy(buffer, source, sizeof(buffer) - 1);
    buffer[sizeof(buffer) - 1] = '\0'; // null終端を保証
}

// オプション3: snprintf を使用
void safeWithSnprintf() {
    char buffer[10];
    const char* source = "This is a very long string";
    snprintf(buffer, sizeof(buffer), "%s", source);
    // 自動的にnull終端される
}

// オプション4: std::string_view と substr（C++17）
void safeWithStringView() {
    constexpr size_t bufferSize = 10;
    std::string_view source = "This is a very long string";

    // 必要な部分だけ取得
    std::string buffer(source.substr(0, bufferSize - 1));
}

// オプション5: 動的サイズ確保
void safeWithDynamicSize() {
    const char* source = "This is a very long string";
    size_t requiredSize = std::strlen(source) + 1;

    std::unique_ptr<char[]> buffer(new char[requiredSize]);
    std::strcpy(buffer.get(), source); // サイズが保証されているので安全

    // または std::vector<char>
    std::vector<char> buffer2(requiredSize);
    std::strcpy(buffer2.data(), source);
}
```

**説明**:
- `strcpy`, `strcat`などの古いC関数は危険
- `std::string`を使用するのが最も安全で簡単
- C文字列を使う必要がある場合は、サイズ制限付きの関数を使用

---

#### 問題 3: ポインタ演算の境界外アクセス (重要度: 🔴 Critical)

**場所**: example.cpp:20-27 (unsafePointerArithmetic)

**問題のあるコード**:
```cpp
void unsafePointerArithmetic() {
    int arr[5] = {1, 2, 3, 4, 5};
    int* ptr = arr;

    for (int i = 0; i < 10; ++i) { // 配列は5要素のみ
        *(ptr + i) = i;
    }
}
```

**問題点**:
- 配列は5要素（インデックス0〜4）
- ループは10回実行され、`i=5`以降は境界外アクセス
- ポインタ演算では境界チェックがない

**修正案**:
```cpp
// オプション1: std::array とサイズを使用
void safeWithArraySize() {
    std::array<int, 5> arr = {1, 2, 3, 4, 5};
    int* ptr = arr.data();

    for (size_t i = 0; i < arr.size(); ++i) {
        *(ptr + i) = i;
    }
}

// オプション2: イテレータを使用（推奨）
void safeWithIterator() {
    std::array<int, 5> arr = {1, 2, 3, 4, 5};

    int value = 0;
    for (auto it = arr.begin(); it != arr.end(); ++it) {
        *it = value++;
    }
}

// オプション3: 範囲for（最も安全）
void safeWithRangeFor() {
    std::array<int, 5> arr = {1, 2, 3, 4, 5};

    int value = 0;
    for (auto& elem : arr) {
        elem = value++;
    }
}

// オプション4: std::span でポインタを安全にラップ（C++20）
void safeWithSpan() {
    int arr[5] = {1, 2, 3, 4, 5};
    std::span<int> spanArr(arr, 5);

    for (size_t i = 0; i < spanArr.size(); ++i) {
        spanArr[i] = i;
    }
}

// オプション5: ポインタ使用時は終端ポインタをチェック
void safePointerWithEndCheck() {
    int arr[5] = {1, 2, 3, 4, 5};
    int* ptr = arr;
    int* end = arr + 5;

    int value = 0;
    while (ptr != end) {
        *ptr = value++;
        ++ptr;
    }
}
```

**説明**:
- ポインタ演算は危険なので、できる限りイテレータを使用
- C++20の`std::span`は配列とサイズをセットで管理
- ポインタを使う場合は、終端ポインタと比較

---

#### 問題 4: 文字列連結によるバッファオーバーフロー (重要度: 🔴 Critical)

**場所**: example.cpp:30-37 (unsafeStringConcat)

**問題のあるコード**:
```cpp
void unsafeStringConcat() {
    char dest[20] = "Hello";
    const char* src1 = " World";
    const char* src2 = " This is too long";

    strcat(dest, src1); // OK: "Hello World" = 11文字
    strcat(dest, src2); // NG: 合計28文字で20を超える
}
```

**問題点**:
- `dest`バッファは20バイト
- 最終的に28文字+ null終端で29バイト必要
- `strcat`は境界チェックしないためオーバーフロー

**修正案**:
```cpp
// オプション1: std::string を使用（推奨）
void safeStringConcat() {
    std::string dest = "Hello";
    const char* src1 = " World";
    const char* src2 = " This is too long";

    dest += src1; // 安全
    dest += src2; // 安全、自動的にサイズ拡張
}

// オプション2: strncat を使用
void safeWithStrncat() {
    char dest[20] = "Hello";
    const char* src1 = " World";
    const char* src2 = " This is too long";

    size_t remaining = sizeof(dest) - strlen(dest) - 1;
    strncat(dest, src1, remaining);

    remaining = sizeof(dest) - strlen(dest) - 1;
    strncat(dest, src2, remaining);
}

// オプション3: snprintf で事前計算
void safeWithSnprintf() {
    const char* str1 = "Hello";
    const char* str2 = " World";
    const char* str3 = " This is too long";

    // 必要なサイズを計算
    int required = snprintf(nullptr, 0, "%s%s%s", str1, str2, str3);

    if (required > 0) {
        std::vector<char> buffer(required + 1);
        snprintf(buffer.data(), buffer.size(), "%s%s%s", str1, str2, str3);
        // buffer.data() を使用
    }
}

// オプション4: stringstream（C++スタイル）
void safeWithStringStream() {
    std::ostringstream oss;
    oss << "Hello" << " World" << " This is too long";
    std::string result = oss.str();
}

// オプション5: std::format (C++20)
void safeWithFormat() {
    std::string result = std::format("{}{}{}",
        "Hello", " World", " This is too long");
}
```

**説明**:
- `strcat`は危険、`strncat`も使いづらい
- `std::string`なら演算子`+=`で安全に連結
- C++20の`std::format`は型安全で便利

---

#### 問題 5: ユーザー入力の検証なし (重要度: 🔴 Critical)

**場所**: example.cpp:40-44 (unsafeUserInput)

**問題のあるコード**:
```cpp
void unsafeUserInput() {
    char buffer[100];
    std::cout << "Enter text: ";
    std::cin >> buffer; // 100文字以上入力されるとオーバーフロー
}
```

**問題点**:
- `std::cin >> buffer`は入力サイズを制限しない
- ユーザーが100文字以上入力するとバッファオーバーフロー
- セキュリティ脆弱性の原因

**修正案**:
```cpp
// オプション1: std::string を使用（推奨）
void safeWithString() {
    std::string buffer;
    std::cout << "Enter text: ";
    std::getline(std::cin, buffer); // 任意の長さを安全に処理
}

// オプション2: 入力サイズを制限
void safeWithLimit() {
    char buffer[100];
    std::cout << "Enter text: ";
    std::cin.width(sizeof(buffer)); // 入力サイズを制限
    std::cin >> buffer;
}

// オプション3: get() で文字数制限
void safeWithGet() {
    char buffer[100];
    std::cout << "Enter text: ";
    std::cin.get(buffer, sizeof(buffer));

    // 残りの入力をクリア
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
}

// オプション4: fgets（C関数）
void safeWithFgets() {
    char buffer[100];
    std::cout << "Enter text: ";
    std::cout.flush();

    if (fgets(buffer, sizeof(buffer), stdin)) {
        // 末尾の改行を削除
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len - 1] == '\n') {
            buffer[len - 1] = '\0';
        }
    }
}

// オプション5: 入力検証と制限
void safeWithValidation() {
    std::string input;
    std::cout << "Enter text (max 99 chars): ";
    std::getline(std::cin, input);

    if (input.length() > 99) {
        std::cerr << "Input too long, truncating\n";
        input = input.substr(0, 99);
    }

    // inputを使用
}
```

**説明**:
- ユーザー入力は常に検証が必要
- `std::string`を使えば長さを気にする必要なし
- C配列を使う場合は、必ず入力サイズを制限

---

#### 問題 6: 多次元配列の境界外アクセス (重要度: 🔴 Critical)

**場所**: example.cpp:47-54 (unsafeMultiDimArray)

**問題のあるコード**:
```cpp
void unsafeMultiDimArray() {
    int matrix[3][3];

    for (int i = 0; i < 4; ++i) { // 範囲外: 0-2が正しい
        for (int j = 0; j < 4; ++j) { // 範囲外: 0-2が正しい
            matrix[i][j] = i + j;
        }
    }
}
```

**問題点**:
- `matrix`は3×3 = 9要素
- ループは4×4 = 16回アクセスを試みる
- `i=3`または`j=3`のときに境界外アクセス

**修正案**:
```cpp
// オプション1: ループ条件を修正
void safeMultiDimArray() {
    int matrix[3][3];

    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            matrix[i][j] = i + j;
        }
    }
}

// オプション2: std::array を使用（推奨）
void safeWithStdArray() {
    std::array<std::array<int, 3>, 3> matrix;

    for (size_t i = 0; i < matrix.size(); ++i) {
        for (size_t j = 0; j < matrix[i].size(); ++j) {
            matrix[i][j] = i + j;
        }
    }
}

// オプション3: 範囲for を使用
void safeWithRangeFor() {
    std::array<std::array<int, 3>, 3> matrix;

    size_t i = 0;
    for (auto& row : matrix) {
        size_t j = 0;
        for (auto& elem : row) {
            elem = i + j;
            ++j;
        }
        ++i;
    }
}

// オプション4: 1次元配列としてラップ
class Matrix {
private:
    std::vector<int> data;
    size_t rows, cols;

public:
    Matrix(size_t r, size_t c) : rows(r), cols(c), data(r * c, 0) {}

    int& at(size_t i, size_t j) {
        if (i >= rows || j >= cols) {
            throw std::out_of_range("Matrix index out of range");
        }
        return data[i * cols + j];
    }

    int operator()(size_t i, size_t j) const {
        return data[i * cols + j]; // チェックなし（高速）
    }

    size_t numRows() const { return rows; }
    size_t numCols() const { return cols; }
};

void safeWithMatrixClass() {
    Matrix matrix(3, 3);

    for (size_t i = 0; i < matrix.numRows(); ++i) {
        for (size_t j = 0; j < matrix.numCols(); ++j) {
            matrix.at(i, j) = i + j; // 境界チェックあり
        }
    }
}

// オプション5: Eigenなどのライブラリ使用
#include <Eigen/Dense>

void safeWithEigen() {
    Eigen::Matrix3i matrix;

    for (int i = 0; i < matrix.rows(); ++i) {
        for (int j = 0; j < matrix.cols(); ++j) {
            matrix(i, j) = i + j;
        }
    }
}
```

**説明**:
- 多次元配列は`std::array`のネストで管理
- カスタムMatrixクラスで境界チェック
- 数値計算にはEigenなどのライブラリが便利

---

### ✅ 改善提案

1. **C配列ではなくstd::arrayを使用**
   - サイズ情報を保持
   - `at()`で境界チェック可能
   - イテレータサポート

2. **C文字列関数を避ける**
   - `strcpy`, `strcat`, `sprintf` → 使用しない
   - `std::string` を優先
   - 必要なら`strncpy`, `strncat`, `snprintf`

3. **ユーザー入力は常に検証**
   - サイズ制限を設ける
   - `std::string`で受け取る
   - 入力後に検証

4. **ポインタ演算より イテレータ**
   - 範囲forや標準アルゴリズムを使用
   - インデックスミスを防ぐ

5. **C++20の新機能を活用**
   - `std::span` でポインタとサイズを管理
   - `std::format` で安全な文字列フォーマット

### 📚 参考情報

- [C++ Core Guidelines: Bounds.1 - Don't use pointer arithmetic](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#probounds-bounds-safety-profile)
- [CWE-120: Buffer Copy without Checking Size of Input](https://cwe.mitre.org/data/definitions/120.html)
- [CWE-787: Out-of-bounds Write](https://cwe.mitre.org/data/definitions/787.html)
```

## 学習ポイント

このサンプルから学べること：
1. 配列境界チェックの重要性
2. C文字列関数（strcpy, strcat）の危険性
3. ユーザー入力の適切な処理
4. std::arrayとstd::stringの活用
5. ポインタ演算の代替手段
