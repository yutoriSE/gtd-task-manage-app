# Hive Type ID Registry

このファイルは、Hiveで使用されているすべてのtypeIdを管理します。
**重要:** 同じtypeIdを複数のクラスに割り当てないでください。データ破損の原因になります。

## 使用中のType IDs

| Type ID | クラス/Enum | ファイル | 説明 |
|---------|------------|---------|------|
| 0 | Task | lib/models/task.dart | タスクモデル |
| 1 | Project | lib/models/project.dart | プロジェクトモデル |
| 2 | GTDContext | lib/models/context.dart | GTDコンテキストモデル |
| 3 | TaskStatus | lib/models/task.dart | タスクステータスenum |
| 4 | Priority | lib/models/task.dart | 優先度enum |
| 5 | ProjectStatus | lib/models/project.dart | プロジェクトステータスenum |
| 6 | ChecklistItem | lib/models/task.dart | チェックリスト項目モデル |

## 利用可能なType IDs

次のIDは使用可能です: 7, 8, 9, 10, ...

## 新しいモデルの追加方法

1. 上記のテーブルで次に利用可能なType IDを確認
2. 新しいモデルに割り当て
3. このファイルを更新
4. build_runnerを実行: `flutter pub run build_runner build --delete-conflicting-outputs`

## 注意事項

- Type IDは0から223まで使用可能（Hiveの制限）
- 一度割り当てたType IDは変更しないこと（既存のデータベースに影響）
- 削除したモデルのType IDは将来のために予約しておくことを推奨
