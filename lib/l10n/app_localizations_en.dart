// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get auto => 'Auto';

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get preferencesSubtitle => 'Configure your app environment';

  @override
  String get language => 'Language';

  @override
  String get lengthUnit => 'Length unit';

  @override
  String get dataManage => 'Data management';

  @override
  String get sessionSetting => 'Session settings';

  @override
  String get touchFeedback => 'Touch feedback';

  @override
  String get languageCurrentKorean => 'Auto (Current: Korean)';

  @override
  String get languageSub =>
      'Selecting Auto follows the device language settings';

  @override
  String get lengthCm => 'Centimeter (cm)';

  @override
  String get lengthInch => 'Inch (inch)';

  @override
  String get lengthSub => 'Applied to hook size, length measurement, etc.';

  @override
  String get autoBackup => 'Auto backup';

  @override
  String get autoBackupSub => 'Automatically backup data every day';

  @override
  String get exportData => 'Export data';

  @override
  String get exportDataSub => 'Save project data and images as a file';

  @override
  String get importData => 'Import data';

  @override
  String get importDataSub => 'Restore from a backup file';

  @override
  String get screenAwake => 'Keep screen on';

  @override
  String get screenAwakeSub => 'Screen won\'t turn off while working';

  @override
  String get touchFeedbackSub =>
      'You can receive feedback when pressing counter buttons';

  @override
  String get vibrate => 'Vibrate';

  @override
  String get sound => 'Sound';

  @override
  String get both => 'Both';

  @override
  String get none => 'None';

  @override
  String get my => 'My';

  @override
  String get mySubtitle => 'Language, Unit, Backup';

  @override
  String get settings => 'Settings';

  @override
  String get welcome => 'Welcome to Yarnie!';

  @override
  String get welcomeDesc =>
      'Yarnie helps you organize your knitting projects\nand track your progress easily.';

  @override
  String get tabsConfigTitle => '📱 Explore the 3 Tabs';

  @override
  String get homeTab => 'Home Tab';

  @override
  String get homeTabDesc =>
      'Quickly check and continue your ongoing work. Check activity logs and badges here too.';

  @override
  String get projectsTab => 'Projects Tab';

  @override
  String get projectsTabDesc =>
      'Where you manage all your projects. You can switch between Large Gallery, Small Gallery, and List views, and sort by Recent, Newest, Oldest, or Name.';

  @override
  String get myTab => 'My Tab';

  @override
  String get myTabDesc =>
      'Use additional features like tag management, trash, and settings.';

  @override
  String get tagFiltering => 'Tag Filtering';

  @override
  String get tagFilteringDesc =>
      'Select a tag in the Projects tab to see only projects with that tag. Selecting multiple tags shows projects that have all selected tags.';

  @override
  String get createProjectTitle => '🎯 Creating a Project';

  @override
  String get createProjectDesc =>
      'A project represents a finished work. For example, \'Winter Sweater\', \'Baby Blanket\', or \'Socks\'.';

  @override
  String get createProjectGuide1 => 'In the Projects tab, ';

  @override
  String get createProjectGuide2 => 'tap + New Project';

  @override
  String get createProjectGuide3 => ' button';

  @override
  String get createProjectGuide4 =>
      'Enter project name, needle info, photos, etc.';

  @override
  String get createProjectGuide5 => 'Add tags for classification (optional)';

  @override
  String get splitPartTitle => '🧩 Dividing into Parts';

  @override
  String get splitPartDesc =>
      'A project can be divided into multiple Parts. Each Part can progress independently.';

  @override
  String get sweaterExample => 'Example: Sweater Project';

  @override
  String get frontPanel => 'Front Panel';

  @override
  String get backPanel => 'Back Panel';

  @override
  String get leftSleeve => 'Left Sleeve';

  @override
  String get rightSleeve => 'Right Sleeve';

  @override
  String get neckline => 'Neckline';

  @override
  String get addPartMethod => 'How to add a Part';

  @override
  String get addPartMethodDesc => 'In the project detail screen, tap the';

  @override
  String get newPart => 'New Part';

  @override
  String get addPartMethodSuffix =>
      '\nbutton at the top left to add a new Part.';

  @override
  String get counterSystemTitle => '🔢 Counter System';

  @override
  String get counterSystemDesc =>
      'Each Part tracks progress with counters.\nYou can have 1 MainCounter and multiple BuddyCounters.';

  @override
  String get mainCounterTitle => 'Main Counter (MainCounter)';

  @override
  String get mainCounterDesc =>
      'The basic counter for counting rows. Tap once to increase by 1.';

  @override
  String get tip => '💡 Tip:';

  @override
  String get mainCounterTip =>
      ' Set a target row to see progress. For example, if you set 100 as the target, you can see what percentage you\'ve completed.';

  @override
  String get buddyCounterTitle => 'Buddy Counter (BuddyCounter)';

  @override
  String get buddyCounterDesc =>
      'Auxiliary counters used with the Main Counter. Includes Stitch Counters and Section Counters.';

  @override
  String get stitchCounterTitle => 'Stitch Counter (Stitch Counter)';

  @override
  String get stitchCounterDesc =>
      'An independent counter for counting stitches within a row. Not linked to the Main Counter.';

  @override
  String get whenToUse => 'When to use?';

  @override
  String get stitchCounterUsage1 =>
      '• Tracking which stitch you\'re on in complex patterns';

  @override
  String get stitchCounterUsage2 =>
      '• Checking exact stitch counts during increases/decreases';

  @override
  String get stitchCounterUsage3 =>
      '• Counting repeat sections of cable or lace patterns';

  @override
  String get sectionCounterTitle => 'Section Counter (Section Counter)';

  @override
  String get sectionCounterDesc =>
      'Counters linked to the Main Counter to track specific sections or patterns. There are 5 types.';

  @override
  String get mainCounterLink => '🔗 Main Counter Linking';

  @override
  String get mainCounterLinkDesc =>
      'Turn on the link button to automatically calculate when the Main Counter increases. Section counters only work when linked to the Main Counter.';

  @override
  String get sectionCounterTypes => '5 Types of Section Counters';

  @override
  String get rangeCounter => 'Range Counter (Range)';

  @override
  String get rangeCounterDesc =>
      'Tracks work in a specific range (Start Row ~ Target Row).';

  @override
  String get rangeCounterUsage1 =>
      '• Section work like \"Knit from row 20 to 40\"';

  @override
  String get rangeCounterUsage2 =>
      '• Marking specific sections where patterns change';

  @override
  String get rangeCounterUsage3 => '• Managing sections using multiple colors';

  @override
  String get rangeCounterExample => '\"Front Panel Row 20~40: Cable Pattern\"';

  @override
  String get repeatCounter => 'Repeat Counter (Repeat)';

  @override
  String get repeatCounterDesc => 'Tracks work that repeats every few rows.';

  @override
  String get repeatCounterUsage1 =>
      '• Repeating work like \"Increase every 6 rows\"';

  @override
  String get repeatCounterUsage2 =>
      '• Tracking \"Pattern repeat every 4 rows\"';

  @override
  String get repeatCounterUsage3 => '• Counting regular patterns or techniques';

  @override
  String get repeatCounterExample =>
      '\"Increase 1 st at both ends every 6 rows (8 times)\"';

  @override
  String get intervalCounter => 'Interval Counter (Interval)';

  @override
  String get intervalCounterDesc =>
      'Tracks work that changes at regular intervals.\n(e.g., Color change)';

  @override
  String get intervalCounterUsage1 => '• When changing colors periodically';

  @override
  String get intervalCounterUsage2 => '• Creating stripe patterns';

  @override
  String get intervalCounterUsage3 => '• Tracking yarn sequence';

  @override
  String get intervalCounterExample =>
      '\"Change color every 4 rows: Blue → White → Red\nin sequence\"';

  @override
  String get shapingCounter => 'Shaping Counter (Shaping)';

  @override
  String get shapingCounterDesc =>
      'Tracks the progress of increases/decreases.';

  @override
  String get shapingCounterUsage1 =>
      '• Increases/decreases for sleeves or body';

  @override
  String get shapingCounterUsage2 => '• Creating diagonals for raglan sleeves';

  @override
  String get shapingCounterUsage3 => '• Neckline or shoulder shaping';

  @override
  String get shapingCounterExample =>
      '\"Increase 6 times at both ends: 68 sts → 80 sts\"';

  @override
  String get lengthCounter => 'Length Counter (Length)';

  @override
  String get lengthCounterDesc =>
      'Tracks work until a certain length is reached.';

  @override
  String get lengthCounterUsage1 =>
      '• Length-based work like \"Knit until 30cm\"';

  @override
  String get lengthCounterUsage2 =>
      '• Reaching desired length for scarves or blankets';

  @override
  String get lengthCounterUsage3 => '• Tracking sleeve or body length';

  @override
  String get lengthCounterExample => '\"Continue in stockinette until 40cm\"';

  @override
  String get sectionCounterLinkTitle => '🔗 Section Counter Linking';

  @override
  String get sectionCounterLinkDesc =>
      'Section counters can be linked to the Main Counter. When linked, they are automatically calculated as the Main Counter increases.';

  @override
  String get tipLinkButton => '💡 Tip: Link Button ';

  @override
  String get tipLinkButtonDesc =>
      ' Tap to turn linking on or off. It\'s linked when it\'s green.';

  @override
  String get stitchCounterNote =>
      'Note: Stitch counters operate independently within a row, so they are not linked to the Main Counter.';

  @override
  String get proTips => '✨ Pro Tips';

  @override
  String get useMemo => '📝 Use Memos';

  @override
  String get useMemoDesc =>
      'You can leave a memo for each part. It helps to leave notes like \"Made many mistakes in this section\" or \"Looser next time\".';

  @override
  String get useTags => '🎨 Categorize with Tags';

  @override
  String get useTagsDesc =>
      'Add tags to projects to find them easily. Try making tags like \"In Progress\", \"Completed\", \"Clothing\", \"Accessories\".';

  @override
  String get takePhotos => '📸 Take Photos';

  @override
  String get takePhotosDesc =>
      'It\'s fun to look back later at photos of your finished work or work in progress.';

  @override
  String get readyToStart => 'Are you ready to start?';

  @override
  String get startJourney =>
      'Start your happy knitting journey with Yarnie!\nCheck back anytime if you have questions.';

  @override
  String get guideAgain =>
      'This guide can be seen again in the User Guide card on the Home screen or in My > Customer Support.';

  @override
  String get close => 'Close';

  @override
  String get examplePrefix => 'Example: ';

  @override
  String get knittingTip1 =>
      'Leave at least 10cm of yarn tail for easier finishing';

  @override
  String get knittingTip2 =>
      'Always knit a gauge swatch. It\'s the secret to project success!';

  @override
  String get knittingTip3 => 'One stitch at a time, don\'t rush';

  @override
  String get knittingTip4 =>
      'If you\'re unsure about color combinations, get inspiration from nature';

  @override
  String get knittingTip5 =>
      'If knitting tension is too tight, your wrists might hurt. Stay relaxed!';

  @override
  String get knittingTip6 =>
      'Easily track complex patterns with Yarnie\'s section counters';

  @override
  String get knittingTip7 => 'Check off each row as you read the pattern';

  @override
  String get knittingTip8 =>
      'Take frequent breaks. Mistakes increase when you\'re tired';

  @override
  String get knittingTip9 =>
      'Check if your needle size is correct. It changes the quality of the work';

  @override
  String get knittingTip10 =>
      'Don\'t be afraid of mistakes. Ripping back is also practice';

  @override
  String get welcomeUser => 'Welcome! 🦎';

  @override
  String get helloUser => 'Hello! 🦎';

  @override
  String get enjoyKnitting => 'Have a happy knitting day';

  @override
  String get startKnitting => 'Start your enjoyable knitting time';

  @override
  String get startFirstProject => 'Start your first project!';

  @override
  String get startJourneyWithChameleon =>
      'Start your knitting journey with the chameleon\nOne stitch at a time creates a wonderful masterpiece';

  @override
  String get createNewProject => 'New Project';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String weeksAgo(Object weeks) {
    return '${weeks}w ago';
  }

  @override
  String monthsAgo(Object months) {
    return '${months}mo ago';
  }

  @override
  String get recentProjects => 'Recent Projects';

  @override
  String get continueWorking => 'Continue';

  @override
  String get firstTimeUsing => 'First time using?';

  @override
  String get yarnieBriefDesc =>
      'Yarnie divides projects into Parts and tracks progress with counters for each Part.';

  @override
  String get viewUserGuide => 'View User Guide';

  @override
  String get knittingTips => 'Knitting Tips';

  @override
  String get knittingToday => 'Shall we knit today?';

  @override
  String get smallStart =>
      'Small beginnings create big masterpieces\nCast on your first stitch now!';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationSettingsSub => 'Work reminders, badge notifications';

  @override
  String get comingSoon => 'This feature will be available soon.';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get customerSupport => 'Customer Support';

  @override
  String get trash => 'Trash';

  @override
  String get trashSub => 'Manage deleted projects';

  @override
  String get userGuide => 'User Guide';

  @override
  String get userGuideSub => 'Learn how to use Yarnie';

  @override
  String get appInfo => 'App Info';

  @override
  String get appVersion => 'Version';

  @override
  String get korean => 'Korean';

  @override
  String get autoWithDeviceSetting => 'Auto (Follows device setting)';

  @override
  String get chameleonStory => 'Chameleon\'s Story';

  @override
  String get chameleonStoryDesc =>
      'Our chameleon friend doesn\'t have the ability to change colors. However, by knitting clothes of various colors and patterns, he lives happily every day with a new look. We hope you also have a great time with knitting, just like the chameleon!';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get openSourceLicense => 'Open Source Licenses';

  @override
  String get projects => 'Projects';

  @override
  String projectsCount(Object count) {
    return '$count projects';
  }

  @override
  String get all => 'All';

  @override
  String get bigCard => 'Large Card';

  @override
  String get smallCard => 'Small Card';

  @override
  String get list => 'List';

  @override
  String dateDisplay(Object day, Object month, Object year) {
    return '$month/$day/$year';
  }

  @override
  String get noProjectsYet => 'No projects yet.\nShall we create a project?';

  @override
  String get createProject => 'Create Project';

  @override
  String get noMatchingProjects => 'No matching projects found';

  @override
  String get filterResetDesc =>
      'Try selecting other tags or\nresetting the filter';

  @override
  String get resetFilter => 'Reset Filter';

  @override
  String get copyProject => 'Copy Project';

  @override
  String get assignTags => 'Assign Tags';

  @override
  String get unclassified => 'Unclassified';

  @override
  String get sessionMemo => 'Session Memo';

  @override
  String get enterMemo => 'Enter memo';

  @override
  String saveSessionConfirm(Object time) {
    return 'Do you want to save the work time $time?';
  }

  @override
  String trashProjectCount(Object count) {
    return '$count projects · Auto-delete after 30 days';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get errorLoadingData => 'Unable to load data';

  @override
  String get availableAfterRestore => 'Available after restore.';

  @override
  String errorOccurred(Object error) {
    return 'Error: $error';
  }

  @override
  String get restore => 'Restore';

  @override
  String get deleteForeverNow => 'Delete Permanently Now';

  @override
  String get restoreProject => 'Restore Project';

  @override
  String get restoreConfirm => 'Do you want to restore this project?';

  @override
  String get projectRestored => 'Project restored.';

  @override
  String restoreFailed(Object error) {
    return 'Restore failed: $error';
  }

  @override
  String get deleteForever => 'Delete Permanently';

  @override
  String get deleteForeverConfirm =>
      'Do you want to permanently delete this project?\nThis action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get projectDeletedForever => 'Project permanently deleted.';

  @override
  String deleteFailed(Object error) {
    return 'Delete failed: $error';
  }

  @override
  String get emptyTrash => 'Trash is empty';

  @override
  String get noDeletedProjects => 'No deleted projects';

  @override
  String partMemo(Object partName) {
    return '$partName - Memos';
  }

  @override
  String get partMemoDesc => 'Add or edit memos for this part.';

  @override
  String get newMemoHint => 'Enter a new memo...';

  @override
  String get addMemo => 'Add Memo';

  @override
  String get noMemos => 'No memos registered.';

  @override
  String get unpin => 'Unpin';

  @override
  String get pin => 'Pin to top';

  @override
  String get edit => 'Edit';

  @override
  String get editMemo => 'Edit Memo';

  @override
  String get editMainCount => 'Edit Main Count';

  @override
  String get editMainCountDesc => 'Manually edit or reset the current count.';

  @override
  String get currentCount => 'Current Count';

  @override
  String get resetToOne => 'Reset to 1';

  @override
  String get rangeCounterLabel => 'Range Counter';

  @override
  String get editRangeCounter => 'Edit Range Counter';

  @override
  String get addRangeCounter => 'Add Range Counter';

  @override
  String get rangeCounterDescSimple =>
      'A counter to track a specific row range.';

  @override
  String get startRow => 'Start Row';

  @override
  String get totalRows => 'Total Rows';

  @override
  String get rowsHint => 'e.g., 50';

  @override
  String get rowsHelper => 'Enter how many rows to track from the start row.';

  @override
  String get add => 'Add';

  @override
  String get label => 'Label';

  @override
  String get labelHint => 'Enter a label to easily identify the counter';

  @override
  String get tagSelection => 'Tag Selection';

  @override
  String get complete => 'Complete';

  @override
  String get searchTags => 'Search tags...';

  @override
  String get addNewTag => 'Add New Tag';

  @override
  String get tagName => 'Tag Name';

  @override
  String get editTag => 'Edit Tag';

  @override
  String get shapingCounterLabel => 'Shaping Counter';

  @override
  String get editShapingCounter => 'Edit Shaping Counter';

  @override
  String get addShapingCounter => 'Add Shaping Counter';

  @override
  String get shapingCounterDescSimple =>
      'A counter to track increases or decreases.';

  @override
  String get intervalRows => 'Interval (Rows)';

  @override
  String get intervalHint => 'e.g., 2';

  @override
  String get totalTimes => 'Total Times';

  @override
  String get timesHint => 'e.g., 10';

  @override
  String get stitchChange => 'Stitch Change (Per time)';

  @override
  String get stitchChangeHint => 'e.g., 2 or -2';

  @override
  String get stitchChangeHelper =>
      'Positive for increases, negative for decreases.';

  @override
  String get intervalCounterLabel => 'Interval Counter';

  @override
  String get editIntervalCounter => 'Edit Interval Counter';

  @override
  String get addIntervalCounter => 'Add Interval Counter';

  @override
  String get intervalCounterDescSimple =>
      'A counter to use when repeating work at regular intervals.';

  @override
  String get intervalTimesHelper => 'Enter the interval and total times.';

  @override
  String get colorOption => 'Color Options';

  @override
  String get colorOptionDesc =>
      'Select colors in order if color tracking is needed';

  @override
  String get editStitchCounter => 'Edit Stitch Counter';

  @override
  String get editCounterInfo => 'Edit counter information.';

  @override
  String get currentValue => 'Current Value';

  @override
  String get countUnit => 'Increment Unit';

  @override
  String get repeatCounterLabel => 'Repeat Counter';

  @override
  String get editRepeatCounter => 'Edit Repeat Counter';

  @override
  String get addRepeatCounter => 'Add Repeat Counter';

  @override
  String get repeatCounterDescSimple =>
      'A counter to use when repeating specific patterns.';

  @override
  String get repeatUnit => 'Repeat Unit (Rows)';

  @override
  String get repeatUnitHint => 'e.g. 4';

  @override
  String get repeatTimes => 'Repeat Times';

  @override
  String get repeatHelper =>
      'Enter the pattern repeat unit and number of times.';

  @override
  String get deleteConfirm => 'Do you want to delete this project?';

  @override
  String get deleteDesc =>
      'The project will be moved to the trash and permanently deleted after 30 days.';

  @override
  String get achieved => 'Achieved ✓';

  @override
  String get remainingLength => 'Remaining';

  @override
  String get stitchIncrease => 'Increase';

  @override
  String get stitchDecrease => 'Decrease';

  @override
  String nextRow(Object row) {
    return 'Next:$row';
  }

  @override
  String patternRows(Object current, Object total) {
    return 'Row $current of $total';
  }

  @override
  String fromRow(Object row) {
    return 'From row $row';
  }

  @override
  String get stitch => 'sts';

  @override
  String increaseBy(Object n) {
    return '+$n each';
  }

  @override
  String get manualInput => 'Manual input...';

  @override
  String get setIncreaseValue => 'Set Increase Value';

  @override
  String get setIncreaseValueDesc =>
      'Enter the number of stitches to increase at once.';

  @override
  String get increaseValue => 'Increase Value';

  @override
  String get increaseValueHint => 'e.g., 6';

  @override
  String get confirm => 'Confirm';

  @override
  String get exitConfirm => 'Press again to exit.';

  @override
  String get exitAppTitle => 'Do you want to exit the app?';

  @override
  String get exitAppMessage => 'Please press the button below to exit.';

  @override
  String get exit => 'Exit';

  @override
  String get home => 'Home';

  @override
  String get selectCounterType => 'Select Counter Type';

  @override
  String get stitchCounter => 'Stitch Counter';

  @override
  String get independentCounter => 'Independent numeric counter';

  @override
  String get sectionCounter => 'Section Counter';

  @override
  String get range => 'Range';

  @override
  String get repeat => 'Repeat';

  @override
  String get interval => 'Interval';

  @override
  String get shaping => 'Shaping';

  @override
  String get length => 'Length';

  @override
  String get addLengthCounter => 'Add Length Counter';

  @override
  String get editLengthCounter => 'Edit Length Counter';

  @override
  String get lengthCounterDescSimple =>
      'Tracks progress until you reach a specific length.';

  @override
  String get targetLength => 'Target Length';

  @override
  String get lengthHint => 'e.g., 30.0';

  @override
  String get lengthHelper => 'Enter the target length.';

  @override
  String get unit => 'Unit';

  @override
  String get cm => 'cm';

  @override
  String get inch => 'inch';

  @override
  String get countBySetting => 'Count By Setting';

  @override
  String get lengthMeasurement => 'Length Counter';

  @override
  String targetInfoLength(Object length) {
    return 'Target ${length}cm';
  }

  @override
  String targetInfoLengthInch(Object length) {
    return 'Target ${length}inch';
  }

  @override
  String get editLengthCounterTitle => 'Edit Length Counter';

  @override
  String get addLengthCounterTitle => 'Add Length Counter';

  @override
  String get startStitch => 'Start Row';

  @override
  String get targetLengthCm => 'Target Length (cm)';

  @override
  String get targetLengthInch => 'Target Length (inch)';

  @override
  String get targetLengthHint => 'e.g., 25.0';

  @override
  String get rowHeightCm => 'Row Height (cm)';

  @override
  String get rowHeightInch => 'Row Height (inch)';

  @override
  String get rowHeightHint => 'e.g., 0.33';

  @override
  String get rowHeightDesc =>
      'Measure the height of 1 row from your sample, or calculate it from saved gauge info.';

  @override
  String get gaugeInputComingSoon => 'Gauge input feature is coming soon';

  @override
  String get goToGaugeInput => 'Go to gauge input';

  @override
  String get expectedRows => 'Expected Rows';

  @override
  String estimatedRowsDisplay(Object rows) {
    return '$rows rows';
  }

  @override
  String get changeTargetRow => 'Change Target Row';

  @override
  String get removeTargetRow => 'Remove Target Row';

  @override
  String editLogMemo(Object no) {
    return 'Edit log $no Note';
  }

  @override
  String get memoRemoved => 'Note removed';

  @override
  String get memoSaved => 'Note saved';

  @override
  String memoUpdateFailed(Object error) {
    return 'Note update failed: $error';
  }

  @override
  String get labelRemoved => 'Label removed';

  @override
  String labelChanged(Object label) {
    return 'Label changed to \"$label\"';
  }

  @override
  String labelUpdateFailed(Object error) {
    return 'Label update failed: $error';
  }

  @override
  String get more => 'More';

  @override
  String get fold => 'Fold';

  @override
  String get setTargetRow => 'Set Target Row';

  @override
  String get setTargetRowDesc => 'Enter the total rows you want to complete';

  @override
  String get targetRow => 'Target Row';

  @override
  String get manageParts => 'Manage Parts';

  @override
  String get managePartsDesc =>
      'Long press a Part name to edit, or drag the left icon to reorder.';

  @override
  String get noParts => 'No Parts registered.';

  @override
  String get editName => 'Edit Name';

  @override
  String get deletePart => 'Delete Part';

  @override
  String deletePartConfirm(Object name) {
    return 'Do you want to delete the Part \'$name\'?\nAll counters, sessions, and notes in this Part will be deleted.';
  }

  @override
  String get duplicatePartName => 'This part name already exists.';

  @override
  String get newPartName => 'New Part Name';

  @override
  String get rowHeightError => 'Row height must be less than target length.';

  @override
  String get projectInfo => 'Project Info';

  @override
  String get projectDelete => 'Delete Project';

  @override
  String get newPartTitle => 'New Part';

  @override
  String get addPartDesc => 'Please add a Part';

  @override
  String get newPartAdd => 'Add New Part';

  @override
  String get partNameHint => 'Part name (e.g. Front, Sleeve)';

  @override
  String get session => 'Session';

  @override
  String rowsRemaining(Object count) {
    return '$count rows left';
  }

  @override
  String get editProject => 'Edit Project';

  @override
  String get newProject => 'New Project';

  @override
  String get editProjectDesc => 'Please edit the project information';

  @override
  String get newProjectDesc => 'Please enter new project information';

  @override
  String get projectName => 'Project Name';

  @override
  String get projectNameHint => 'Enter project name';

  @override
  String get needleType => 'Needle Type';

  @override
  String get knittingNeedle => 'Knitting Needles';

  @override
  String get crochetNeedle => 'Crochet Hook';

  @override
  String get needleTypeHint => 'Select needle type';

  @override
  String get needleSize => 'Needle Size';

  @override
  String get needleSizeHint => 'Select needle type first';

  @override
  String get lotNumberHint => 'e.g. A12345';

  @override
  String get lotNumberDesc => 'Enter the yarn lot number';

  @override
  String get memoHint =>
      'Write notes about the project\ne.g. yarn type, color, pattern info, etc.';

  @override
  String get tagAdd => 'Add Tag';

  @override
  String get gauge => 'Gauge';

  @override
  String get gaugeDesc => 'How many stitches and rows in 10cm x 10cm?';

  @override
  String get gaugeDescInch => 'How many stitches and rows in 4in x 4in?';

  @override
  String get stitchesHint => 'Stitches';

  @override
  String get stitchesUnit => 'St.';

  @override
  String get rowsHintGauge => 'Rows';

  @override
  String get rowsUnit => 'Rows';

  @override
  String get editComplete => 'Edit Complete';

  @override
  String get addComplete => 'Add Complete';

  @override
  String get addImage => 'Add Image';

  @override
  String get imageSourceDesc => 'Take a photo or select from gallery.';

  @override
  String get cameraShot => 'Take Photo';

  @override
  String get gallerySelect => 'Select from Gallery';

  @override
  String get projectImage => 'Project Image';

  @override
  String get reset => 'Reset';

  @override
  String get change => 'Change';

  @override
  String get memo => 'Note';

  @override
  String get tag => 'Tag';

  @override
  String get paused => 'Paused';

  @override
  String get start => 'Start';

  @override
  String get projectInfoDesc => 'Check the detailed project info';

  @override
  String get lotNumberLabel => 'Yarn Lot Number';

  @override
  String get noTagsAssigned => 'No tags assigned.';

  @override
  String get noGaugeInfo => 'No gauge info';

  @override
  String get noMemoInfo => 'No notes';

  @override
  String get createdAtLabel => 'Created At';

  @override
  String get updatedAtLabel => 'Recently Updated';

  @override
  String get gaugeStandard => '(per 10cm x 10cm)';

  @override
  String get gaugeStandardInch => '(per 4in x 4in)';

  @override
  String get noCounters => 'No counters.';

  @override
  String get addCounterGuide => 'Tap + button to add.';

  @override
  String completeWithEmoji(Object name) {
    return '$name completed! 🎉';
  }

  @override
  String get viewDetails => 'View Details';

  @override
  String get editLabel => 'Edit Label';

  @override
  String get selectLabel => 'Select Label';

  @override
  String get manageLabels => 'Manage Labels';

  @override
  String get addLabel => 'Add Label';

  @override
  String get activeSessionExists => 'An active session exists';

  @override
  String get resume => 'Resume';

  @override
  String get startNew => 'Start New';

  @override
  String get activeSession => 'Active Session';

  @override
  String get activeSessionQuestion =>
      'An active session exists. Do you want to continue?';

  @override
  String get dbDuplicateError => 'A duplicate value exists';

  @override
  String get dbForeignKeyError => 'The referenced record does not exist';

  @override
  String get dbRequiredError => 'A required value is missing';

  @override
  String get dbIntegrityError => 'Data integrity violation';

  @override
  String get dbConstraintError => 'Data constraint violation';

  @override
  String get dbGeneralError => 'A database error occurred';

  @override
  String get dbRecordNotFoundError => 'Record not found';

  @override
  String get defaultLabelSleeves => 'Sleeves';

  @override
  String get defaultLabelBody => 'Body';

  @override
  String get defaultLabelNeckline => 'Neckline';

  @override
  String get userGuideJourney => 'Your knitting journey with Yarnie';

  @override
  String get trashHeader => 'Trash';

  @override
  String trashProjectCountInfo(Object count) {
    return '$count projects · Auto-deleted after 30 days';
  }

  @override
  String get restoreProjectTitle => 'Restore Project';

  @override
  String get restoreConfirmMessage => 'Do you want to restore this project?';

  @override
  String get projectRestoredMessage => 'Project restored.';

  @override
  String get deleteForeverTitle => 'Delete Permanently';

  @override
  String get deleteForeverConfirmMessage =>
      'Permanently delete this project?\nThis cannot be undone.';

  @override
  String get mainCounterTitleAlt => 'Main Counter (MainCounter)';

  @override
  String countByLabel(Object value) {
    return 'count by $value';
  }

  @override
  String get yarniePremium => 'Yarnie Premium';

  @override
  String get yarniePremiumSub => 'Unlimited features';

  @override
  String get premiumTitle1 => 'Freedom without limits,';

  @override
  String get premiumTitle2 => 'Expand your knitting world!';

  @override
  String get premiumFeature1Title => 'Completely ad-free';

  @override
  String get premiumFeature1Sub => 'Uninterrupted knitting time';

  @override
  String get premiumFeature2Title => 'Unlimited Projects';

  @override
  String get premiumFeature2Sub => 'Cast on as many projects as you want';

  @override
  String get premiumFeature3Title => 'Unlimited Parts & Counters';

  @override
  String get premiumFeature3Sub => 'Track complex patterns easily';

  @override
  String get premiumComingSoon =>
      'Enjoy future statistics and widget updates at no extra cost!';

  @override
  String get premiumPrice => '\$4.99';

  @override
  String get premiumPriceDesc => 'No monthly fees, yours forever';

  @override
  String get premiumOneTime => 'One-time payment';

  @override
  String get premiumStartBtn => 'Start Yarnie Premium';

  @override
  String get premiumBtnDesc =>
      'All premium features are available immediately after purchase';

  @override
  String get premiumRestore => 'Restore Purchases';

  @override
  String get premiumRefund => 'Refund Request';

  @override
  String get premiumRefundAndroidTitle => 'Refund Info';

  @override
  String get premiumRefundAndroidMessage =>
      'According to Google Play policy, you must request a refund directly from your store purchase history.';

  @override
  String get premiumRefundAndroidGo => 'Go';

  @override
  String get premiumRefundSuccess => 'Refund request completed.';

  @override
  String get premiumRefundFailed =>
      'An error occurred during the refund request. Please try again in a moment.';

  @override
  String get premiumRefundTryAgain => 'Please try again in a moment';

  @override
  String get premiumTerms => 'Terms of Use';

  @override
  String get premiumPrivacy => 'Privacy Policy';

  @override
  String get premiumFooterDescIOS =>
      'Purchases are billed to your Apple ID. If you change devices or reinstall the app, you can restore premium features using the Restore Purchases button.';

  @override
  String get premiumFooterDescAndroid =>
      'Purchases are billed to your Google Play account. If you change devices or reinstall the app, you can restore premium features using the Restore Purchases button.';

  @override
  String get premiumPurchaseCancelled => 'Purchase was cancelled.';

  @override
  String get premiumPurchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get premiumRestoreSuccess => 'Purchases restored successfully.';

  @override
  String get premiumRestoreNoHistory => 'No purchase history found to restore.';

  @override
  String get premiumNetworkError =>
      'A network error occurred. Please check your connection.';

  @override
  String get upsellSnackbarMessage =>
      'Purchase Yarnie Premium to create unlimited projects!';

  @override
  String get upsellSnackbarAction => 'View Premium';

  @override
  String everyNRows(Object n) {
    return 'Every $n rows';
  }

  @override
  String get row => 'rows';

  @override
  String repeatCountSuffix(int count, String checkmark) {
    return '/ $count times$checkmark';
  }

  @override
  String shapingDecrease(int n) {
    return 'Dec $n sts';
  }

  @override
  String shapingIncrease(int n) {
    return 'Inc $n sts';
  }

  @override
  String get shapingActionNow => 'NOW!';

  @override
  String get shapingWorkEven => 'Work even';

  @override
  String shapingNextActionRow(int row) {
    return 'Next: row $row';
  }

  @override
  String get shapingModePattern => 'Pattern';

  @override
  String get shapingModeDirect => 'Direct';

  @override
  String get shapingRowsLabel => 'Shaping Rows';

  @override
  String get shapingRowsHint => 'e.g., 2, 5, 9, 11';

  @override
  String get shapingRowsHelper =>
      'Enter row numbers for shaping, separated by commas';

  @override
  String shapingDirectSubInfo(Object current, Object total) {
    return '$current/$total times';
  }

  @override
  String get preview => 'Preview';

  @override
  String get tagSelectionDesc => 'Long press a tag to edit or delete.';

  @override
  String get tagSelectionSubtitle =>
      'Add a tag to your project or select an existing one.';

  @override
  String get createNewTagButton => 'Create New Tag';

  @override
  String get applyTags => 'Apply';

  @override
  String get deleteTag => 'Delete Tag';

  @override
  String deleteTagConfirm(Object name) {
    return 'Do you want to delete the tag \'$name\'?\nIt will be removed from all projects.';
  }
}
