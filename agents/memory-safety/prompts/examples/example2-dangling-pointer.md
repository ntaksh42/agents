# Example 2: Dangling Pointer Detection

## シナリオ
解放済みメモリへのアクセスや、スコープを抜けた変数への参照など、ダングリングポインタ/参照の問題

## 入力コード

```cpp
#include <iostream>
#include <string>

// 問題1: 解放済みメモリへのアクセス
void useAfterFree() {
    int* ptr = new int(42);
    delete ptr;
    std::cout << *ptr << std::endl; // ダングリングポインタ
    *ptr = 100; // 未定義動作
}

// 問題2: スコープを抜けた変数への参照
int* returnStackAddress() {
    int localVar = 42;
    return &localVar; // ローカル変数のアドレスを返す
}

// 問題3: 参照の不適切な使用
std::string& getBadReference() {
    std::string temp = "Hello";
    return temp; // ローカル変数への参照を返す
}

// 問題4: コンテナの再配置によるダングリング
void vectorReallocDangling() {
    std::vector<int> vec = {1, 2, 3};
    int* ptr = &vec[0];

    vec.push_back(4); // 容量拡張で再配置の可能性
    vec.push_back(5);
    vec.push_back(6);

    std::cout << *ptr << std::endl; // ptrは無効になっている可能性
}

// 問題5: イテレータの無効化
void iteratorInvalidation() {
    std::vector<int> vec = {1, 2, 3, 4, 5};
    auto it = vec.begin();

    vec.erase(vec.begin() + 2); // イテレータが無効化
    std::cout << *it << std::endl; // 未定義動作の可能性
}

int main() {
    useAfterFree();

    int* badPtr = returnStackAddress();
    std::cout << *badPtr << std::endl; // 未定義動作

    std::string& badRef = getBadReference();
    std::cout << badRef << std::endl; // 未定義動作

    vectorReallocDangling();
    iteratorInvalidation();

    return 0;
}
```

## 期待される出力

```markdown
## 分析結果

### 🔍 検出された問題

#### 問題 1: Use-After-Free (重要度: 🔴 Critical)

**場所**: example.cpp:5-10 (useAfterFree)

**問題のあるコード**:
```cpp
void useAfterFree() {
    int* ptr = new int(42);
    delete ptr;
    std::cout << *ptr << std::endl; // ダングリングポインタ
    *ptr = 100; // 未定義動作
}
```

**問題点**:
- `delete ptr` 後にポインタを使用（Use-After-Free）
- 解放済みメモリへのアクセスは未定義動作
- クラッシュ、データ破損、セキュリティ脆弱性の原因

**修正案**:
```cpp
void safeFunctionOption1() {
    std::unique_ptr<int> ptr = std::make_unique<int>(42);
    std::cout << *ptr << std::endl;
    ptr.reset(); // 明示的にnullptrに

    if (ptr) { // nullチェック
        std::cout << *ptr << std::endl;
    } else {
        std::cout << "Pointer is null\n";
    }
}

void safeFunctionOption2() {
    // そもそもヒープ確保が不要
    int value = 42;
    std::cout << value << std::endl;
    value = 100;
    std::cout << value << std::endl;
}
```

**説明**:
- `unique_ptr`を使用すると、`reset()`後は確実に`nullptr`になります
- 使用前に`if (ptr)`でnullチェック可能
- この例ではそもそもヒープ確保が不要なので、スタック変数を使うのが最適

---

#### 問題 2: スタックアドレスの返却 (重要度: 🔴 Critical)

**場所**: example.cpp:13-16 (returnStackAddress)

**問題のあるコード**:
```cpp
int* returnStackAddress() {
    int localVar = 42;
    return &localVar; // ローカル変数のアドレスを返す
}
```

**問題点**:
- ローカル変数は関数が終了するとスコープを抜けて破棄されます
- 破棄された変数のアドレスを返すとダングリングポインタになります
- 多くのコンパイラは警告を出しますが、コンパイルは通ります

**修正案**:
```cpp
// オプション1: 値を返す（推奨）
int returnValue() {
    int localVar = 42;
    return localVar; // 値のコピーまたはムーブ
}

// オプション2: 動的確保（必要な場合のみ）
std::unique_ptr<int> returnUniquePtr() {
    return std::make_unique<int>(42);
}

// オプション3: 参照パラメータで渡す
void fillValue(int& outValue) {
    outValue = 42;
}

// オプション4: 静的変数（状態を保持したい場合）
int& returnStaticReference() {
    static int staticVar = 42;
    return staticVar; // 静的変数なのでスコープを抜けても有効
}

// 使用例
int main() {
    // オプション1
    int val1 = returnValue();

    // オプション2
    auto ptr = returnUniquePtr();

    // オプション3
    int val3;
    fillValue(val3);

    // オプション4
    int& ref = returnStaticReference();
}
```

**説明**:
- C++では値のコピーは最適化されるため、通常は値を返すのが最適
- どうしてもポインタが必要な場合は`unique_ptr`を使用
- 参照パラメータで出力することも検討

---

#### 問題 3: ローカル変数への参照の返却 (重要度: 🔴 Critical)

**場所**: example.cpp:19-22 (getBadReference)

**問題のあるコード**:
```cpp
std::string& getBadReference() {
    std::string temp = "Hello";
    return temp; // ローカル変数への参照を返す
}
```

**問題点**:
- ローカル変数`temp`への参照を返しています
- 関数終了時に`temp`は破棄されるため、ダングリング参照になります

**修正案**:
```cpp
// オプション1: 値を返す（推奨）
std::string getValue() {
    std::string temp = "Hello";
    return temp; // RVO (Return Value Optimization) で効率的
}

// オプション2: 動的確保（通常は不要）
std::unique_ptr<std::string> getUniquePtr() {
    return std::make_unique<std::string>("Hello");
}

// オプション3: 静的または長寿命オブジェクトへの参照
const std::string& getConstReference() {
    static const std::string staticStr = "Hello";
    return staticStr;
}

// オプション4: 参照パラメータで渡す
void fillString(std::string& outStr) {
    outStr = "Hello";
}

// 使用例
int main() {
    // オプション1: 最も一般的
    std::string str1 = getValue();

    // オプション2
    auto ptr = getUniquePtr();

    // オプション3: 文字列リテラルや定数の場合
    const std::string& ref = getConstReference();

    // オプション4
    std::string str4;
    fillString(str4);
}
```

**説明**:
- `std::string`のような値型は、値を返すのが最も自然で効率的
- コンパイラのRVO/NRVOにより、コピーは最適化されます
- C++11以降はムーブセマンティクスにより、さらに効率的

---

#### 問題 4: コンテナ再配置によるダングリングポインタ (重要度: 🔴 Critical)

**場所**: example.cpp:25-33 (vectorReallocDangling)

**問題のあるコード**:
```cpp
void vectorReallocDangling() {
    std::vector<int> vec = {1, 2, 3};
    int* ptr = &vec[0];

    vec.push_back(4); // 容量拡張で再配置の可能性
    vec.push_back(5);
    vec.push_back(6);

    std::cout << *ptr << std::endl; // ptrは無効になっている可能性
}
```

**問題点**:
- `std::vector`は容量が足りなくなると、より大きな領域を確保して要素をコピー/ムーブします
- この時、既存の要素へのポインタやイテレータは無効になります
- `push_back`後に古いポインタを使用すると未定義動作

**修正案**:
```cpp
// オプション1: インデックスを使用（推奨）
void safeVectorAccess() {
    std::vector<int> vec = {1, 2, 3};
    size_t index = 0; // ポインタではなくインデックス

    vec.push_back(4);
    vec.push_back(5);
    vec.push_back(6);

    std::cout << vec[index] << std::endl; // 安全
}

// オプション2: 事前に容量を確保
void reserveCapacity() {
    std::vector<int> vec = {1, 2, 3};
    vec.reserve(10); // 事前に容量確保

    int* ptr = &vec[0];
    vec.push_back(4); // 容量内なので再配置なし
    vec.push_back(5);
    vec.push_back(6);

    std::cout << *ptr << std::endl; // 安全（容量内の場合）
}

// オプション3: イテレータを再取得
void reacquireIterator() {
    std::vector<int> vec = {1, 2, 3};

    vec.push_back(4);
    vec.push_back(5);
    vec.push_back(6);

    // 操作後にイテレータを取得
    auto it = vec.begin();
    std::cout << *it << std::endl; // 安全
}

// オプション4: std::arrayを使用（サイズ固定の場合）
void useArray() {
    std::array<int, 6> arr = {1, 2, 3, 0, 0, 0};
    int* ptr = &arr[0];

    arr[3] = 4; // 再配置なし
    arr[4] = 5;
    arr[5] = 6;

    std::cout << *ptr << std::endl; // 常に安全
}
```

**説明**:
- インデックスを使用すると、再配置があっても常に有効
- `reserve()`で事前に容量を確保すれば、その範囲内では再配置なし
- サイズが固定ならば`std::array`を使用

---

#### 問題 5: イテレータの無効化 (重要度: 🔴 Critical)

**場所**: example.cpp:36-42 (iteratorInvalidation)

**問題のあるコード**:
```cpp
void iteratorInvalidation() {
    std::vector<int> vec = {1, 2, 3, 4, 5};
    auto it = vec.begin();

    vec.erase(vec.begin() + 2); // イテレータが無効化
    std::cout << *it << std::endl; // 未定義動作の可能性
}
```

**問題点**:
- `std::vector::erase()`は、削除位置以降のすべてのイテレータを無効化します
- 場合によっては全イテレータが無効化されることも
- 無効化されたイテレータの使用は未定義動作

**修正案**:
```cpp
// オプション1: erase の戻り値を使用
void safeErase() {
    std::vector<int> vec = {1, 2, 3, 4, 5};
    auto it = vec.begin();

    it = vec.erase(vec.begin() + 2); // eraseは次の有効なイテレータを返す
    if (it != vec.end()) {
        std::cout << *it << std::endl; // 安全
    }
}

// オプション2: イテレータを再取得
void reacquireAfterErase() {
    std::vector<int> vec = {1, 2, 3, 4, 5};

    vec.erase(vec.begin() + 2);

    // 操作後に新しいイテレータを取得
    auto it = vec.begin();
    std::cout << *it << std::endl; // 安全
}

// オプション3: インデックスベースの操作
void indexBasedErase() {
    std::vector<int> vec = {1, 2, 3, 4, 5};
    size_t index = 0;

    vec.erase(vec.begin() + 2);

    if (index < vec.size()) {
        std::cout << vec[index] << std::endl; // 安全
    }
}

// オプション4: 範囲for使用時の注意
void safeRangeFor() {
    std::vector<int> vec = {1, 2, 3, 4, 5};

    // 削除しながらイテレート（正しい方法）
    for (auto it = vec.begin(); it != vec.end(); ) {
        if (*it == 3) {
            it = vec.erase(it); // eraseの戻り値を使用
        } else {
            ++it;
        }
    }
}
```

**説明**:
- `erase()`は次の有効なイテレータを返すので、それを使用
- イテレータ無効化のルールはコンテナごとに異なる
  - `std::vector`: erase位置以降が無効化
  - `std::list`: 削除した要素のイテレータのみ無効化
  - `std::map`: 削除した要素のイテレータのみ無効化

---

### ✅ 改善提案

1. **ポインタよりインデックス**
   - コンテナ要素へのアクセスは、可能な限りインデックスを使用
   - 再配置があってもインデックスは有効

2. **スマートポインタの使用**
   - 生ポインタを避け、`unique_ptr`や`shared_ptr`を使用
   - `reset()`後は確実に`nullptr`

3. **値の返却を優先**
   - ポインタや参照ではなく、値を返す
   - RVO/NRVOにより効率的

4. **コンテナ操作の戻り値を使用**
   - `erase()`などの戻り値を活用
   - イテレータ無効化を意識

5. **事前の容量確保**
   - `reserve()`で事前に容量を確保
   - 再配置を避ける

### 📚 参考情報

- [C++ Core Guidelines: ES.65 - Don't dereference an invalid pointer](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Res-deref)
- [C++ Core Guidelines: F.42 - Return a T* to indicate a position (only)](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Rf-return-ptr)
- [C++ Reference: Iterator invalidation rules](https://en.cppreference.com/w/cpp/container#Iterator_invalidation)
```

## 学習ポイント

このサンプルから学べること：
1. Use-After-Freeの検出と防止
2. スタック変数のアドレスを返す危険性
3. vectorの再配置によるポインタ/イテレータ無効化
4. イテレータ無効化のルールと対処法
5. 値の返却がC++では効率的であること
