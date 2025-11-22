# Unit Test Generator

単体テストコードを自動生成するエージェント

## 概要

C#およびC++のユニットテストコードを自動生成し、テストカバレッジ向上を支援します。

## 主な機能

- **C# テスト生成**: xUnit, NUnit, MSTest対応
- **C++ テスト生成**: Google Test, Catch2対応
- **モックオブジェクト作成**: 依存関係の分離
- **テストデータ生成**: 境界値分析、等価分割
- **アサーション提案**: 適切な検証コード
- **テストカバレッジ向上**: 未テストパスの特定

## 対象となる問題

### C# xUnit テスト
```csharp
// テスト対象クラス
public class Calculator
{
    public int Add(int a, int b) => a + b;
    public int Divide(int a, int b) => a / b;
}

// 自動生成されるテスト
public class CalculatorTests
{
    [Fact]
    public void Add_TwoPositiveNumbers_ReturnsSum()
    {
        // Arrange
        var calculator = new Calculator();

        // Act
        var result = calculator.Add(2, 3);

        // Assert
        Assert.Equal(5, result);
    }

    [Theory]
    [InlineData(10, 2, 5)]
    [InlineData(9, 3, 3)]
    [InlineData(-10, 2, -5)]
    public void Divide_ValidInputs_ReturnsQuotient(int a, int b, int expected)
    {
        var calculator = new Calculator();
        var result = calculator.Divide(a, b);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void Divide_ByZero_ThrowsException()
    {
        var calculator = new Calculator();
        Assert.Throws<DivideByZeroException>(() => calculator.Divide(10, 0));
    }
}
```

### C++ Google Test
```cpp
// テスト対象関数
int Add(int a, int b) {
    return a + b;
}

// 自動生成されるテスト
#include <gtest/gtest.h>

TEST(AddTest, TwoPositiveNumbers) {
    EXPECT_EQ(Add(2, 3), 5);
}

TEST(AddTest, PositiveAndNegative) {
    EXPECT_EQ(Add(5, -3), 2);
}

TEST(AddTest, ZeroValues) {
    EXPECT_EQ(Add(0, 0), 0);
}

TEST(AddTest, Overflow) {
    // INT_MAX + 1 の動作をテスト
    EXPECT_EQ(Add(INT_MAX, 1), INT_MIN); // オーバーフロー
}
```

### モックオブジェクト（C#）
```csharp
// インターフェース
public interface IDataRepository
{
    User GetUser(int id);
}

// テスト対象
public class UserService
{
    private readonly IDataRepository _repository;

    public UserService(IDataRepository repository)
    {
        _repository = repository;
    }

    public string GetUserName(int id)
    {
        var user = _repository.GetUser(id);
        return user?.Name ?? "Unknown";
    }
}

// モックを使用したテスト
public class UserServiceTests
{
    [Fact]
    public void GetUserName_UserExists_ReturnsName()
    {
        // Arrange
        var mockRepo = new Mock<IDataRepository>();
        mockRepo.Setup(r => r.GetUser(1))
                .Returns(new User { Id = 1, Name = "John" });

        var service = new UserService(mockRepo.Object);

        // Act
        var result = service.GetUserName(1);

        // Assert
        Assert.Equal("John", result);
    }
}
```

## 使用方法

🚧 開発予定

## 技術スタック

### C#
- xUnit
- NUnit
- MSTest
- Moq（モックライブラリ）
- FluentAssertions

### C++
- Google Test (gtest)
- Catch2
- Google Mock (gmock)

## サポートするテスト種別

- ユニットテスト
- パラメータ化テスト
- 例外テスト
- 非同期テスト（C#）
- テストフィクスチャ
