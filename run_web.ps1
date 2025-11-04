# GTD Task Manager - Web実行スクリプト
# 毎回発生するbuildディレクトリロックエラーを自動解決

Write-Host "=== GTD Task Manager Web実行スクリプト ===" -ForegroundColor Cyan
Write-Host ""

# ステップ1: Chromeプロセスを終了
Write-Host "[1/4] Chromeプロセスを終了中..." -ForegroundColor Yellow
$chromeProcesses = Get-Process chrome -ErrorAction SilentlyContinue
if ($chromeProcesses) {
    Stop-Process -Name chrome -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Write-Host "  ✓ Chromeプロセスを終了しました" -ForegroundColor Green
} else {
    Write-Host "  ✓ Chromeプロセスは実行されていません" -ForegroundColor Green
}

# ステップ2: buildディレクトリを削除
Write-Host "[2/4] buildディレクトリを削除中..." -ForegroundColor Yellow
if (Test-Path "build") {
    try {
        Remove-Item -Path "build" -Recurse -Force -ErrorAction Stop
        Write-Host "  ✓ buildディレクトリを削除しました" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ buildディレクトリの削除に失敗しました。手動で削除してください" -ForegroundColor Red
        Write-Host "    エラー: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "  ✓ buildディレクトリは存在しません" -ForegroundColor Green
}

# ステップ3: Flutter clean
Write-Host "[3/4] Flutter cleanを実行中..." -ForegroundColor Yellow
flutter clean | Out-Null
Write-Host "  ✓ Flutter cleanが完了しました" -ForegroundColor Green

# ステップ4: Flutter run
Write-Host "[4/4] Flutter Webアプリを起動中..." -ForegroundColor Yellow
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "アプリを停止するには Ctrl+C を押してください" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

flutter run -d chrome
