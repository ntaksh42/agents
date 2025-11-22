# Memory Safety Analyzer - Test Cases

このファイルは、Memory Safety Analyzerエージェントの動作を検証するためのテストケースを定義します。

## テストケースの構造

各テストケースは以下の情報を含みます：
- **テストID**: 一意の識別子
- **カテゴリ**: メモリリーク、ダングリングポインタ、バッファオーバーフローなど
- **重要度**: Critical, Warning, Suggestion
- **入力**: テスト対象のC++コード
- **期待される検出**: 何を検出すべきか
- **期待される修正案**: どのような修正を提案すべきか

---

## TC-001: 基本的なメモリリーク

**カテゴリ**: メモリリーク
**重要度**: Critical

**入力**:
```cpp
void leak() {
    int* ptr = new int(42);
}
```

**期待される検出**:
- `delete`が呼ばれていないメモリリーク

**期待される修正案**:
- スタック変数を使用
- または`std::unique_ptr`を使用

---

## TC-002: Rule of Three違反

**カテゴリ**: メモリリーク
**重要度**: Critical

**入力**:
```cpp
class MyClass {
    int* data;
public:
    MyClass(int size) : data(new int[size]) {}
    // デストラクタなし
};
```

**期待される検出**:
- デストラクタ未定義によるメモリリーク
- Rule of Three/Five違反

**期待される修正案**:
- デストラクタ、コピーコンストラクタ、コピー代入演算子を実装
- または`std::vector`を使用

---

## TC-003: Use-After-Free

**カテゴリ**: ダングリングポインタ
**重要度**: Critical

**入力**:
```cpp
void useAfterFree() {
    int* ptr = new int(42);
    delete ptr;
    *ptr = 100;
}
```

**期待される検出**:
- `delete`後のポインタアクセス
- Use-After-Free

**期待される修正案**:
- `unique_ptr`を使用し、`reset()`後はnullチェック
- または削除後の使用を完全に排除

---

## TC-004: スタック変数のアドレス返却

**カテゴリ**: ダングリングポインタ
**重要度**: Critical

**入力**:
```cpp
int* getBadPointer() {
    int local = 42;
    return &local;
}
```

**期待される検出**:
- ローカル変数のアドレス返却
- 関数終了後に無効になるポインタ

**期待される修正案**:
- 値を返す
- または`unique_ptr`を返す
- または静的変数を使用

---

## TC-005: 配列境界外アクセス

**カテゴリ**: バッファオーバーフロー
**重要度**: Critical

**入力**:
```cpp
void overflow() {
    int arr[10];
    arr[10] = 5;
}
```

**期待される検出**:
- 配列インデックスが範囲外
- バッファオーバーフロー

**期待される修正案**:
- インデックスを修正（0-9が正しい）
- `std::array`と`at()`を使用

---

## TC-006: strcpyによるバッファオーバーフロー

**カテゴリ**: バッファオーバーフロー
**重要度**: Critical

**入力**:
```cpp
void stringOverflow() {
    char buf[5];
    strcpy(buf, "Hello World");
}
```

**期待される検出**:
- バッファサイズを超える文字列コピー
- `strcpy`の危険な使用

**期待される修正案**:
- `std::string`を使用
- または`strncpy`/`snprintf`を使用

---

## TC-007: vectorの再配置によるダングリングポインタ

**カテゴリ**: ダングリングポインタ
**重要度**: Critical

**入力**:
```cpp
void vectorDangling() {
    std::vector<int> vec = {1, 2, 3};
    int* ptr = &vec[0];
    vec.push_back(4);
    *ptr = 100;
}
```

**期待される検出**:
- `push_back`による再配置でポインタ無効化
- 無効化されたポインタの使用

**期待される修正案**:
- インデックスを使用
- `reserve()`で事前に容量確保
- `push_back`後にポインタを再取得

---

## TC-008: 二重delete

**カテゴリ**: メモリ管理エラー
**重要度**: Critical

**入力**:
```cpp
void doubleFree() {
    int* ptr = new int(42);
    delete ptr;
    delete ptr;
}
```

**期待される検出**:
- 同じポインタを2回delete
- 二重解放

**期待される修正案**:
- 1回目のdelete後に`ptr = nullptr`
- `unique_ptr`を使用（自動的に防がれる）

---

## TC-009: 配列とスカラーのdelete不一致

**カテゴリ**: メモリ管理エラー
**重要度**: Critical

**入力**:
```cpp
void mismatchedDelete() {
    int* arr = new int[10];
    delete arr; // delete[] が正しい
}
```

**期待される検出**:
- `new[]`と`delete`の不一致
- 未定義動作

**期待される修正案**:
- `delete[]`を使用
- または`std::vector`/`std::array`を使用

---

## TC-010: 例外安全性違反

**カテゴリ**: メモリリーク
**重要度**: Critical

**入力**:
```cpp
void exceptionUnsafe() {
    int* ptr = new int(42);
    mayThrow(); // 例外発生の可能性
    delete ptr;
}
```

**期待される検出**:
- 例外発生時のリソースリーク
- RAII違反

**期待される修正案**:
- `unique_ptr`を使用
- try-catchで保護
- RAIIでリソース管理

---

## TC-011: シャローコピーによる二重削除

**カテゴリ**: メモリ管理エラー
**重要度**: Critical

**入力**:
```cpp
class Shallow {
    int* data;
public:
    Shallow(int val) : data(new int(val)) {}
    ~Shallow() { delete data; }
    // コピーコンストラクタ未定義
};

void shallowCopy() {
    Shallow obj1(42);
    Shallow obj2 = obj1; // シャローコピー
} // 二重削除発生
```

**期待される検出**:
- コピーコンストラクタ未定義
- シャローコピーによる二重削除

**期待される修正案**:
- ディープコピーを実装
- コピーを禁止（`= delete`）
- `std::vector`を使用

---

## TC-012: ポインタ演算の境界外アクセス

**カテゴリ**: バッファオーバーフロー
**重要度**: Critical

**入力**:
```cpp
void pointerArithmetic() {
    int arr[5];
    int* ptr = arr;
    *(ptr + 10) = 42;
}
```

**期待される検出**:
- ポインタ演算による境界外アクセス
- 配列サイズ（5）を超えるオフセット（10）

**期待される修正案**:
- インデックスをチェック
- イテレータを使用
- `std::span`（C++20）を使用

---

## TC-013: mallocとdeleteの混在

**カテゴリ**: メモリ管理エラー
**重要度**: Critical

**入力**:
```cpp
void mixedAlloc() {
    int* ptr = (int*)malloc(sizeof(int) * 10);
    delete[] ptr; // free() が正しい
}
```

**期待される検出**:
- `malloc`と`delete`の混在
- 未定義動作

**期待される修正案**:
- `free()`を使用
- または`new`/`delete`に統一
- または`std::vector`を使用

---

## TC-014: 生ポインタの不適切な使用（Warning レベル）

**カテゴリ**: コーディングスタイル
**重要度**: Warning

**入力**:
```cpp
void rawPointer() {
    int* ptr = new int(42);
    process(ptr);
    delete ptr;
}
```

**期待される検出**:
- 生ポインタの使用（リークはしていないが非推奨）

**期待される修正案**:
- `unique_ptr`を使用
- スタック変数を使用

---

## TC-015: 正しいコード（検出なし）

**カテゴリ**: 正常系
**重要度**: N/A

**入力**:
```cpp
void safeCode() {
    std::vector<int> vec(100);
    vec[50] = 42;

    std::unique_ptr<int> ptr = std::make_unique<int>(42);

    std::string str = "Hello";
    str += " World";
}
```

**期待される検出**:
- 問題なし

**期待される修正案**:
- なし

---

## テスト実行方法

### 個別テスト
```bash
# TC-001をテスト
claude-code --agent agents/memory-safety << EOF
[TC-001のコードをペースト]
EOF
```

### バッチテスト
```bash
# すべてのテストケースを実行
for test in tests/*.cpp; do
    echo "Testing $test"
    claude-code --agent agents/memory-safety < "$test"
done
```

### 期待結果の検証
各テストケースで：
1. 期待される問題が検出されるか
2. 重要度が正しいか
3. 修正案が適切か
4. 説明が明確か

## テストカバレッジ

- ✅ メモリリーク: TC-001, TC-002, TC-010
- ✅ ダングリングポインタ: TC-003, TC-004, TC-007
- ✅ バッファオーバーフロー: TC-005, TC-006, TC-012
- ✅ 二重削除: TC-008, TC-011
- ✅ new/delete不一致: TC-009, TC-013
- ✅ 正常系: TC-015

## 将来の拡張

追加予定のテストケース：
- スレッド安全性の問題
- カスタムアロケータの使用
- placement new
- メモリアライメント
- SIMD関連のメモリ問題
