# トラブルシューティング

## ❌ よくあるエラーと解決方法

### 1. `Flutter failed to delete a directory at "build"`

**エラー内容:**
```
Flutter failed to delete a directory at "build". The flutter tool cannot access the file or directory.
```

**原因:**
- Chromeプロセスがbuildディレクトリのファイルをロック
- OneDriveの同期プロセスがファイルをロック
- 以前のflutter runプロセスが完全に終了していない

**解決方法A: 自動スクリプトを使用（推奨）**

プロジェクトルートで以下を実行：
```powershell
.\run_web.ps1
```

このスクリプトは自動的に：
1. Chromeプロセスを終了
2. buildディレクトリを削除
3. flutter cleanを実行
4. flutter run -d chromeを実行

**解決方法B: 手動で実行**

```powershell
# 1. Chromeを終了
Stop-Process -Name chrome -Force

# 2. buildディレクトリを削除
Remove-Item -Path "build" -Recurse -Force

# 3. Flutter cleanを実行
flutter clean

# 4. アプリを起動
flutter run -d chrome
```

**解決方法C: OneDriveの同期を除外（根本的解決）**

プロジェクトがOneDrive配下にある場合：

1. エクスプローラーでプロジェクトフォルダを右クリック
2. 「このデバイス上では常に保持する」を選択
3. または、プロジェクトをOneDrive外（例: `C:\dev\gtd-task-manage-app`）に移動

---

### 2. `PathAccessException: Deletion failed, path = '.dart_tool/build/generated'`

**エラー内容:**
```
PathAccessException: Deletion failed, path = '.dart_tool/build/generated' (OS Error: アクセスが拒否されました。, errno = 5)
```

**解決方法:**

```powershell
# すべてのIDEとエディタを終了してから
Remove-Item -Path ".dart_tool" -Recurse -Force
flutter clean
flutter pub get
dart run build_runner build
```

---

### 3. 白いページが表示される / アプリが起動しない

**確認手順:**

1. **F12**を押してChromeデベロッパーツールを開く
2. **Console**タブでエラーを確認
3. 以下のコマンドでFlutterのビルドログを確認：

```powershell
flutter run -d chrome --verbose
```

**よくあるエラー:**

- `HiveError: Box has already been registered` → アプリを再起動
- `MissingPluginException` → `flutter clean`してから再実行
- JavaScriptエラー → ブラウザのキャッシュをクリア（Ctrl+Shift+Delete）

---

### 4. `No issues found!` だが実行時エラーが出る

**原因:**
ランタイムエラーは静的解析では検出されません。

**解決方法:**

```powershell
# デバッグモードで実行
flutter run -d chrome --verbose

# エラーログを確認
# Chromeのデベロッパーツール（F12）でConsoleタブを開く
```

---

## 🔧 開発時のベストプラクティス

### アプリを再起動する前に

```powershell
# Ctrl+Cでflutter runを停止
# Chromeを完全に閉じる
# 以下を実行
flutter clean
flutter run -d chrome
```

### build_runnerを実行する前に

```powershell
# すべてのIDEを閉じる
Remove-Item -Path ".dart_tool" -Recurse -Force -ErrorAction SilentlyContinue
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### コード変更後

- ホットリロード: **r** キーを押す
- ホットリスタート: **R** キーを押す（大文字）
- 完全再起動: **Ctrl+C** → `flutter run -d chrome`

---

## 📞 それでも解決しない場合

1. **PCを再起動**する（最も確実な方法）
2. プロジェクトを**OneDrive外**に移動
3. **管理者権限**でPowerShellを実行
4. ウイルス対策ソフトの**リアルタイムスキャンを一時停止**

---

## 🚀 快適な開発のために

### プロジェクトの移動（推奨）

OneDrive配下から移動すると、ほとんどのロック問題が解消されます：

```powershell
# 新しい場所にプロジェクトをコピー
xcopy /E /I "C:\Users\ko092\OneDrive\Documents\dev\gtd-task-manage-app" "C:\dev\gtd-task-manage-app"

# 新しい場所で開発
cd C:\dev\gtd-task-manage-app
.\run_web.ps1
```
