# GitHubに作成すべきISSUE一覧

以下の内容をコピーして、GitHubのISSUE作成画面に貼り付けてください。
各ISSUEは優先度順に並んでいます。

---

## Issue 1: [Critical] firstWhere()のエラーハンドリング不足

**Labels:** `bug`, `critical`, `error-handling`

**Description:**
```
## 問題
task_provider.dart と project_provider.dart で firstWhere() を使用している箇所でエラーハンドリングがなく、タスクやプロジェクトが見つからない場合にアプリがクラッシュします。

## 影響範囲
- lib/providers/task_provider.dart: 43, 51, 58, 66, 73, 81行目
- lib/providers/project_provider.dart: 44, 52行目

## 現在のコード例
```dart
final task = state.firstWhere((t) => t.id == taskId);  // StateErrorでクラッシュ
```

## 推奨修正
```dart
final taskIndex = state.indexWhere((t) => t.id == taskId);
if (taskIndex == -1) return;
final task = state[taskIndex];
```

## 再現手順
1. タスクを削除
2. 削除されたタスクを参照する操作（編集、完了など）を実行
3. アプリがクラッシュ

## 優先度
🔴 Critical
```

---

## Issue 2: [Critical] ストレージ初期化失敗時のクラッシュ

**Labels:** `bug`, `critical`, `error-handling`, `storage`

**Description:**
```
## 問題
main.dart の StorageService.init() と initializeDefaultContexts() にエラーハンドリングがなく、ストレージ初期化に失敗した場合にアプリが起動できません。

## 影響範囲
- lib/main.dart: 10-11行目

## 現在のコード
```dart
await StorageService.init();
await StorageService.initializeDefaultContexts();
```

## 推奨修正
```dart
try {
  await StorageService.init();
  await StorageService.initializeDefaultContexts();
} catch (e) {
  debugPrint('Storage initialization failed: $e');
  // エラーダイアログを表示またはフォールバック処理
}
```

## 考えられる失敗原因
- ストレージアクセス権限の不足
- Hiveデータベースの破損
- ディスク容量不足

## 優先度
🔴 Critical
```

---

## Issue 3: [High] 入力バリデーションの強化

**Labels:** `enhancement`, `validation`, `ux`

**Description:**
```
## 問題
タスクとプロジェクトの作成・編集時の入力バリデーションが不十分です。

## 現在の問題点
1. 空白文字のみのタイトルが許可される
2. URLの形式チェックがない
3. 文字数制限がない

## 推奨修正
- タイトルのtrim()処理
- URL形式のバリデーション（http/https スキームチェック）
- 最大文字数の制限（タイトル200文字、説明1000文字など）
- ユーザーへのエラーフィードバック（SnackBar）

## 影響範囲
- lib/widgets/task_detail_dialog.dart
- lib/widgets/quick_add_task.dart
- lib/widgets/add_project_dialog.dart

## 優先度
🟠 High
```

---

## Issue 4: [High] ユーザーフィードバックの追加

**Labels:** `enhancement`, `ux`, `feedback`

**Description:**
```
## 問題
ユーザーが操作を実行しても、成功・失敗のフィードバックがありません。

## 必要な改善
1. 成功メッセージ（SnackBar）
   - タスク作成: "タスクを作成しました"
   - タスク完了: "タスクを完了しました"
   - タスク削除: "タスクを削除しました"

2. 確認ダイアログ
   - タスク削除前: "本当に削除しますか？"
   - プロジェクト削除前: "このプロジェクトと関連タスクを削除しますか？"

3. エラーメッセージ
   - ストレージエラー: "保存に失敗しました"
   - URLオープンエラー: "リンクを開けませんでした"

## 優先度
🟠 High
```

---

## Issue 5: [High] テストカバレッジの追加

**Labels:** `testing`, `quality`, `technical-debt`

**Description:**
```
## 問題
プロジェクトにテストが一切ありません。

## 必要なテスト
### Unit Tests
- Model Tests (Task, Project, Context)
- Provider Tests (TaskProvider, ProjectProvider)
- Storage Tests

### Widget Tests
- Dialog Tests (TaskDetailDialog, QuickAddTask)
- Screen Tests (DashboardScreen, KanbanBoardScreen)

## 優先度
🟠 High
```

---

## Issue 6: [Medium] 検索とフィルター機能の追加

**Labels:** `enhancement`, `feature`, `ux`

**Description:**
```
## 問題
タスクが多くなると、目的のタスクを見つけるのが困難です。

## 提案機能
1. 全画面検索（タスク名、説明で検索）
2. フィルター（優先度別、期限別、プロジェクト別、コンテキスト別）
3. ソート（作成日順、期限順、優先度順）

## UI提案
- AppBarに検索アイコンを追加
- タップで検索バーを展開
- フィルターチップで複数条件指定

## 優先度
🟡 Medium
```

---

## Issue 7: [Medium] アクセシビリティの改善

**Labels:** `a11y`, `enhancement`, `accessibility`

**Description:**
```
## 問題
スクリーンリーダーユーザーがアプリを使用しにくい状態です。

## 必要な改善
1. Semanticsラベルの追加
2. フォーカス順序の明示化
3. アナウンス機能の実装
4. コントラスト比の確認（WCAG AA基準）
5. タッチターゲットサイズの確保（最小48x48 dp）

## 優先度
🟡 Medium
```

---

## Issue 8: [Medium] コンテキスト機能の完全実装

**Labels:** `enhancement`, `feature`, `gtd`

**Description:**
```
## 問題
GTDContextモデルは存在しますが、実際には十分に活用されていません。

## 未実装機能
1. タスク作成時のコンテキスト選択UI
2. コンテキスト別タスク表示画面
3. コンテキストの編集・削除機能
4. タスク削除時のコンテキスト参照チェック
5. コンテキストアイコンの表示

## 優先度
🟡 Medium
```

---

## Issue 9: [Medium] データバックアップ・エクスポート機能

**Labels:** `enhancement`, `feature`, `data`

**Description:**
```
## 問題
ユーザーがデータをバックアップ・移行する手段がありません。

## 提案機能
1. JSONエクスポート（すべてのタスク、プロジェクト、コンテキスト）
2. JSONインポート（マージまたは上書き）
3. 自動バックアップ（定期的にローカルストレージに保存）
4. クラウド同期（将来：Firebase/Supabase連携）

## 優先度
🟡 Medium
```

---

## Issue 10: [Low] パフォーマンス最適化

**Labels:** `performance`, `optimization`, `technical-debt`

**Description:**
```
## 問題
タスクが500個以上になるとパフォーマンスが低下する可能性があります。

## 最適化項目
1. 仮想スクロール（ListView.builderの最適化）
2. メモ化（派生データのキャッシュ）
3. constコンストラクター（不変ウィジェットをconst化）
4. ページネーション（一度に表示するタスク数を制限）
5. インデックス作成（Hive boxにインデックスを追加）

## 優先度
⚪ Low
```

---

## Issue 11: [Low] 国際化対応

**Labels:** `enhancement`, `i18n`, `localization`

**Description:**
```
## 問題
日本語が多くの箇所にハードコードされており、英語や他の言語をサポートできません。

## 提案
1. flutter_localizations パッケージの導入
2. ARBファイルの作成（app_en.arb, app_ja.arb）
3. すべてのテキストを翻訳キーに置き換え

## 優先度
⚪ Low
```

---

## 作成手順

1. GitHubリポジトリ（https://github.com/yutoriSE/gtd-task-manage-app）にアクセス
2. 「Issues」タブをクリック
3. 「New issue」ボタンをクリック
4. 上記の各ISSUEの内容をコピーして貼り付け
5. 対応するラベルを追加
6. 「Submit new issue」をクリック

**推奨作成順序:** Issue 1 → Issue 2 → Issue 3 → ... （優先度順）
