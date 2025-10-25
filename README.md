# GTD Task Manager

GTD (Getting Things Done) メソッドに基づいたタスク管理アプリケーションです。Flutter で構築されており、モバイル（iOS/Android）とWebの両方で動作します。

## 機能

### GTD の主要機能
- **Inbox**: 思いついたことや受け取ったタスクを一時的に保管
- **Next Actions**: 今すぐ取りかかれる具体的な行動のリスト
- **Projects**: 複数のアクションが必要な成果を管理
- **Waiting For**: 他者の行動や出来事を待っているタスクを追跡
- **Someday/Maybe**: いつかやるかもしれないアイデアを保管

### アプリ機能
- タスクの作成、編集、削除
- タスクの優先度設定（低、中、高、緊急）
- タスクの期限設定
- プロジェクトの作成と管理
- タスクをプロジェクトに関連付け
- タスクのステータス間での移動
- ローカルストレージによるオフライン対応
- モバイルとWeb両対応

## 技術スタック

- **Flutter**: UIフレームワーク
- **Riverpod**: 状態管理
- **Hive**: ローカルデータベース
- **Material Design 3**: UIデザイン

## セットアップ

### 必要要件
- Flutter SDK 3.0.0 以上
- Dart 3.0.0 以上

### インストール

1. リポジトリをクローン
```bash
git clone <repository-url>
cd gtd-task-manage-app
```

2. 依存関係をインストール
```bash
flutter pub get
```

3. Hive アダプターを生成（必要な場合）
```bash
flutter pub run build_runner build
```

### 実行

#### モバイル（iOS/Android）
```bash
flutter run
```

#### Web
```bash
flutter run -d chrome
```

#### ビルド

##### Android APK
```bash
flutter build apk
```

##### iOS
```bash
flutter build ios
```

##### Web
```bash
flutter build web
```

## プロジェクト構造

```
lib/
├── models/          # データモデル
│   ├── task.dart
│   ├── project.dart
│   └── context.dart
├── providers/       # 状態管理
│   ├── task_provider.dart
│   ├── project_provider.dart
│   └── context_provider.dart
├── screens/         # 画面
│   ├── home_screen.dart
│   ├── inbox_screen.dart
│   ├── next_actions_screen.dart
│   ├── projects_screen.dart
│   ├── waiting_screen.dart
│   └── someday_maybe_screen.dart
├── widgets/         # 再利用可能なウィジェット
│   ├── task_list_item.dart
│   ├── quick_add_task.dart
│   ├── task_detail_dialog.dart
│   ├── project_list_item.dart
│   ├── add_project_dialog.dart
│   └── project_detail_screen.dart
├── services/        # サービス層
│   └── storage_service.dart
└── main.dart        # アプリのエントリーポイント
```

## GTD メソッドについて

GTD（Getting Things Done）は、デビッド・アレンによって開発された生産性向上メソッドです。
このアプリは、GTDの5つのステップをサポートします：

1. **収集（Capture）**: Inboxにすべてを記録
2. **明確化（Clarify）**: 各アイテムが何か、実行可能かを判断
3. **整理（Organize）**: 適切なリストに振り分け
4. **更新（Reflect）**: 定期的にリストを見直し
5. **実行（Engage）**: 状況に応じて次のアクションを選択

## ライセンス

MIT License

## 貢献

プルリクエストを歓迎します。大きな変更の場合は、まずissueを開いて変更内容について議論してください。
