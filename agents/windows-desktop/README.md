# Windows Desktop Expert

Windows デスクトップUI開発を支援するエージェント

## 概要

WPF、WinForms、Win32 APIを使用したWindowsデスクトップアプリケーション開発を支援します。

## 主な機能

- **WPF XAML コード生成**: UI定義とバインディング
- **MVVMパターン実装**: Model-View-ViewModel アーキテクチャ
- **WinForms デザイン支援**: フォームとコントロール設計
- **Win32 API 活用**: ネイティブWindows機能の利用
- **カスタムコントロール作成**: 再利用可能なUIコンポーネント
- **UI/UXベストプラクティス**: アクセシビリティ、レスポンシブデザイン

## 対象となる問題

### WPF MVVM パターン
```csharp
// ViewModel
public class MainViewModel : INotifyPropertyChanged
{
    private string _message;
    public string Message
    {
        get => _message;
        set
        {
            _message = value;
            OnPropertyChanged();
        }
    }

    public ICommand UpdateCommand { get; }

    public MainViewModel()
    {
        UpdateCommand = new RelayCommand(() => Message = "Updated!");
    }
}
```

```xml
<!-- XAML View -->
<Window x:Class="MyApp.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation">
    <StackPanel>
        <TextBlock Text="{Binding Message}" />
        <Button Command="{Binding UpdateCommand}" Content="Update" />
    </StackPanel>
</Window>
```

### Win32 API の活用
```csharp
[DllImport("user32.dll")]
static extern bool SetForegroundWindow(IntPtr hWnd);

[DllImport("user32.dll")]
static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
```

## 使用方法

🚧 開発予定

## 技術スタック

- WPF (.NET Core / .NET 5+)
- WinForms
- Win32 API
- XAML
- Material Design / Modern UI

## サポートするシナリオ

- エンタープライズデスクトップアプリ
- データ可視化ツール
- システムユーティリティ
- 業務アプリケーション
