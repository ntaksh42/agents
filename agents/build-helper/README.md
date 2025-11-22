# Build System Helper

ビルドシステムの構築・最適化を支援するエージェント

## 概要

CMake、MSBuild、vcpkgなどのビルドツールを使った開発環境のセットアップと最適化を支援します。

## 主な機能

- **CMake 設定生成**: CMakeLists.txt の作成・最適化
- **MSBuild プロジェクト管理**: .csproj, .vcxproj の設定
- **vcpkg パッケージ管理**: 依存関係の解決とインストール
- **クロスプラットフォームビルド**: Windows/Linux/macOS 対応
- **ビルドトラブルシューティング**: エラー解析と解決策提案
- **ビルド最適化**: コンパイル時間短縮、並列ビルド設定

## 対象となる問題

### CMake プロジェクトのセットアップ
```cmake
cmake_minimum_required(VERSION 3.15)
project(MyApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(MyApp
    src/main.cpp
    src/utils.cpp
)

target_include_directories(MyApp PRIVATE include)
```

### vcpkg の統合
```cmake
# vcpkg ツールチェーンファイルの使用
# cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=[vcpkg root]/scripts/buildsystems/vcpkg.cmake

find_package(fmt CONFIG REQUIRED)
target_link_libraries(MyApp PRIVATE fmt::fmt)
```

### MSBuild 最適化
```xml
<PropertyGroup>
  <Configuration>Release</Configuration>
  <Platform>x64</Platform>
  <PlatformToolset>v143</PlatformToolset>
  <MultiProcessorCompilation>true</MultiProcessorCompilation>
</PropertyGroup>
```

## 使用方法

🚧 開発予定

## 技術スタック

- CMake 3.15+
- MSBuild
- vcpkg
- NuGet
- Makefile / Ninja

## サポートするシナリオ

- 新規プロジェクトのセットアップ
- 既存プロジェクトのモダナイゼーション
- CI/CD パイプライン構築支援
- マルチプラットフォームビルド構成
