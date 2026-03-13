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
  String get exportDataSub => 'Save all projects as a JSON file';

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
  String get tabsConfigTitle => '📱 Composed of 3 tabs';

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
  String get newPart => '+ New Part';

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
      'You can leave a memo for each part. It helps to leave notes like \"Made many mistakes in this section\" or \"Looserr next time\".';

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
      'Start your knitting journey with the chameleon\nOne stitch at a time makes a wonderful work';

  @override
  String get createNewProject => 'Start New Project';

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
      'A small start makes a big work\nCast on your first stitch now!';

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
  String get appVersion => 'Version 1.0.0';

  @override
  String get korean => 'Korean';

  @override
  String get autoWithDeviceSetting => 'Auto (Follows device setting)';

  @override
  String get chameleonStory => 'Chameleon\'s Story';

  @override
  String get chameleonStoryDesc =>
      'Our chameleon friend doesn\'t have the ability to change colors. However, by knitting clothes of various colors and patterns, he lives happily every day in a new look. We hope you also have a great time with knitting, just like the chameleon!';

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
    return '$year/$month/$day';
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
  String get deleteForeverNow => 'Delete Forever Now';

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
  String get deleteForever => 'Delete Forever';

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
}
