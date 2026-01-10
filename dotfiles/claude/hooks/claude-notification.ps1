param(
    [string]$Title = "Claude Code",
    [string]$Message = "通知メッセージ"
)

# プロジェクト名を取得（CLAUDE_PROJECT_DIR環境変数から）
$ProjectDir = $env:CLAUDE_PROJECT_DIR
if ($ProjectDir -and $ProjectDir -ne "") {
    $ProjectName = Split-Path -Leaf $ProjectDir
    $Title = "Claude Code - $ProjectName"
} else {
    # フォールバック：現在のディレクトリ名を使用
    $ProjectName = Split-Path -Leaf (Get-Location)
    if ($ProjectName -and $ProjectName -ne "") {
        $Title = "Claude Code - $ProjectName"
    }
}

# Toast通知を表示
try {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $template = "<toast><visual><binding template=`"ToastText02`"><text id=`"1`">$Title</text><text id=`"2`">$Message</text></binding></visual></toast>"

    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)
    $toast = New-Object Windows.UI.Notifications.ToastNotification($xml)

    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code')
    $notifier.Show($toast)

    Write-Host "Toast notification sent successfully"

} catch {
    # Toast通知が失敗した場合はメッセージボックス
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show($Message, $Title)
    Write-Host "Fallback to MessageBox"
}
