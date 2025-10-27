# スクリーンショット撮影ガイド

このディレクトリには、アプリのスクリーンショットを保存します。

## 📸 撮影方法

### Web版で撮影（推奨）

Web版はFlutterが不要で、最も簡単にスクリーンショットを取得できます。

#### 1. Flutter Web版を起動

```bash
# プロジェクトルートで実行
flutter run -d chrome
```

#### 2. Chrome DevToolsでモバイル表示に切り替え

1. F12を押して開発者ツールを開く
2. Ctrl+Shift+M（Mac: Cmd+Shift+M）でデバイスツールバーを有効化
3. デバイスを選択（例: iPhone 14 Pro、Pixel 7）
4. 画面サイズを調整

#### 3. スクリーンショットを撮影

**方法1: DevToolsの機能を使用**
- デバイスツールバーの右上にある「⋮」メニューをクリック
- 「Capture screenshot」を選択
- 自動的にダウンロードされる

**方法2: Windowsスクリーンショット**
- Windows: Win+Shift+S
- Mac: Cmd+Shift+4

**方法3: Chrome拡張機能**
- Awesome Screenshot、Full Page Screen Captureなどを使用

### モバイルシミュレータで撮影

#### iOS Simulator（Mac）

```bash
# シミュレータで起動
flutter run -d "iPhone 14 Pro"

# スクリーンショット撮影
# Cmd+S
```

保存場所: デスクトップ

#### Android Emulator

```bash
# エミュレータで起動
flutter run -d emulator-5554

# スクリーンショット撮影
# エミュレータのサイドバーにあるカメラアイコンをクリック
```

保存場所: Android Studio内のLogcatウィンドウ

## 📋 撮影チェックリスト

以下の画面を撮影してください：

### 必須画面

- [ ] **inbox.png** - Inbox画面（タスクが2-3個ある状態）
- [ ] **inbox_empty.png** - Inbox画面（空の状態）
- [ ] **next_actions.png** - Next Actions画面（優先度の異なるタスク）
- [ ] **projects.png** - Projects画面（2-3個のプロジェクト）
- [ ] **waiting.png** - Waiting For画面
- [ ] **someday_maybe.png** - Someday/Maybe画面

### ダイアログ・詳細画面

- [ ] **quick_add_task.png** - クイック追加ダイアログ
- [ ] **task_detail.png** - タスク詳細ダイアログ
- [ ] **add_project.png** - プロジェクト追加ダイアログ
- [ ] **project_detail.png** - プロジェクト詳細画面

### 操作画面

- [ ] **swipe_actions.png** - タスクのスワイプ操作
- [ ] **move_dialog.png** - タスク移動ダイアログ
- [ ] **navigation.png** - ボトムナビゲーションバー

### オプション（推奨）

- [ ] **dark_mode.png** - ダークモード表示
- [ ] **landscape.png** - 横向き表示（タブレット）

## 🎨 撮影のコツ

### 1. サンプルデータを用意する

撮影前に、以下のようなサンプルデータを作成しておきます：

**Inboxのサンプル**:
- 「ミーティングの議事録を書く」（優先度: 高）
- 「スーパーで買い物をする」（優先度: 中）
- 「本を読む」（優先度: 低）

**Next Actionsのサンプル**:
- 「メールに返信する」（優先度: 緊急）
- 「プレゼン資料を作る」（優先度: 高）
- 「ジムに行く」（優先度: 低）

**Projectsのサンプル**:
- 「新しいウェブサイトを作る」（3タスク）
- 「来月の旅行を計画する」（2タスク）
- 「部屋の模様替え」（4タスク）

### 2. 画面サイズを統一

すべてのスクリーンショットで同じデバイスサイズを使用します。

推奨:
- **iPhone 14 Pro**: 393 x 852
- **Pixel 7**: 412 x 915

### 3. ステータスバーをクリーンに

時刻を「9:41」（Appleのデフォルト）に統一したい場合は、
画像編集ツールで後から修正してください。

### 4. 高解像度で撮影

Retina/高DPI表示で撮影すると、鮮明な画像が得られます。

## 📝 ファイル命名規則

すべてのスクリーンショットは以下の命名規則に従ってください：

- 小文字
- スペースの代わりにアンダースコア（_）を使用
- PNG形式
- 説明的な名前

**良い例**:
- `inbox_with_tasks.png`
- `next_actions_priority.png`
- `project_detail_screen.png`

**悪い例**:
- `Screen Shot 2025-10-27.png`
- `IMG_1234.png`
- `screenshot1.png`

## 🖼 画像の最適化

撮影後、画像サイズを最適化します：

### オンラインツール
- [TinyPNG](https://tinypng.com/) - PNGの圧縮
- [Squoosh](https://squoosh.app/) - 画像最適化

### コマンドライン
```bash
# ImageMagickを使用
convert input.png -resize 50% output.png

# pngquantを使用（品質維持しながら圧縮）
pngquant --quality=80-90 input.png -o output.png
```

## 📤 READMEへの追加方法

スクリーンショットを撮影したら、README.mdの該当セクションを更新します：

```markdown
## 📸 スクリーンショット

### Inbox画面
![Inbox](screenshots/inbox.png)

タスクを素早く記録し、一時保管できます。

### Next Actions画面
![Next Actions](screenshots/next_actions.png)

今すぐ実行できるタスクを優先度別に表示します。

### Projects画面
![Projects](screenshots/projects.png)

複数のタスクを含むプロジェクトを管理します。
```

## 🎬 デモGIF/動画の作成（オプション）

静止画だけでなく、アプリの操作を示す動画も作成できます。

### ツール

**Windows**:
- ScreenToGif（無料）
- LICEcap（無料）

**Mac**:
- Kap（無料）
- Gifox（有料）

**クロスプラットフォーム**:
- OBS Studio（無料）

### 録画する操作例

1. タスクをInboxに追加
2. タスクをスワイプしてNext Actionsに移動
3. チェックボックスでタスクを完了
4. プロジェクトを作成してタスクを追加

### GIFファイル名

- `demo_add_task.gif`
- `demo_swipe_move.gif`
- `demo_project_workflow.gif`

## 💡 ヒント

- **一貫性**: すべてのスクリーンショットで同じテーマ（ライト/ダーク）を使用
- **コンテキスト**: 空の画面よりも、データが入っている画面の方が機能を理解しやすい
- **バランス**: 画面に多すぎるデータを入れない（3-5個のアイテムが理想）
- **リアリティ**: 実際の使用シーンを想像してサンプルデータを作成

## 🚀 クイックスタート

時間がない場合は、最低限以下の3枚を撮影してください：

1. **inbox.png** - メイン画面（タスクあり）
2. **next_actions.png** - 優先度の視覚化
3. **projects.png** - プロジェクト管理機能

これだけでもアプリの主要機能を示すことができます。

---

質問や提案がある場合は、Issueを作成してください。
