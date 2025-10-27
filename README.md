# GTD Task Manager

GTD (Getting Things Done) メソッドに基づいたタスク管理アプリケーションです。Flutter で構築されており、モバイル（iOS/Android）とWebの両方で動作します。

## スクリーンショット

### 画面モックアップ（HTMLで確認可能）

実際のアプリ画面を確認するには、以下のHTMLモックアップをブラウザで開いてください：

**[画面モックアップ一覧を開く](screenshots/index.html)**

または、個別の画面を確認：
- [Inbox画面](screenshots/inbox.html)
- [Next Actions画面](screenshots/next_actions.html)
- [Projects画面](screenshots/projects.html)

> **スクリーンショット撮影方法**:
> 上記のHTMLファイルをブラウザで開き、開発者ツール（F12）でモバイルビューに切り替えてスクリーンショットを撮影できます。
> 詳細は [screenshots/README.md](screenshots/README.md) を参照してください。

---

### 主要画面

#### Inbox（受信箱）
タスクを素早く記録し、一時保管する画面。優先度の視覚的表示と直感的な操作が特徴です。

#### Next Actions（次のアクション）
今すぐ実行できるタスクを優先度別に表示。チェックボックスで完了マーク、タグやコンテキストで整理できます。

#### Projects（プロジェクト）
複数のタスクを含むプロジェクトを管理。進捗バーでプロジェクトの進捗状況を一目で確認できます。

## 主な機能

### GTD の5つの主要リスト

#### Inbox（受信箱）
思いついたことや受け取ったタスクを一時的に保管する場所です。

**機能**:
- クイック追加: 「+」ボタンで素早くタスクを記録
- タスクの詳細編集
- 他のリストへの移動（スワイプ操作）
- 優先度設定（低/中/高/緊急）

**使い方**:
1. 画面下部のInboxタブをタップ
2. 「+」ボタンで新規タスク追加
3. タスクを左にスワイプして「移動」を選択し、適切なリストに振り分け

---

#### Next Actions（次のアクション）
今すぐ取りかかれる具体的な行動のリストです。

**機能**:
- 実行可能なタスクのみを表示
- チェックボックスでタスクを完了
- 優先度の視覚的表示（色付きドット）
- タスクの並び替え

**使い方**:
1. Inboxから実行可能なタスクを移動
2. リストから状況に応じて次のアクションを選択
3. チェックボックスをタップして完了マーク

**GTDのポイント**:
- タスクは具体的で実行可能なアクションにする
- 「2分以内にできることはすぐやる」ルール適用

---

#### Projects（プロジェクト）
2つ以上のアクションが必要な成果を管理します。

**機能**:
- プロジェクトの作成と管理
- プロジェクトごとのタスク管理
- タスク数の表示
- プロジェクト完了・アーカイブ機能

**使い方**:
1. 「+」ボタンで新規プロジェクト作成
2. プロジェクトをタップして詳細画面へ
3. プロジェクト内で「+」ボタンを押してタスク追加
4. 各プロジェクトに最低1つの「Next Action」を設定

**例**:
- 「新しいウェブサイトを作る」（プロジェクト）
  - ドメインを取得する（Next Action）
  - デザイン案を3つ作る（Next Action）
  - コンテンツを執筆する（Next Action）

---

#### Waiting For（待機中）
他者の行動や特定の出来事を待っているタスクのリストです。

**機能**:
- 待機理由の記録
- 待機中タスクの一覧表示
- Next Actionsへの移動（条件が満たされた時）

**使い方**:
1. タスクを左にスワイプして「移動」→「Waiting For」を選択
2. 待機理由を入力（例: 「田中さんからの返信」）
3. 定期的に見直してフォローアップ

**例**:
- 「企画書を修正する」（待機理由: 上司からのフィードバック待ち）
- 「見積もりを送る」（待機理由: クライアントからの詳細情報待ち）

---

#### Someday/Maybe（いつか/多分）
今はやらないけれど、いつかやるかもしれないアイデアや目標のリストです。

**機能**:
- 将来のアイデアの保管
- プレッシャーなしでアイデアを温存
- 定期的な見直し

**使い方**:
1. Inboxから「今すぐやらない」と判断したタスクを移動
2. 週次レビュー時に見直し
3. 実行すべきと判断したらNext Actionsに移動

**例**:
- 「スペイン語を学ぶ」
- 「富士山に登る」
- 「ブログを始める」

## アプリの特徴

### タスク管理機能
- タスクの作成、編集、削除
- 優先度設定（低、中、高、緊急）with カラーインジケーター
- 期限設定（カレンダー選択）
- 詳細な説明の記入
- ステータス間での簡単な移動（スワイプ操作）
- チェックボックスで完了マーク

### プロジェクト管理機能
- プロジェクトの作成と管理
- タスクとプロジェクトの関連付け
- プロジェクトごとのタスク数表示
- プロジェクト完了・アーカイブ

### UI/UX
- モバイルファースト設計
- Web対応（レスポンシブデザイン）
- ダークモード対応
- Material Design 3準拠
- 直感的なスワイプ操作
- 高速なローカルストレージ（Hive）

### データ管理
- ローカルストレージによるオフライン対応
- データはデバイス内に安全に保存
- Hiveによる高速データアクセス

## 技術スタック

| カテゴリ | 技術 | 説明 |
|---------|------|------|
| フレームワーク | **Flutter** | クロスプラットフォームUIフレームワーク |
| 状態管理 | **Riverpod 2.4.0** | モダンでタイプセーフな状態管理 |
| データベース | **Hive 2.2.3** | 高速なNoSQLローカルデータベース |
| UI | **Material Design 3** | Googleの最新デザインシステム |
| ユーティリティ | **UUID** | ユニークIDの生成 |
| 日付処理 | **Intl** | 日付のフォーマット |
| UI拡張 | **Flutter Slidable** | スワイプ操作の実装 |

## セットアップ

### 必要要件
- Flutter SDK 3.0.0 以上
- Dart 3.0.0 以上
- （オプション）Android Studio / Xcode（モバイルアプリ開発用）
- （オプション）Chrome（Web開発用）

### インストール手順

1. **Flutter SDKのインストール**

   Flutter公式サイトからSDKをダウンロード:
   https://docs.flutter.dev/get-started/install

2. **リポジトリをクローン**
   ```bash
   git clone <repository-url>
   cd gtd-task-manage-app
   ```

3. **依存関係をインストール**
   ```bash
   flutter pub get
   ```

4. **動作確認**
   ```bash
   flutter doctor
   ```

### 実行方法

#### Web版（最も簡単）
```bash
flutter run -d chrome
```

#### iOS シミュレータ
```bash
flutter run -d "iPhone 14 Pro"
```

#### Android エミュレータ
```bash
flutter run -d emulator-5554
```

#### 実機（接続済みデバイス）
```bash
flutter devices  # デバイス一覧を確認
flutter run      # デバイスを選択して実行
```

### ビルド方法

#### Android APK（リリースビルド）
```bash
flutter build apk --release
```
APKファイルは `build/app/outputs/flutter-apk/app-release.apk` に生成されます。

#### iOS（リリースビルド）
```bash
flutter build ios --release
```

#### Web（本番用）
```bash
flutter build web --release
```
成果物は `build/web/` ディレクトリに生成されます。

## 使い方

### 基本的なワークフロー

#### 1. 収集（Capture）
```
タスクが思いついた → Inboxに追加
```

#### 2. 明確化（Clarify）
```
Inboxを開く → 各タスクを確認
↓
「これは何？」「実行可能？」を判断
```

#### 3. 整理（Organize）
```
実行可能 → Next Actions
2分以内 → すぐ実行して完了
他者待ち → Waiting For
将来やる → Someday/Maybe
複数ステップ → Projects
```

#### 4. 更新（Reflect）
```
週次レビュー:
- 各リストを見直し
- 完了したタスクを確認
- Someday/Maybeから実行すべきものを移動
```

#### 5. 実行（Engage）
```
Next Actionsから状況に応じてタスクを選択
↓
実行 → チェックマークで完了
```

### 操作例

#### タスクを追加する
1. Inbox画面で右下の「+」ボタンをタップ
2. タスク名を入力
3. （任意）説明、優先度を設定
4. 「追加」をタップ

#### タスクを別のリストに移動する
1. タスクを左にスワイプ
2. 「移動」ボタンをタップ
3. 移動先のリスト（Next Actions、Waiting Forなど）を選択

#### タスクを編集する
1. タスクをタップ
2. 詳細ダイアログで編集
3. 「保存」をタップ

#### タスクを完了にする
- チェックボックスをタップ

#### プロジェクトを作成する
1. Projects画面で「+」ボタンをタップ
2. プロジェクト名と説明を入力
3. 「作成」をタップ

#### プロジェクトにタスクを追加する
1. Projects画面でプロジェクトをタップ
2. プロジェクト詳細画面で「+」ボタンをタップ
3. タスク名を入力して「追加」

## スクリーンショットの撮り方

実際の画面キャプチャをREADMEに追加するには：

### 1. アプリを実行
```bash
flutter run -d chrome  # Web版
# または
flutter run            # モバイル
```

### 2. スクリーンショットを撮影

**Web版（Chrome）**:
- ブラウザの開発者ツール（F12）を開く
- デバイスツールバーを有効化（Ctrl+Shift+M / Cmd+Shift+M）
- iPhone/Androidビューに切り替え
- スクリーンショットアイコンをクリック

**モバイルシミュレータ/エミュレータ**:
- iOS: Cmd+S（Mac）
- Android: スクリーンショットボタン

### 3. 撮影推奨画面
- Inbox画面（タスクあり/なし）
- Next Actions画面（優先度表示）
- Projects画面
- タスク詳細ダイアログ
- クイック追加画面
- プロジェクト詳細画面

### 4. 画像をREADMEに追加
```markdown
## スクリーンショット

### Inbox画面
![Inbox](screenshots/inbox.png)

### Next Actions画面
![Next Actions](screenshots/next-actions.png)

### Projects画面
![Projects](screenshots/projects.png)
```

## プロジェクト構造

```
gtd-task-manage-app/
├── lib/
│   ├── main.dart                          # アプリのエントリーポイント
│   ├── models/                            # データモデル
│   │   ├── task.dart                      # タスクモデル
│   │   ├── task.g.dart                    # Hiveアダプター（自動生成）
│   │   ├── project.dart                   # プロジェクトモデル
│   │   ├── project.g.dart                 # Hiveアダプター（自動生成）
│   │   ├── context.dart                   # コンテキストモデル
│   │   └── context.g.dart                 # Hiveアダプター（自動生成）
│   ├── providers/                         # 状態管理（Riverpod）
│   │   ├── task_provider.dart             # タスク状態管理
│   │   ├── project_provider.dart          # プロジェクト状態管理
│   │   └── context_provider.dart          # コンテキスト状態管理
│   ├── screens/                           # 画面
│   │   ├── home_screen.dart               # ホーム画面（タブ切り替え）
│   │   ├── inbox_screen.dart              # Inbox画面
│   │   ├── next_actions_screen.dart       # Next Actions画面
│   │   ├── projects_screen.dart           # Projects画面
│   │   ├── waiting_screen.dart            # Waiting For画面
│   │   └── someday_maybe_screen.dart      # Someday/Maybe画面
│   ├── widgets/                           # 再利用可能なウィジェット
│   │   ├── task_list_item.dart            # タスクリストアイテム
│   │   ├── quick_add_task.dart            # クイック追加ダイアログ
│   │   ├── task_detail_dialog.dart        # タスク詳細ダイアログ
│   │   ├── project_list_item.dart         # プロジェクトリストアイテム
│   │   ├── add_project_dialog.dart        # プロジェクト追加ダイアログ
│   │   └── project_detail_screen.dart     # プロジェクト詳細画面
│   └── services/                          # サービス層
│       └── storage_service.dart           # ローカルストレージサービス
├── web/                                   # Web用設定
│   ├── index.html                         # HTMLエントリーポイント
│   └── manifest.json                      # PWA設定
├── android/                               # Android用設定
├── ios/                                   # iOS用設定
├── pubspec.yaml                           # 依存関係定義
├── README.md                              # このファイル
├── SCREEN_DESIGN.md                       # 画面設計ドキュメント
└── .gitignore                             # Git除外設定
```

## GTD メソッドについて

GTD（Getting Things Done）は、デビッド・アレンによって開発された生産性向上メソッドです。

### GTDの5つのステップ

1. **収集（Capture）**
   - 気になることをすべて外部に記録する
   - 頭の中を空にする

2. **明確化（Clarify）**
   - 各アイテムが何か、実行可能かを判断する
   - 次のアクションを明確にする

3. **整理（Organize）**
   - 適切なリストに振り分ける
   - システムを信頼できる状態にする

4. **更新（Reflect）**
   - 定期的にリストを見直す
   - システムを最新に保つ

5. **実行（Engage）**
   - 状況、時間、エネルギーに応じて次のアクションを選択
   - 実行する

### このアプリがサポートするGTDの原則

- **2分ルール**: 2分以内にできることはすぐやる
- **Inboxゼロ**: 定期的にInboxを空にする
- **週次レビュー**: すべてのリストを見直す習慣
- **プロジェクトには次のアクション**: 各プロジェクトに最低1つのNext Actionを設定
- **コンテキスト**: @Home、@Work等の状況別タスク管理

## トラブルシューティング

### アプリが起動しない

```bash
# キャッシュをクリア
flutter clean

# 依存関係を再インストール
flutter pub get

# もう一度実行
flutter run
```

### Hiveエラーが出る

```bash
# 既存のHiveボックスを削除（データが失われます）
# アプリのデータディレクトリを確認して削除
```

### ビルドエラー

```bash
# Flutter SDKを最新に更新
flutter upgrade

# 依存関係を更新
flutter pub upgrade
```

## 参考資料

- [Flutter公式ドキュメント](https://docs.flutter.dev/)
- [Riverpod公式ドキュメント](https://riverpod.dev/)
- [Hive公式ドキュメント](https://docs.hivedb.dev/)
- [GTDメソッド書籍「Getting Things Done」by David Allen](https://gettingthingsdone.com/)
- [SCREEN_DESIGN.md](SCREEN_DESIGN.md) - 画面設計の詳細

## 貢献

プルリクエストを歓迎します！

### 貢献の流れ

1. このリポジトリをフォーク
2. 機能ブランチを作成（`git checkout -b feature/amazing-feature`）
3. 変更をコミット（`git commit -m 'Add some amazing feature'`）
4. ブランチにプッシュ（`git push origin feature/amazing-feature`）
5. プルリクエストを作成

### コーディング規約

- Dartの公式スタイルガイドに従う
- コメントは日本語でOK
- 新機能には適切なテストを追加

## ライセンス

MIT License

## お問い合わせ

質問や提案がある場合は、Issueを作成してください。

---

Made with Flutter
