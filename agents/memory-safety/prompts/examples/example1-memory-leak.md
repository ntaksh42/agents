# Example 1: Memory Leak Detection

## シナリオ
関数内でnewしたメモリをdeleteせずに関数が終了する典型的なメモリリーク

## 入力コード

```cpp
#include <iostream>

class DataProcessor {
private:
    int* data;
    size_t size;

public:
    DataProcessor(size_t n) : size(n) {
        data = new int[n];
        std::cout << "Allocated " << n << " integers\n";
    }

    void process() {
        for (size_t i = 0; i < size; ++i) {
            data[i] = i * 2;
        }
    }

    void printData() {
        for (size_t i = 0; i < size; ++i) {
            std::cout << data[i] << " ";
        }
        std::cout << "\n";
    }

    // デストラクタが定義されていない！
};

void badFunction() {
    int* numbers = new int[100];
    for (int i = 0; i < 100; ++i) {
        numbers[i] = i;
    }
    // delete[] が呼ばれない - メモリリーク
}

void anotherBadFunction() {
    DataProcessor* processor = new DataProcessor(50);
    processor->process();
    processor->printData();
    // delete が呼ばれない - メモリリーク
}

int main() {
    badFunction();
    anotherBadFunction();
    return 0;
}
```

## 期待される出力

```markdown
## 分析結果

### 🔍 検出された問題

#### 問題 1: メモリリーク (重要度: 🔴 Critical)

**場所**: example.cpp:29-35 (badFunction)

**問題のあるコード**:
```cpp
void badFunction() {
    int* numbers = new int[100];
    for (int i = 0; i < 100; ++i) {
        numbers[i] = i;
    }
    // delete[] が呼ばれない
}
```

**問題点**:
- `new int[100]` で確保したメモリが解放されていません
- 関数終了時にポインタ変数は消えますが、メモリは解放されません
- 関数が呼ばれるたびに400バイト（100 * sizeof(int)）のメモリがリーク

**修正案**:
```cpp
void goodFunction() {
    std::vector<int> numbers(100);
    for (int i = 0; i < 100; ++i) {
        numbers[i] = i;
    }
    // 自動的に解放される
}

// または、どうしても生配列が必要な場合
void alternativeFunction() {
    std::unique_ptr<int[]> numbers(new int[100]);
    // または C++14以降
    // auto numbers = std::make_unique<int[]>(100);

    for (int i = 0; i < 100; ++i) {
        numbers[i] = i;
    }
    // 自動的に解放される
}
```

**説明**:
- `std::vector`を使用することで、メモリ管理が自動化されます
- スコープを抜けるときにデストラクタが自動的に呼ばれ、メモリが解放されます
- どうしても生配列が必要な場合は`std::unique_ptr<int[]>`を使用

---

#### 問題 2: メモリリークとRule of Three違反 (重要度: 🔴 Critical)

**場所**: example.cpp:3-24 (DataProcessor class)

**問題のあるコード**:
```cpp
class DataProcessor {
private:
    int* data;
    size_t size;

public:
    DataProcessor(size_t n) : size(n) {
        data = new int[n];
    }
    // デストラクタ、コピーコンストラクタ、コピー代入演算子が未定義
};
```

**問題点**:
1. デストラクタが定義されていないため、`data`が解放されません
2. コピーコンストラクタが定義されていないため、シャローコピーが発生
3. コピー代入演算子が定義されていないため、シャローコピーが発生
4. これは「Rule of Three」の違反です

**修正案**:
```cpp
// オプション1: Rule of Five を実装
class DataProcessor {
private:
    int* data;
    size_t size;

public:
    DataProcessor(size_t n) : size(n), data(new int[n]) {
        std::cout << "Allocated " << n << " integers\n";
    }

    // デストラクタ
    ~DataProcessor() {
        delete[] data;
    }

    // コピーコンストラクタ
    DataProcessor(const DataProcessor& other)
        : size(other.size), data(new int[other.size]) {
        std::copy(other.data, other.data + size, data);
    }

    // コピー代入演算子
    DataProcessor& operator=(const DataProcessor& other) {
        if (this != &other) {
            delete[] data;
            size = other.size;
            data = new int[size];
            std::copy(other.data, other.data + size, data);
        }
        return *this;
    }

    // ムーブコンストラクタ (C++11)
    DataProcessor(DataProcessor&& other) noexcept
        : size(other.size), data(other.data) {
        other.data = nullptr;
        other.size = 0;
    }

    // ムーブ代入演算子 (C++11)
    DataProcessor& operator=(DataProcessor&& other) noexcept {
        if (this != &other) {
            delete[] data;
            data = other.data;
            size = other.size;
            other.data = nullptr;
            other.size = 0;
        }
        return *this;
    }

    void process() {
        for (size_t i = 0; i < size; ++i) {
            data[i] = i * 2;
        }
    }

    void printData() const {
        for (size_t i = 0; i < size; ++i) {
            std::cout << data[i] << " ";
        }
        std::cout << "\n";
    }
};

// オプション2: std::vector を使用（推奨）
class DataProcessor {
private:
    std::vector<int> data;

public:
    DataProcessor(size_t n) : data(n) {
        std::cout << "Allocated " << n << " integers\n";
    }

    // デストラクタ、コピー、ムーブは自動生成される
    // = default として明示的に宣言することも可能

    void process() {
        for (size_t i = 0; i < data.size(); ++i) {
            data[i] = i * 2;
        }
    }

    void printData() const {
        for (int value : data) {
            std::cout << value << " ";
        }
        std::cout << "\n";
    }
};
```

**説明**:
- オプション1は「Rule of Five」に従い、すべての特殊メンバ関数を実装
- オプション2（推奨）は`std::vector`を使用し、メモリ管理を標準ライブラリに委譲
- `std::vector`を使用すると、コンパイラが適切なコピー・ムーブ操作を自動生成

---

#### 問題 3: メモリリーク (重要度: 🔴 Critical)

**場所**: example.cpp:37-42 (anotherBadFunction)

**問題のあるコード**:
```cpp
void anotherBadFunction() {
    DataProcessor* processor = new DataProcessor(50);
    processor->process();
    processor->printData();
    // delete が呼ばれない
}
```

**問題点**:
- `new DataProcessor(50)` で確保したオブジェクトが解放されていません
- さらに、DataProcessorクラス内部の配列も解放されません（二重のメモリリーク）

**修正案**:
```cpp
void goodFunction() {
    // オプション1: スタック上に作成（推奨）
    DataProcessor processor(50);
    processor.process();
    processor.printData();
    // 自動的に解放される
}

void alternativeFunction() {
    // オプション2: どうしても動的確保が必要な場合
    std::unique_ptr<DataProcessor> processor =
        std::make_unique<DataProcessor>(50);
    processor->process();
    processor->printData();
    // 自動的に解放される
}

void anotherAlternative() {
    // オプション3: shared_ptr（共有所有権が必要な場合）
    std::shared_ptr<DataProcessor> processor =
        std::make_shared<DataProcessor>(50);
    processor->process();
    processor->printData();
    // 参照カウントが0になったときに解放される
}
```

**説明**:
- できる限りスタック上にオブジェクトを作成するのが最も安全
- 動的確保が必要な場合は、スマートポインタを使用
- `unique_ptr`: 単一所有権、最も軽量
- `shared_ptr`: 共有所有権、オーバーヘッドがある

---

### ✅ 改善提案

1. **可能な限り標準ライブラリを使用**
   - `std::vector`, `std::array`, `std::string` などを活用
   - 生ポインタの使用を最小限に

2. **スマートポインタの優先順位**
   - 1st: `std::unique_ptr` (単一所有権)
   - 2nd: `std::shared_ptr` (共有所有権)
   - Last: 生ポインタ（どうしても必要な場合のみ）

3. **Rule of Zero を目指す**
   - 可能な限り、特殊メンバ関数を定義しない
   - 標準ライブラリの型を使用して自動管理

4. **RAII の徹底**
   - すべてのリソースはRAIIで管理
   - スコープベースのリソース管理

### 📚 参考情報

- [C++ Core Guidelines: R.1 - Manage resources automatically using RAII](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rr-raii)
- [C++ Core Guidelines: R.11 - Avoid calling new and delete explicitly](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rr-newdelete)
- [C++ Core Guidelines: C.21 - If you define or =delete any copy, move, or destructor function, define or =delete them all](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rc-five)
```

## 学習ポイント

このサンプルから学べること：
1. メモリリークの典型的なパターン
2. Rule of Three/Five の重要性
3. スマートポインタによる自動メモリ管理
4. 標準ライブラリ（std::vector）の活用
5. RAIIの実践
