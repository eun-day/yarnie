// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get auto => '自動';

  @override
  String get preferencesTitle => '設定';

  @override
  String get preferencesSubtitle => 'アプリの使用環境を設定します';

  @override
  String get language => '言語';

  @override
  String get lengthUnit => '長さの単位';

  @override
  String get dataManage => 'データ管理';

  @override
  String get sessionSetting => '作業中の設定';

  @override
  String get touchFeedback => 'タッチフィードバック';

  @override
  String get languageAutoCurrent => '自動 (現在: 日本語)';

  @override
  String get languageSub => '自動を選択すると、端末の言語設定に従います';

  @override
  String get lengthCm => 'センチメートル (cm)';

  @override
  String get lengthInch => 'インチ (inch)';

  @override
  String get lengthSub => '針のサイズ、長さの測定などに適用されます';

  @override
  String get autoBackup => '自動バックアップ';

  @override
  String get autoBackupSub => '毎日自動でデータをバックアップ';

  @override
  String get exportData => 'データを書き出す';

  @override
  String get exportDataSub => 'アプリのデータと画像をファイルとして保存';

  @override
  String get importData => 'データを取り込む';

  @override
  String get importDataSub => 'バックアップファイルから復元';

  @override
  String get screenAwake => 'スリープ防止';

  @override
  String get screenAwakeSub => '作業中に画面が消えないようにします';

  @override
  String get touchFeedbackSub => 'カウンターボタンを押した時にフィードバックを受け取れます';

  @override
  String get vibrate => '振動';

  @override
  String get sound => '音';

  @override
  String get both => '両方';

  @override
  String get none => 'なし';

  @override
  String get my => 'マイページ';

  @override
  String get mySubtitle => '言語、単位、バックアップ';

  @override
  String get settings => '設定';

  @override
  String get welcome => 'Yarnieへようこそ！';

  @override
  String get welcomeDesc => 'Yarnieは編み物プロジェクトを体系的に管理し、\n進行状況を簡単に記録できるようお手伝いします';

  @override
  String get tabsConfigTitle => '📱 3つのタブで構成されています';

  @override
  String get homeTab => 'ホームタブ';

  @override
  String get homeTabDesc => '進行中の作業を素早く確認し、続きから再開できます。活動記録やバッジもここで確認できます。';

  @override
  String get projectsTab => 'プロジェクトタブ';

  @override
  String get projectsTabDesc =>
      'すべてのプロジェクトを管理する場所です。ギャラリー表示やリスト表示に切り替えたり、並べ替えたりできます。';

  @override
  String get myTab => 'マイタブ';

  @override
  String get myTabDesc => 'タグ管理、ゴミ箱、設定などの付加機能を使用できます。';

  @override
  String get tagFiltering => 'タグフィルタリング';

  @override
  String get tagFilteringDesc =>
      'プロジェクトタブでタグを選択すると、そのタグが付いたプロジェクトのみが表示されます。複数のタグを選択することも可能です。';

  @override
  String get createProjectTitle => '🎯 プロジェクトを作る';

  @override
  String get createProjectDesc =>
      'プロジェクトは、一つの完成作品を意味します。例：「冬のスーター」、「ベビーブランケット」、「靴下」など。';

  @override
  String get createProjectGuide1 => 'プロジェクトタブで ';

  @override
  String get createProjectGuide2 => '+ 新規プロジェクト';

  @override
  String get createProjectGuide3 => ' ボタンを押します';

  @override
  String get createProjectGuide4 => 'プロジェクト名、針の情報、写真などを入力します';

  @override
  String get createProjectGuide5 => 'タグを追加して分類できます（任意）';

  @override
  String get splitPartTitle => '🧩 パーツに分ける';

  @override
  String get splitPartDesc => 'プロジェクトは複数のパーツに分けることができます。各パーツは独立して作業を進められます。';

  @override
  String get sweaterExample => '例：セータープロジェクト';

  @override
  String get frontPanel => '前身頃';

  @override
  String get backPanel => '後身頃';

  @override
  String get leftSleeve => '左袖';

  @override
  String get rightSleeve => '右袖';

  @override
  String get neckline => '襟ぐり';

  @override
  String get addPartMethod => 'パーツの追加方法';

  @override
  String get addPartMethodDesc => 'プロジェクト詳細画面の左上にある';

  @override
  String get newPart => '新規パーツ';

  @override
  String get addPartMethodSuffix => '\nボタンを押すと、新しいパーツを追加できます。';

  @override
  String get counterSystemTitle => '🔢 カウンターシステム';

  @override
  String get counterSystemDesc =>
      '各パーツはカウンターで進行状況を記録します。\n1つのメインカウンターと複数の補助カウンターを持てます。';

  @override
  String get mainCounterTitle => 'メインカウンター';

  @override
  String get mainCounterDesc => '段数を数える基本のカウンターです。タップすると1段ずつ増えます。';

  @override
  String get tip => '💡 ヒント:';

  @override
  String get mainCounterTip =>
      ' 目標段数を設定すると、進捗率を確認できます。例えば100段を目標に設定すると、現在何％まで進んだかがわかります。';

  @override
  String get buddyCounterTitle => '補助カウンター';

  @override
  String get buddyCounterDesc =>
      'メインカウンターと一緒に使用する補助カウンターです。ステッチカウンターとセクションカウンターがあります。';

  @override
  String get stitchCounterTitle => 'ステッチカウンター';

  @override
  String get stitchCounterDesc => '1段の中での目数を数える独立したカウンターです。メインカウンターとは連動しません。';

  @override
  String get whenToUse => 'どんな時に使いますか？';

  @override
  String get stitchCounterUsage1 => '• 複雑なパターンで現在の目数を記録する時';

  @override
  String get stitchCounterUsage2 => '• 増し目や減らし目の作業で正確な目数を確認する時';

  @override
  String get stitchCounterUsage3 => '• 模様編みの繰り返し区間を数える時';

  @override
  String get sectionCounterTitle => 'セクションカウンター';

  @override
  String get sectionCounterDesc =>
      'メインカウンターと連動して、特定の区間やパターンを記録するカウンターです。5つのタイプがあります。';

  @override
  String get mainCounterLink => '🔗 メインカウンター連動';

  @override
  String get mainCounterLinkDesc =>
      'リンクボタンをオンにすると、メインカウンターが増える時に自動で一緒に計算されます。セクションカウンターはメインカウンターと連動させることで機能します。';

  @override
  String get sectionCounterTypes => 'セクションカウンターの5つのタイプ';

  @override
  String get rangeCounter => '範囲カウンター (Range)';

  @override
  String get rangeCounterDesc => '特定の区間（開始段〜目標段）の作業を記録します。';

  @override
  String get rangeCounterUsage1 => '• 「20〜40段までメリヤス編み」のような区間作業';

  @override
  String get rangeCounterUsage2 => '• パターンが変わる特定の区間の表示';

  @override
  String get rangeCounterUsage3 => '• 複数の色を使用する区間の管理';

  @override
  String get rangeCounterExample => '「前身頃 20〜40段：縄編み模様」';

  @override
  String get repeatCounter => '繰り返しカウンター (Repeat)';

  @override
  String get repeatCounterDesc => '数段ごとの繰り返しの作業を記録します。';

  @override
  String get repeatCounterUsage1 => '• 「6段ごとに増し目」のような繰り返し作業';

  @override
  String get repeatCounterUsage2 => '• 「4段ごとの模様編みの繰り返し」の記録';

  @override
  String get repeatCounterUsage3 => '• 規則的な模様や技法を数える時';

  @override
  String get repeatCounterExample => '「6段ごとに両端で1目ずつ増やす（8回繰り返し）」';

  @override
  String get intervalCounter => 'インターバルカウンター (Interval)';

  @override
  String get intervalCounterDesc => '一定の間隔ごとに変化する作業を記録します。\n（例：色の変更）';

  @override
  String get intervalCounterUsage1 => '• 定期的に色を変える時';

  @override
  String get intervalCounterUsage2 => '• ボーダー柄を作る時';

  @override
  String get intervalCounterUsage3 => '• 糸の配列順序を記録する時';

  @override
  String get intervalCounterExample => '「4段ごとに色変更：青 → 白 → 赤の順で」';

  @override
  String get shapingCounter => '増減目カウンター (Shaping)';

  @override
  String get shapingCounterDesc => '増し目や減らし目の作業の進行状況を記録します。';

  @override
  String get shapingCounterUsage1 => '• 袖や身頃の増し目・減らし目作業';

  @override
  String get shapingCounterUsage2 => '• ラグラン袖の斜線の作成';

  @override
  String get shapingCounterUsage3 => '• 襟ぐりや肩の減らし目';

  @override
  String get shapingCounterExample => '「両端で6回増やす：68目 → 80目」';

  @override
  String get lengthCounter => '長さカウンター (Length)';

  @override
  String get lengthCounterDesc => '目標の長さまで必要な段数を記録します。';

  @override
  String get lengthCounterUsage1 => '• 「30cmまで編む」のような長さベースの作業';

  @override
  String get lengthCounterUsage2 => '• マフラーやブランケットの希望の長さへの到達';

  @override
  String get lengthCounterUsage3 => '• 袖丈や着丈の記録';

  @override
  String get lengthCounterExample => '「メリヤス編みで40cmまで編む」';

  @override
  String get sectionCounterLinkTitle => '🔗 セクションカウンター連動機能';

  @override
  String get sectionCounterLinkDesc =>
      'セクションカウンターはメインカウンターと連動できます。連動するとメインカウンターが増える時に自動で計算されます。';

  @override
  String get tipLinkButton => '💡 ヒント: リンクボタン ';

  @override
  String get tipLinkButtonDesc => ' を押して連動のオン・オフを切り替えられます。緑色なら連動中です。';

  @override
  String get stitchCounterNote =>
      '注意：ステッチカウンターは1段の中で独立して動作するため、メインカウンターとは連動しません。';

  @override
  String get proTips => '✨ 活用ヒント';

  @override
  String get useMemo => '📝 メモを活用しましょう';

  @override
  String get useMemoDesc =>
      '各パーツごとにメモを残せます。「この区間で間違いやすい」、「次はもっとゆるく編む」などのメモを残すと役立ちます。';

  @override
  String get useTags => '🎨 タグで分類しましょう';

  @override
  String get useTagsDesc =>
      'プロジェクトにタグを追加して、簡単に見つけられるようにしましょう。「進行中」、「完成」、「ウェア」、「小物」などのタグを作ってみてください。';

  @override
  String get takePhotos => '📸 写真を残しましょう';

  @override
  String get takePhotosDesc => '完成作品や制作過程を写真に残すと、後で見返す楽しみが増えます。';

  @override
  String get readyToStart => '準備はできましたか？';

  @override
  String get startJourney =>
      'Yarnieと一緒に楽しい編み物の時間を始めましょう！\nわからないことがあれば、いつでも確認してください。';

  @override
  String get guideAgain =>
      'このガイドは、ホーム画面のユーザーガイドカード、またはマイページ > カスタマーサポートからいつでも見ることができます。';

  @override
  String get close => '閉じる';

  @override
  String get examplePrefix => '例：';

  @override
  String get knittingTip1 => '糸端は最低10cm残しておくと、糸始末が楽になります';

  @override
  String get knittingTip2 => '必ずゲージをとってください。プロジェクト成功の秘訣です！';

  @override
  String get knittingTip3 => '一目一目ゆっくりと、焦らず編みましょう';

  @override
  String get knittingTip4 => '色の組み合わせに迷ったら、自然界からインスピレーションを得てみてください';

  @override
  String get knittingTip5 => '編み手がきつすぎると手首を痛めることがあります。リラックスして！';

  @override
  String get knittingTip6 => 'Yarnieのセクションカウンターを使えば、複雑なパターンも簡単に記録できます';

  @override
  String get knittingTip7 => 'パターンを読む時は、一行ずつチェックしながら進めましょう';

  @override
  String get knittingTip8 => 'こまめに休憩をとりましょう。疲れると間違いが増えます';

  @override
  String get knittingTip9 => '針のサイズが合っているか確認してください。作品の仕上がりが変わります';

  @override
  String get knittingTip10 => '間違いを恐れないでください。解いて編み直すことも練習です';

  @override
  String get welcomeUser => 'ようこそ！ 🦎';

  @override
  String get helloUser => 'こんにちは！ 🦎';

  @override
  String get enjoyKnitting => '今日も楽しい編み物時間を';

  @override
  String get startKnitting => '編み物と一緒に楽しい時間を始めましょう';

  @override
  String get startFirstProject => '最初のプロジェクトを始めてみましょう！';

  @override
  String get startJourneyWithChameleon =>
      'カメレオンと一緒に編み物の旅を始めましょう\n一目一目が集まって、素敵な作品になります';

  @override
  String get createNewProject => '新規プロジェクト';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes分前';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours時間前';
  }

  @override
  String daysAgo(Object days) {
    return '$days日前';
  }

  @override
  String weeksAgo(Object weeks) {
    return '$weeks週間前';
  }

  @override
  String monthsAgo(Object months) {
    return '$monthsヶ月前';
  }

  @override
  String get recentProjects => '最近のプロジェクト';

  @override
  String get continueWorking => '続きから';

  @override
  String get firstTimeUsing => '初めてのご利用ですか？';

  @override
  String get yarnieBriefDesc => 'Yarnieはプロジェクトをパーツに分け、各パーツごとにカウンターで進行状況を記録します。';

  @override
  String get viewUserGuide => 'ユーザーガイドを見る';

  @override
  String get knittingTips => '編み物のヒント';

  @override
  String get knittingToday => '今日も編み物をしましょうか？';

  @override
  String get smallStart => '小さな一歩が大きな作品を作ります\n今すぐ最初の一目を編んでみましょう！';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notificationSettingsSub => 'リマインダー、バッジ通知';

  @override
  String get comingSoon => '今後のアップデートで提供予定の機能です。';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get on => 'オン';

  @override
  String get off => 'オフ';

  @override
  String get customerSupport => 'カスタマーサポート';

  @override
  String get trash => 'ゴミ箱';

  @override
  String get trashSub => '削除されたデータの管理';

  @override
  String get userGuide => 'ユーザーガイド';

  @override
  String get userGuideSub => 'Yarnieの使い方を学ぶ';

  @override
  String get appInfo => 'アプリ情報';

  @override
  String get appVersion => 'バージョン';

  @override
  String get korean => '韓国語';

  @override
  String get autoWithDeviceSetting => '自動 (端末の設定に従う)';

  @override
  String get chameleonStory => 'カメレオンの物語';

  @override
  String get chameleonStoryDesc =>
      '私たちのカメレオンの友達は色を変える能力がありません。しかし、編み物で様々な色や模様の服を作って着ることで、毎日新しい姿で幸せに暮らしています。皆さんもカメレオンのように、編み物と一緒に楽しい時間を過ごしてください！';

  @override
  String get sendFeedback => 'フィードバックを送る';

  @override
  String get privacyPolicy => '個人情報保護方針';

  @override
  String get termsOfService => '利用規約';

  @override
  String get openSourceLicense => 'オープンソースライセンス';

  @override
  String get projects => 'プロジェクト';

  @override
  String projectsCount(Object count) {
    return '$count個のプロジェクト';
  }

  @override
  String get all => 'すべて';

  @override
  String get bigCard => '大きいカード';

  @override
  String get smallCard => '小さいカード';

  @override
  String get list => 'リスト';

  @override
  String dateDisplay(Object day, Object month, Object year) {
    return '$year年$month月$day日';
  }

  @override
  String get noProjectsYet => 'まだプロジェクトがありません。\nプロジェクトを作ってみましょうか？';

  @override
  String get createProject => 'プロジェクトを作る';

  @override
  String get noMatchingProjects => '該当するプロジェクトがありません';

  @override
  String get filterResetDesc => '他のタグを選択するか、\nフィルタを初期化してみてください';

  @override
  String get resetFilter => 'フィルタを初期化';

  @override
  String get copyProject => 'プロジェクトをコピー';

  @override
  String get assignTags => 'タグを指定';

  @override
  String get unclassified => '未分類';

  @override
  String get sessionMemo => '作業メモ';

  @override
  String get enterMemo => 'メモを入力してください...';

  @override
  String saveSessionConfirm(Object time) {
    return '作業時間 $time を保存しますか？';
  }

  @override
  String trashProjectCount(Object count) {
    return '$count個のプロジェクト · 30日後に自動削除';
  }

  @override
  String get loading => '読み込み中...';

  @override
  String get errorLoadingData => 'データを読み込めませんでした';

  @override
  String get availableAfterRestore => '復元後に利用可能です。';

  @override
  String errorOccurred(Object error) {
    return 'エラーが発生しました: $error';
  }

  @override
  String get restore => '復元する';

  @override
  String get deleteForeverNow => '今すぐ完全に削除';

  @override
  String get restoreProject => 'プロジェクトを復元';

  @override
  String get restoreConfirm => 'このプロジェクトを復元しますか？';

  @override
  String get projectRestored => 'プロジェクトを復元しました。';

  @override
  String restoreFailed(Object error) {
    return '復元失敗: $error';
  }

  @override
  String get deleteForever => '完全に削除';

  @override
  String get deleteForeverConfirm => 'このプロジェクトを完全に削除しますか？\nこの操作は取り消せません。';

  @override
  String get delete => '削除';

  @override
  String get projectDeletedForever => 'プロジェクトを完全に削除しました。';

  @override
  String deleteFailed(Object error) {
    return '削除失敗: $error';
  }

  @override
  String get emptyTrash => 'ゴミ箱は空です';

  @override
  String get noDeletedProjects => '削除されたプロジェクトはありません';

  @override
  String partMemo(Object partName) {
    return '$partName - メモ';
  }

  @override
  String get partMemoDesc => 'パーツのメモを追加または編集します。';

  @override
  String get newMemoHint => '新しいメモを入力...';

  @override
  String get addMemo => 'メモを追加';

  @override
  String get noMemos => '登録されたメモはありません。';

  @override
  String get unpin => '固定解除';

  @override
  String get pin => '上部に固定';

  @override
  String get edit => '編集';

  @override
  String get editMemo => 'メモを編集';

  @override
  String get editMainCount => 'メインカウントを編集';

  @override
  String get editMainCountDesc => '現在のカウント値を直接修正または初期化できます';

  @override
  String get currentCount => '現在のカウント';

  @override
  String get resetToOne => '1に初期化';

  @override
  String get rangeCounterLabel => '範囲カウンター';

  @override
  String get editRangeCounter => '範囲カウンターを編集';

  @override
  String get addRangeCounter => '範囲カウンターを追加';

  @override
  String get rangeCounterDescSimple => '特定の段の範囲を記録するカウンターです。';

  @override
  String get startRow => '開始段';

  @override
  String get totalRows => '総段数';

  @override
  String get rowsHint => '例：50';

  @override
  String get rowsHelper => '開始段から何段分記録するか入力してください。';

  @override
  String get add => '追加';

  @override
  String get label => 'ラベル';

  @override
  String get labelHint => 'カウンターを識別しやすいラベルを入力してください';

  @override
  String get tagSelection => 'タグ選択';

  @override
  String get complete => '完了';

  @override
  String get searchTags => 'タグを検索...';

  @override
  String get addNewTag => '新しいタグを追加';

  @override
  String get tagName => 'タグ名';

  @override
  String get editTag => 'タグを編集';

  @override
  String get shapingCounterLabel => '増減目カウンター';

  @override
  String get editShapingCounter => '増減目カウンターを編集';

  @override
  String get addShapingCounter => '増減目カウンターを追加';

  @override
  String get shapingCounterDescSimple => '目を増やしたり減らしたりする作業を記録するカウンターです。';

  @override
  String get intervalRows => '間隔 (段)';

  @override
  String get intervalHint => '例：2';

  @override
  String get totalTimes => '総回数';

  @override
  String get timesHint => '例：10';

  @override
  String get stitchChange => '目数の変化 (1回あたり)';

  @override
  String get stitchChangeHint => '例：2 または -2';

  @override
  String get stitchChangeHelper => '正の数は増し目、負の数は減らし目です。';

  @override
  String get intervalCounterLabel => 'インターバルカウンター';

  @override
  String get editIntervalCounter => 'インターバルカウンターを編集';

  @override
  String get addIntervalCounter => 'インターバルカウンターを追加';

  @override
  String get intervalCounterDescSimple => '一定の間隔で作業を繰り返す時に使用するカウンターです。';

  @override
  String get intervalTimesHelper => '間隔と総回数を入力してください。';

  @override
  String get colorOption => '配色オプション';

  @override
  String get colorOptionDesc => '配色の記録が必要な場合、使用する色を順番に選択してください';

  @override
  String get editStitchCounter => 'ステッチカウンターを編集';

  @override
  String get editCounterInfo => 'カウンター情報を編集します。';

  @override
  String get currentValue => '現在の値';

  @override
  String get countUnit => '増減単位';

  @override
  String get repeatCounterLabel => '繰り返しカウンター';

  @override
  String get editRepeatCounter => '繰り返しカウンターを編集';

  @override
  String get addRepeatCounter => '繰り返しカウンターを追加';

  @override
  String get repeatCounterDescSimple => '特定のパターンを繰り返す時に使用するカウンターです。';

  @override
  String get repeatUnit => '繰り返し単位 (段)';

  @override
  String get repeatUnitHint => '例：4';

  @override
  String get repeatTimes => '繰り返し回数';

  @override
  String get repeatHelper => 'パターンの繰り返し単位と回数を入力してください。';

  @override
  String deleteConfirm(String name) {
    return 'プロジェクト「$name」を削除しますか？';
  }

  @override
  String get deleteDesc => 'プロジェクトはゴミ箱に移動され、\n30日後に自動的に永久削除されます。';

  @override
  String get achieved => '達成済み ✓';

  @override
  String get remainingLength => '残りの長さ';

  @override
  String get stitchIncrease => '増し目';

  @override
  String get stitchDecrease => '減らし目';

  @override
  String nextRow(Object row) {
    return '次:$row段';
  }

  @override
  String patternRows(Object current, Object total) {
    return '$current/$total段';
  }

  @override
  String fromRow(Object row) {
    return '$row段から';
  }

  @override
  String get stitch => '目';

  @override
  String increaseBy(Object n) {
    return '+$nずつ';
  }

  @override
  String get manualInput => '直接入力...';

  @override
  String get setIncreaseValue => '増加値の設定';

  @override
  String get setIncreaseValueDesc => '一度に増加させる目数を入力してください。';

  @override
  String get increaseValue => '増加値';

  @override
  String get increaseValueHint => '例：6';

  @override
  String get confirm => '確認';

  @override
  String get exitConfirm => 'もう一度押すと終了します。';

  @override
  String get exitAppTitle => 'アプリを終了しますか？';

  @override
  String get exitAppMessage => '終了する場合は下のボタンを押してください。';

  @override
  String get exit => '終了';

  @override
  String get home => 'ホーム';

  @override
  String get selectCounterType => 'カウンタータイプを選択';

  @override
  String get stitchCounter => 'ステッチカウンター';

  @override
  String get independentCounter => '独立した数字カウンター';

  @override
  String get sectionCounter => 'セクションカウンター';

  @override
  String get range => '範囲 (Range)';

  @override
  String get repeat => '繰り返し (Repeat)';

  @override
  String get interval => 'インターバル (Interval)';

  @override
  String get shaping => '増減目 (Shaping)';

  @override
  String get length => '長さ (Length)';

  @override
  String get addLengthCounter => '長さカウンターを追加';

  @override
  String get editLengthCounter => '長さカウンターを編集';

  @override
  String get lengthCounterDescSimple => '特定の長さに達するまで記録するカウンターです。';

  @override
  String get targetLength => '目標の長さ';

  @override
  String get lengthHint => '例：30.0';

  @override
  String get lengthHelper => '目標とする長さを入力してください。';

  @override
  String get unit => '単位';

  @override
  String get cm => 'cm';

  @override
  String get inch => 'inch';

  @override
  String get countBySetting => '増減単位設定';

  @override
  String get lengthMeasurement => '長さカウンター';

  @override
  String targetInfoLength(Object length) {
    return '目標 ${length}cm';
  }

  @override
  String targetInfoLengthInch(Object length) {
    return '目標 ${length}inch';
  }

  @override
  String get editLengthCounterTitle => '長さ測定カウンターを編集';

  @override
  String get addLengthCounterTitle => '長さ測定カウンターを追加';

  @override
  String get startStitch => '開始段';

  @override
  String get targetLengthCm => '目標の長さ (cm)';

  @override
  String get targetLengthInch => '目標の長さ (inch)';

  @override
  String get targetLengthHint => '例：25.0';

  @override
  String get rowHeightCm => '1段の高さ (cm)';

  @override
  String get rowHeightInch => '1段の高さ (inch)';

  @override
  String get rowHeightHint => '例：0.33';

  @override
  String get rowHeightDesc => '編み地（サンプル）から1段の高さを測定するか、保存されたゲージ情報から計算できます';

  @override
  String get gaugeInputComingSoon => 'ゲージ入力機能準備中';

  @override
  String get goToGaugeInput => 'ゲージを入力しに行く';

  @override
  String get expectedRows => '予想必要段数';

  @override
  String estimatedRowsDisplay(Object rows) {
    return '$rows段';
  }

  @override
  String get changeTargetRow => '目標段数を変更';

  @override
  String get removeTargetRow => '目標段数を解除';

  @override
  String editLogMemo(Object no) {
    return 'ログ $no メモ編集';
  }

  @override
  String get memoRemoved => 'メモを削除しました';

  @override
  String get memoSaved => 'メモを保存しました';

  @override
  String memoUpdateFailed(Object error) {
    return 'メモの更新に失敗しました: $error';
  }

  @override
  String get labelRemoved => 'ラベルを削除しました';

  @override
  String labelChanged(Object label) {
    return 'ラベルを「$label」に変更しました';
  }

  @override
  String labelUpdateFailed(Object error) {
    return 'ラベルの更新に失敗しました: $error';
  }

  @override
  String get more => 'もっと見る';

  @override
  String get fold => '閉じる';

  @override
  String get setTargetRow => '目標段数を設定';

  @override
  String get setTargetRowDesc => '完了したい総段数を入力してください';

  @override
  String get targetRow => '目標段数';

  @override
  String get setCountBy => '増減単位の設定';

  @override
  String get countByValue => '増減単位';

  @override
  String get manageParts => 'パーツ管理';

  @override
  String get managePartsDesc => 'パーツ名を長押しして編集したり、左のアイコンをドラッグして順序を変更したりできます。';

  @override
  String get noParts => '登録されたパーツはありません。';

  @override
  String get editName => '名前を編集';

  @override
  String get deletePart => 'パーツを削除';

  @override
  String deletePartConfirm(Object name) {
    return 'パーツ「$name」を削除しますか？\nこのパーツに属するすべてのカウンター、セッション記録、メモも削除されます。';
  }

  @override
  String get duplicatePartName => '既に存在するパーツ名です。';

  @override
  String get newPartName => '新しいパーツ名';

  @override
  String get rowHeightError => '1段の高さは目標の長さより小さくなければなりません。';

  @override
  String get projectInfo => 'プロジェクト情報';

  @override
  String get projectDelete => 'プロジェクトを削除';

  @override
  String get newPartTitle => '新規パーツ';

  @override
  String get addPartDesc => 'パーツを追加してください';

  @override
  String get newPartAdd => '新規パーツを追加';

  @override
  String get partNameHint => 'パーツ名 (例：前身頃、袖)';

  @override
  String get session => 'セッション';

  @override
  String rowsRemaining(Object count) {
    return '残り $count 段';
  }

  @override
  String get editProject => 'プロジェクトを編集';

  @override
  String get newProject => '新規プロジェクト';

  @override
  String get editProjectDesc => 'プロジェクト情報を編集してください';

  @override
  String get newProjectDesc => '新しいプロジェクト情報を入力してください';

  @override
  String get projectName => 'プロジェクト名';

  @override
  String get projectNameHint => 'プロジェクト名を入力してください';

  @override
  String get needleType => '針の種類';

  @override
  String get knittingNeedle => '棒針';

  @override
  String get crochetNeedle => 'かぎ針';

  @override
  String get needleTypeHint => '針の種類を選択してください';

  @override
  String get needleSize => '針のサイズ';

  @override
  String get needleSizeHint => 'まず針の種類を選択してください';

  @override
  String get lotNumberHint => '例：A12345';

  @override
  String get lotNumberDesc => '糸のロット番号を入力してください';

  @override
  String get memoHint => 'プロジェクトに関するメモを入力してください\n例：糸の種類、色、パターン情報など';

  @override
  String get tagAdd => 'タグを追加';

  @override
  String get gauge => 'ゲージ';

  @override
  String get gaugeDesc => '10cm x 10cmの中に何目、何段ありますか？';

  @override
  String get gaugeDescInch => '4in x 4inの中に何目、何段ありますか？';

  @override
  String get stitchesHint => '目数';

  @override
  String get stitchesUnit => '目';

  @override
  String get rowsHintGauge => '段数';

  @override
  String get rowsUnit => '段';

  @override
  String get editComplete => '編集完了';

  @override
  String get addComplete => '追加完了';

  @override
  String get addImage => '画像を追加';

  @override
  String get imageSourceDesc => '写真を撮影するか、ライブラリから選択してください。';

  @override
  String get cameraShot => 'カメラで撮影';

  @override
  String get gallerySelect => 'ライブラリから選択';

  @override
  String get projectImage => 'プロジェクト画像';

  @override
  String get reset => 'リセット';

  @override
  String get change => '変更';

  @override
  String get memo => 'メモ';

  @override
  String get tag => 'タグ';

  @override
  String get paused => '一時停止';

  @override
  String get start => '開始';

  @override
  String get projectInfoDesc => 'プロジェクトの詳細情報を確認します';

  @override
  String get lotNumberLabel => '糸のロット番号';

  @override
  String get noTagsAssigned => '指定されたタグはありません。';

  @override
  String get noGaugeInfo => 'ゲージ情報なし';

  @override
  String get noMemoInfo => 'メモなし';

  @override
  String get createdAtLabel => '作成日';

  @override
  String get updatedAtLabel => '最終更新日';

  @override
  String get gaugeStandard => '(10cm x 10cm 基準)';

  @override
  String get gaugeStandardInch => '(4in x 4in 基準)';

  @override
  String get noCounters => 'カウンターがありません。';

  @override
  String get addCounterGuide => '+ ボタンを押して追加してみてください。';

  @override
  String completeWithEmoji(Object name) {
    return '$name 完了！ 🎉';
  }

  @override
  String get viewDetails => '詳細を見る';

  @override
  String get editLabel => 'ラベルを編集';

  @override
  String get selectLabel => 'ラベルを選択';

  @override
  String get manageLabels => 'ラベル管理';

  @override
  String get addLabel => 'ラベルを追加';

  @override
  String get activeSessionExists => '進行中のセッションがあります';

  @override
  String get resume => '再開する';

  @override
  String get startNew => '新しく開始';

  @override
  String get activeSession => '進行中のセッション';

  @override
  String get activeSessionQuestion => '進行中のセッションがあります。再開しますか？';

  @override
  String get dbDuplicateError => '重複した値が存在します';

  @override
  String get dbForeignKeyError => '参照するレコードが存在しません';

  @override
  String get dbRequiredError => '必須項目が不足しています';

  @override
  String get dbIntegrityError => 'データの整合性違反';

  @override
  String get dbConstraintError => 'データの制約違反';

  @override
  String get dbGeneralError => 'データベースエラーが発生しました';

  @override
  String get dbRecordNotFoundError => '記録が見つかりませんでした';

  @override
  String get defaultLabelSleeves => '袖';

  @override
  String get defaultLabelBody => '身頃';

  @override
  String get defaultLabelNeckline => '襟ぐり';

  @override
  String get userGuideJourney => 'Yarnieと楽しむ編み物の旅';

  @override
  String get trashHeader => 'ゴミ箱';

  @override
  String trashProjectCountInfo(Object count) {
    return '$count個のプロジェクト · 30日後に自動削除';
  }

  @override
  String trashStashCountInfo(Object count) {
    return '$count個の毛糸 · 30日後に自動削除';
  }

  @override
  String get restoreProjectTitle => 'プロジェクトを復元';

  @override
  String get restoreConfirmMessage => 'このプロジェクトを復元しますか？';

  @override
  String get projectRestoredMessage => 'プロジェクトを復元しました。';

  @override
  String get deleteForeverTitle => '完全に削除';

  @override
  String get deleteForeverConfirmMessage =>
      'このプロジェクトを完全に削除しますか？\nこの操作は取り消せません。';

  @override
  String get mainCounterTitleAlt => 'メインカウンター';

  @override
  String countByLabel(Object value) {
    return '増減単位: $value';
  }

  @override
  String get yarniePremium => 'Yarnieプレミアム';

  @override
  String get yarniePremiumSub => 'より多くの機能を無制限に';

  @override
  String get premiumTitle1 => '制限なく自由に、';

  @override
  String get premiumTitle2 => 'あなただけの編み物の世界を広げましょう！';

  @override
  String get premiumFeature1Title => '広告を完全に非表示';

  @override
  String get premiumFeature1Sub => '中断のない編み物時間';

  @override
  String get premiumFeature2Title => 'プロジェクト数無制限';

  @override
  String get premiumFeature2Sub => '好きなだけプロジェクトを作成できます';

  @override
  String get premiumFeature3Title => 'パーツ＆カウンター無制限';

  @override
  String get premiumFeature3Sub => '複雑なパターンも問題なく記録';

  @override
  String get premiumComingSoon => '今後のアップデートで追加される統計やウィジェット機能も追加料金なしで利用できます！';

  @override
  String get premiumPrice => '600円';

  @override
  String get premiumPriceDesc => '月額料金なし、買い切り';

  @override
  String get premiumOneTime => '一度のお支払い';

  @override
  String get premiumStartBtn => 'Yarnieプレミアムを始める';

  @override
  String get premiumBtnDesc => '購入後すぐにすべてのプレミアム機能を使用できます';

  @override
  String get premiumRestore => '購入情報の復元';

  @override
  String get premiumRefund => '返金リクエスト';

  @override
  String get premiumRefundAndroidTitle => '返金について';

  @override
  String get premiumRefundAndroidMessage =>
      'Google Playのポリシーにより、ストアの購入履歴から直接返金を申請する必要があります。';

  @override
  String get premiumRefundAndroidGo => '移動する';

  @override
  String get premiumRefundSuccess => '返金リクエストが完了しました。';

  @override
  String get premiumRefundFailed => '返金リクエスト中にエラーが発生しました。しばらくしてからもう一度お試しください。';

  @override
  String get premiumRefundTryAgain => 'しばらくしてからもう一度お試しください';

  @override
  String get premiumTerms => '利用規約';

  @override
  String get premiumPrivacy => '個人情報保護方針';

  @override
  String get premiumFooterDescIOS =>
      'お支払いはApple IDアカウントに請求されます。機種変更やアプリの再インストールを行った場合は、「購入情報の復元」ボタンからプレミアム機能を復元できます。';

  @override
  String get premiumFooterDescAndroid =>
      'お支払いはGoogle Playアカウントに請求されます。機種変更やアプリの再インストールを行った場合は、「購入情報の復元」ボタンからプレミアム機能を復元できます。';

  @override
  String get premiumPurchaseCancelled => '決済がキャンセルされました。';

  @override
  String get premiumPurchaseFailed => '決済に失敗しました。もう一度お試しください。';

  @override
  String get premiumRestoreSuccess => '購入履歴が正常に復元されました。';

  @override
  String get premiumRestoreNoHistory => '復元する購入履歴が見つかりませんでした。';

  @override
  String get premiumNetworkError => 'ネットワークエラーが発生しました。接続状況を確認してください。';

  @override
  String get upsellSnackbarMessage => 'Yarnieプレミアムを購入すると、プロジェクトを無制限に作成できます！';

  @override
  String get upsellSnackbarAction => 'プレミアムを見る';

  @override
  String everyNRows(Object n) {
    return '$n段ごと';
  }

  @override
  String get row => '段';

  @override
  String repeatCountSuffix(int count, String checkmark) {
    return '/ $count回$checkmark';
  }

  @override
  String shapingDecrease(int n) {
    return '$n目減らす';
  }

  @override
  String shapingIncrease(int n) {
    return '$n目増やす';
  }

  @override
  String get shapingActionNow => '今すぐ実行！';

  @override
  String get shapingWorkEven => '増減なし';

  @override
  String shapingNextActionRow(int row) {
    return '次: $row段目';
  }

  @override
  String get shapingModePattern => 'パターン';

  @override
  String get shapingModeDirect => '直接入力';

  @override
  String get shapingRowsLabel => '増減を行う段';

  @override
  String get shapingRowsHint => '例：2, 5, 9, 11';

  @override
  String get shapingRowsHelper => '増減目を行う段をカンマで区切って入力してください';

  @override
  String shapingDirectSubInfo(Object current, Object total) {
    return '$current/$total回';
  }

  @override
  String get preview => 'プレビュー';

  @override
  String get tagSelectionDesc => 'タグを長押しして編集または削除できます。';

  @override
  String get tagSelectionSubtitle => 'プロジェクトにタグを追加するか、既存のタグを選択してください。';

  @override
  String get createNewTagButton => '新しいタグを作る';

  @override
  String get applyTags => '適用';

  @override
  String get deleteTag => 'タグを削除';

  @override
  String deleteTagConfirm(Object name) {
    return 'タグ「$name」を削除しますか？\nこのタグが指定されているすべてのプロジェクトから削除されます。';
  }

  @override
  String get am => '午前';

  @override
  String get pm => '午後';

  @override
  String get projectNotFound => 'プロジェクトが見つかりません';

  @override
  String loadDataFailed(Object error) {
    return 'データの読み込み失敗: $error';
  }

  @override
  String get enterProjectName => 'プロジェクト名を入力してください';

  @override
  String saveProjectFailed(Object error) {
    return 'プロジェクトの保存失敗: $error';
  }

  @override
  String loadProjectsFailed(Object error) {
    return 'プロジェクトの読み込み失敗: $error';
  }

  @override
  String initFailed(Object error) {
    return '初期化失敗: $error';
  }

  @override
  String get copySuffix => '(コピー)';

  @override
  String get projectCopied => 'プロジェクトをコピーしました';

  @override
  String copyProjectFailed(Object error) {
    return 'プロジェクトのコピー失敗: $error';
  }

  @override
  String get tagsAssigned => 'タグを指定しました';

  @override
  String assignTagsFailed(Object error) {
    return 'タグの指定失敗: $error';
  }

  @override
  String get projectCreated => 'プロジェクトを作成しました';

  @override
  String createProjectFailed(Object error) {
    return 'プロジェクトの作成失敗: $error';
  }

  @override
  String get projectUpdated => 'プロジェクトを更新しました';

  @override
  String updateProjectFailed(Object error) {
    return 'プロジェクトの更新失敗: $error';
  }

  @override
  String get projectDeleted => 'プロジェクトを削除しました';

  @override
  String deleteProjectFailed(Object error) {
    return 'プロジェクトの削除失敗: $error';
  }

  @override
  String loadCounterCountFailed(Object error) {
    return 'カウンター数の読み込み失敗: $error';
  }

  @override
  String loadPartsFailed(Object error) {
    return 'パーツの読み込み失敗: $error';
  }

  @override
  String createPartFailed(Object error) {
    return 'パーツの作成失敗: $error';
  }

  @override
  String updatePartFailed(Object error) {
    return 'パーツの更新失敗: $error';
  }

  @override
  String reorderPartsFailed(Object error) {
    return 'パーツ順序の変更失敗: $error';
  }

  @override
  String deletePartFailed(Object error) {
    return 'パーツの削除失敗: $error';
  }

  @override
  String loadTagsFailed(Object error) {
    return 'タグの読み込み失敗: $error';
  }

  @override
  String get enterTagName => 'タグ名を入力してください';

  @override
  String get tagCreated => 'タグを作成しました';

  @override
  String createTagFailed(Object error) {
    return 'タグの作成失敗: $error';
  }

  @override
  String get tagUpdated => 'タグを更新しました';

  @override
  String updateTagFailed(Object error) {
    return 'タグの更新失敗: $error';
  }

  @override
  String get tagDeleted => 'タグを削除しました';

  @override
  String deleteTagFailed(Object error) {
    return 'タグの削除失敗: $error';
  }

  @override
  String shapingTargetInfoPattern(
    Object amount,
    Object interval,
    Object totalCount,
    Object unit,
  ) {
    return '$interval段ごとに $amount$unit × $totalCount回';
  }

  @override
  String shapingTargetInfoDirect(Object amount, Object rows, Object unit) {
    return '$rows段目で $amount$unit';
  }

  @override
  String intervalTargetInfo(Object interval, Object totalCount) {
    return '$interval段ごとに × $totalCount回';
  }

  @override
  String get exportSuccess => 'データの書き出しが完了しました！';

  @override
  String exportFailed(Object error) {
    return '書き出し失敗: $error';
  }

  @override
  String get importWarning => '既存のデータはすべて削除され、バックアップデータに置き換わります。続行しますか？';

  @override
  String get continueProcess => '続行する';

  @override
  String get importSuccess => 'データの復元が完了しました！';

  @override
  String copyRevenueCatIdSuccess(Object id) {
    return 'RevenueCat IDをコピーしました:\n$id';
  }

  @override
  String get english => '英語';

  @override
  String get japanese => '日本語';

  @override
  String get targetReachedTitle => '目標段数完了！';

  @override
  String targetReachedDesc(int targetValue) {
    return '目標の$targetValue段を完了しました。\n本当にお疲れ様でした！ 🧶';
  }

  @override
  String get stash => 'ストック';

  @override
  String get stashTabDesc => '所持している毛糸の在庫とスペックを記録・管理します。';

  @override
  String get noStashesYet => 'まだ登録された毛糸がありません。\n新しい毛糸を登録してみましょう。';

  @override
  String get createStash => '毛糸を登録する';

  @override
  String get newStash => '新しい毛糸の登録';

  @override
  String get editStash => '毛糸情報の編集';

  @override
  String get deleteStash => '毛糸の削除';

  @override
  String get stashInfo => '糸の情報';

  @override
  String get copyStash => '毛糸の複製';

  @override
  String get stashName => 'ニックネーム';

  @override
  String get stashNameHint => '例：カーディガン用メリノウール';

  @override
  String get yarnName => '糸の名前 (製品名)';

  @override
  String get yarnImage => '糸の画像';

  @override
  String get yarnWeight => '糸の太さ (Weight)';

  @override
  String get selectYarnWeight => '糸の太さを選択';

  @override
  String get quantityAndSpec => '数量・スペック';

  @override
  String get yarnNameHint => '例：メリノウール 100%';

  @override
  String get brandName => 'ブランド / メーカー';

  @override
  String get brandNameHint => 'メーカー名を入力してください';

  @override
  String get colorwayName => 'カラー名 (色番号)';

  @override
  String get colorwayNameHint => '例：サクラピンク または 05';

  @override
  String get dyeLot => 'ロット番号 (Lot)';

  @override
  String get dyeLotHint => '帯紙のロット番号(Lot)を入力してください';

  @override
  String get skeins => '所持数量 (玉/かせ)';

  @override
  String get skeinsHint => '例：3.3';

  @override
  String get yarnLengthPerSkein => '1玉あたりの長さ';

  @override
  String get yarnWeightPerSkein => '1玉あたりの重さ';

  @override
  String get totalLength => '合計の長さ';

  @override
  String get totalWeight => '合計の重さ';

  @override
  String get location => '保管場所';

  @override
  String get locationHint => '例：寝室の引き出し2段目';

  @override
  String get notesHint => '素材・混率などの詳細を自由に記入してください';

  @override
  String get stashDeleted => '毛糸が削除されました。';

  @override
  String deleteStashConfirm(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get deleteStashDesc => '毛糸はゴミ箱に移動され、\n30日後に自動的に永久削除されます。';

  @override
  String get deleteStashProjectWarning => '紐づけられたプロジェクトとの連携が解除されます。';

  @override
  String get yards => 'ヤード (yd)';

  @override
  String get meters => 'メートル (m)';

  @override
  String get grams => 'グラム (g)';

  @override
  String get ounces => 'オンス (oz)';

  @override
  String stashYarnsCount(int count) {
    return '$count個の毛糸';
  }

  @override
  String get noMatchingYarns => '該当する毛糸がありません';

  @override
  String get yarns => '毛糸';

  @override
  String get weightThread => 'Thread';

  @override
  String get weightCobweb => 'Cobweb';

  @override
  String get weightLace => 'Lace';

  @override
  String get weightLightFingering => 'Light Fingering';

  @override
  String get weightFingering => 'Fingering (14 wpi)';

  @override
  String get weightSport => 'Sport (12 wpi)';

  @override
  String get weightDK => 'DK (11 wpi)';

  @override
  String get weightWorsted => 'Worsted (9 wpi)';

  @override
  String get weightAran => 'Aran (8 wpi)';

  @override
  String get weightBulky => 'Bulky (7 wpi)';

  @override
  String get weightSuperBulky => 'Super Bulky (5-6 wpi)';

  @override
  String get weightJumbo => 'Jumbo (0-4 wpi)';

  @override
  String get undo => '元に戻す';

  @override
  String get editSkeinsTitle => '数量を直接入力';

  @override
  String skeinsAdjusted(double skeins) {
    return '数量が$skeins玉に変更されました。';
  }

  @override
  String skeinsCount(num count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString玉';
  }

  @override
  String get linkStashYarn => '糸を連携';

  @override
  String get selectStashYarn => '保管箱から糸を選択';

  @override
  String get unlink => '連携解除';

  @override
  String get linkedYarn => '連携された糸';

  @override
  String get noLinkedYarn => '連携された糸なし';

  @override
  String get usingProjects => 'この糸を使用するプロジェクト';

  @override
  String get addYarn => '糸を追加';
}
