import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @auto.
  ///
  /// In ko, this message translates to:
  /// **'자동'**
  String get auto;

  /// No description provided for @preferencesTitle.
  ///
  /// In ko, this message translates to:
  /// **'환경 설정'**
  String get preferencesTitle;

  /// No description provided for @preferencesSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'앱 사용 환경을 설정하세요'**
  String get preferencesSubtitle;

  /// No description provided for @language.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// No description provided for @lengthUnit.
  ///
  /// In ko, this message translates to:
  /// **'길이 단위'**
  String get lengthUnit;

  /// No description provided for @dataManage.
  ///
  /// In ko, this message translates to:
  /// **'데이터 관리'**
  String get dataManage;

  /// No description provided for @sessionSetting.
  ///
  /// In ko, this message translates to:
  /// **'작업 중 설정'**
  String get sessionSetting;

  /// No description provided for @touchFeedback.
  ///
  /// In ko, this message translates to:
  /// **'터치 피드백'**
  String get touchFeedback;

  /// No description provided for @languageCurrentKorean.
  ///
  /// In ko, this message translates to:
  /// **'자동 (현재: 한국어)'**
  String get languageCurrentKorean;

  /// No description provided for @languageSub.
  ///
  /// In ko, this message translates to:
  /// **'자동을 선택하면 휴대폰 언어 설정을 따릅니다'**
  String get languageSub;

  /// No description provided for @lengthCm.
  ///
  /// In ko, this message translates to:
  /// **'센티미터 (cm)'**
  String get lengthCm;

  /// No description provided for @lengthInch.
  ///
  /// In ko, this message translates to:
  /// **'인치 (inch)'**
  String get lengthInch;

  /// No description provided for @lengthSub.
  ///
  /// In ko, this message translates to:
  /// **'바늘 사이즈, 길이 측정 등에 적용됩니다'**
  String get lengthSub;

  /// No description provided for @autoBackup.
  ///
  /// In ko, this message translates to:
  /// **'자동 백업'**
  String get autoBackup;

  /// No description provided for @autoBackupSub.
  ///
  /// In ko, this message translates to:
  /// **'매일 자동으로 데이터 백업'**
  String get autoBackupSub;

  /// No description provided for @exportData.
  ///
  /// In ko, this message translates to:
  /// **'데이터 내보내기'**
  String get exportData;

  /// No description provided for @exportDataSub.
  ///
  /// In ko, this message translates to:
  /// **'모든 프로젝트를 JSON 파일로 저장'**
  String get exportDataSub;

  /// No description provided for @importData.
  ///
  /// In ko, this message translates to:
  /// **'데이터 가져오기'**
  String get importData;

  /// No description provided for @importDataSub.
  ///
  /// In ko, this message translates to:
  /// **'백업 파일에서 복원하기'**
  String get importDataSub;

  /// No description provided for @screenAwake.
  ///
  /// In ko, this message translates to:
  /// **'화면 꺼짐 방지'**
  String get screenAwake;

  /// No description provided for @screenAwakeSub.
  ///
  /// In ko, this message translates to:
  /// **'작업 중 화면이 꺼지지 않음'**
  String get screenAwakeSub;

  /// No description provided for @touchFeedbackSub.
  ///
  /// In ko, this message translates to:
  /// **'카운터 버튼을 누를 때 피드백을 받을 수 있어요'**
  String get touchFeedbackSub;

  /// No description provided for @vibrate.
  ///
  /// In ko, this message translates to:
  /// **'진동'**
  String get vibrate;

  /// No description provided for @sound.
  ///
  /// In ko, this message translates to:
  /// **'소리'**
  String get sound;

  /// No description provided for @both.
  ///
  /// In ko, this message translates to:
  /// **'둘 다'**
  String get both;

  /// No description provided for @none.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get none;

  /// No description provided for @my.
  ///
  /// In ko, this message translates to:
  /// **'마이'**
  String get my;

  /// No description provided for @mySubtitle.
  ///
  /// In ko, this message translates to:
  /// **'언어, 단위, 백업'**
  String get mySubtitle;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In ko, this message translates to:
  /// **'Yarnie에 오신 것을 환영해요!'**
  String get welcome;

  /// No description provided for @welcomeDesc.
  ///
  /// In ko, this message translates to:
  /// **'Yarnie는 뜨개질 프로젝트를 체계적으로 관리하고\n진행 상황을 쉽게 추적할 수 있도록 도와드려요'**
  String get welcomeDesc;

  /// No description provided for @tabsConfigTitle.
  ///
  /// In ko, this message translates to:
  /// **'📱 3개의 탭으로 구성되어 있어요'**
  String get tabsConfigTitle;

  /// No description provided for @homeTab.
  ///
  /// In ko, this message translates to:
  /// **'홈 탭'**
  String get homeTab;

  /// No description provided for @homeTabDesc.
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 작업을 빠르게 확인하고 이어서 작업할 수 있어요. 활동 기록과 배지도 여기서 확인해요.'**
  String get homeTabDesc;

  /// No description provided for @projectsTab.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 탭'**
  String get projectsTab;

  /// No description provided for @projectsTabDesc.
  ///
  /// In ko, this message translates to:
  /// **'모든 프로젝트를 관리하는 곳이에요. 대형 갤러리, 소형 갤러리, 리스트 보기로 전환할 수 있고, 최근 작업순, 최신순, 오래된순, 이름순으로 정렬할 수 있어요.'**
  String get projectsTabDesc;

  /// No description provided for @myTab.
  ///
  /// In ko, this message translates to:
  /// **'마이 탭'**
  String get myTab;

  /// No description provided for @myTabDesc.
  ///
  /// In ko, this message translates to:
  /// **'태그 관리, 휴지통, 설정 등 부가 기능을 사용할 수 있어요.'**
  String get myTabDesc;

  /// No description provided for @tagFiltering.
  ///
  /// In ko, this message translates to:
  /// **'태그 필터링'**
  String get tagFiltering;

  /// No description provided for @tagFilteringDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 탭에서 태그를 선택하면 해당 태그가 붙은 프로젝트만 볼 수 있어요. 여러 개의 태그를 동시에 선택하면 모든 태그를 가진 프로젝트만 표시돼요.'**
  String get tagFilteringDesc;

  /// No description provided for @createProjectTitle.
  ///
  /// In ko, this message translates to:
  /// **'🎯 프로젝트 만들기'**
  String get createProjectTitle;

  /// No description provided for @createProjectDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트는 하나의 완성된 작품을 의미해요. 예를 들어 \"겨울 스웨터\", \"아기 담요\", \"양말\" 같은 거예요.'**
  String get createProjectDesc;

  /// No description provided for @createProjectGuide1.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 탭에서 '**
  String get createProjectGuide1;

  /// No description provided for @createProjectGuide2.
  ///
  /// In ko, this message translates to:
  /// **'+ 새 프로젝트'**
  String get createProjectGuide2;

  /// No description provided for @createProjectGuide3.
  ///
  /// In ko, this message translates to:
  /// **' 버튼을 눌러요'**
  String get createProjectGuide3;

  /// No description provided for @createProjectGuide4.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 이름, 바늘 정보, 사진 등을 입력해요'**
  String get createProjectGuide4;

  /// No description provided for @createProjectGuide5.
  ///
  /// In ko, this message translates to:
  /// **'태그를 추가해서 분류할 수 있어요 (선택사항)'**
  String get createProjectGuide5;

  /// No description provided for @splitPartTitle.
  ///
  /// In ko, this message translates to:
  /// **'🧩 Part로 나누기'**
  String get splitPartTitle;

  /// No description provided for @splitPartDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트는 여러 Part로 나눌 수 있어요. 각 Part는 독립적으로 작업을 진행할 수 있어요.'**
  String get splitPartDesc;

  /// No description provided for @sweaterExample.
  ///
  /// In ko, this message translates to:
  /// **'예시: 스웨터 프로젝트'**
  String get sweaterExample;

  /// No description provided for @frontPanel.
  ///
  /// In ko, this message translates to:
  /// **'앞판'**
  String get frontPanel;

  /// No description provided for @backPanel.
  ///
  /// In ko, this message translates to:
  /// **'뒷판'**
  String get backPanel;

  /// No description provided for @leftSleeve.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 소매'**
  String get leftSleeve;

  /// No description provided for @rightSleeve.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 소매'**
  String get rightSleeve;

  /// No description provided for @neckline.
  ///
  /// In ko, this message translates to:
  /// **'목둘레'**
  String get neckline;

  /// No description provided for @addPartMethod.
  ///
  /// In ko, this message translates to:
  /// **'Part 추가 방법'**
  String get addPartMethod;

  /// No description provided for @addPartMethodDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 상세 화면에서 왼쪽 상단의'**
  String get addPartMethodDesc;

  /// No description provided for @newPart.
  ///
  /// In ko, this message translates to:
  /// **'새 파트'**
  String get newPart;

  /// No description provided for @addPartMethodSuffix.
  ///
  /// In ko, this message translates to:
  /// **'\n버튼을 누르면 새로운 Part를 추가할 수 있어요.'**
  String get addPartMethodSuffix;

  /// No description provided for @counterSystemTitle.
  ///
  /// In ko, this message translates to:
  /// **'🔢 카운터 시스템'**
  String get counterSystemTitle;

  /// No description provided for @counterSystemDesc.
  ///
  /// In ko, this message translates to:
  /// **'각 Part는 카운터로 진행 상황을 추적해요.\nMainCounter 1개와 여러 개의 BuddyCounter를 가질 수 있어요.'**
  String get counterSystemDesc;

  /// No description provided for @mainCounterTitle.
  ///
  /// In ko, this message translates to:
  /// **'메인 카운터 (MainCounter)'**
  String get mainCounterTitle;

  /// No description provided for @mainCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'단수를 세는 기본 카운터예요. 한 번 탭하면 1단씩 증가해요.'**
  String get mainCounterDesc;

  /// No description provided for @tip.
  ///
  /// In ko, this message translates to:
  /// **'💡 팁:'**
  String get tip;

  /// No description provided for @mainCounterTip.
  ///
  /// In ko, this message translates to:
  /// **' 목표 단수를 설정하면 진행률을 확인할 수 있어요. 예를 들어 100단을 목표로 설정하면 현재 몇 %까지 진행했는지 알 수 있어요.'**
  String get mainCounterTip;

  /// No description provided for @buddyCounterTitle.
  ///
  /// In ko, this message translates to:
  /// **'보조 카운터 (BuddyCounter)'**
  String get buddyCounterTitle;

  /// No description provided for @buddyCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'메인 카운터와 함께 사용하는 보조 카운터예요. 코 카운터와 섹션 카운터가 있어요.'**
  String get buddyCounterDesc;

  /// No description provided for @stitchCounterTitle.
  ///
  /// In ko, this message translates to:
  /// **'코 카운터 (Stitch Counter)'**
  String get stitchCounterTitle;

  /// No description provided for @stitchCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 단 내에서 코 수를 세는 독립적인 카운터예요. 메인 카운터와 연동되지 않아요.'**
  String get stitchCounterDesc;

  /// No description provided for @whenToUse.
  ///
  /// In ko, this message translates to:
  /// **'언제 사용하나요?'**
  String get whenToUse;

  /// No description provided for @stitchCounterUsage1.
  ///
  /// In ko, this message translates to:
  /// **'• 복잡한 패턴에서 현재 어느 코까지 작업했는지 추적'**
  String get stitchCounterUsage1;

  /// No description provided for @stitchCounterUsage2.
  ///
  /// In ko, this message translates to:
  /// **'• 늘림/줄임 작업할 때 정확한 코 수 확인'**
  String get stitchCounterUsage2;

  /// No description provided for @stitchCounterUsage3.
  ///
  /// In ko, this message translates to:
  /// **'• 케이블이나 레이스 패턴의 반복 구간 세기'**
  String get stitchCounterUsage3;

  /// No description provided for @sectionCounterTitle.
  ///
  /// In ko, this message translates to:
  /// **'섹션 카운터 (Section Counter)'**
  String get sectionCounterTitle;

  /// No description provided for @sectionCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'메인 카운터와 연동되어 특정 구간이나 패턴을 추적하는 카운터예요. 5가지 유형이 있어요.'**
  String get sectionCounterDesc;

  /// No description provided for @mainCounterLink.
  ///
  /// In ko, this message translates to:
  /// **'🔗 메인 카운터 연동'**
  String get mainCounterLink;

  /// No description provided for @mainCounterLinkDesc.
  ///
  /// In ko, this message translates to:
  /// **'링크 버튼을 켜면 메인 카운터가 증가할 때 자동으로 함께 계산돼요. 섹션 카운터는 항상 메인 카운터와 연동되어야 작동해요.'**
  String get mainCounterLinkDesc;

  /// No description provided for @sectionCounterTypes.
  ///
  /// In ko, this message translates to:
  /// **'섹션 카운터 5가지 유형'**
  String get sectionCounterTypes;

  /// No description provided for @rangeCounter.
  ///
  /// In ko, this message translates to:
  /// **'범위 카운터 (Range)'**
  String get rangeCounter;

  /// No description provided for @rangeCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'특정 구간(시작행~목표행)의 작업을 추적해요.'**
  String get rangeCounterDesc;

  /// No description provided for @rangeCounterUsage1.
  ///
  /// In ko, this message translates to:
  /// **'• \"20~40단까지 겉뜨기\" 같은 구간 작업'**
  String get rangeCounterUsage1;

  /// No description provided for @rangeCounterUsage2.
  ///
  /// In ko, this message translates to:
  /// **'• 패턴이 바뀌는 특정 구간 표시'**
  String get rangeCounterUsage2;

  /// No description provided for @rangeCounterUsage3.
  ///
  /// In ko, this message translates to:
  /// **'• 여러 색상을 사용하는 구간 관리'**
  String get rangeCounterUsage3;

  /// No description provided for @rangeCounterExample.
  ///
  /// In ko, this message translates to:
  /// **'\"앞판 20~40단: 케이블 패턴\"'**
  String get rangeCounterExample;

  /// No description provided for @repeatCounter.
  ///
  /// In ko, this message translates to:
  /// **'반복 카운터 (Repeat)'**
  String get repeatCounter;

  /// No description provided for @repeatCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'몇 단마다 반복되는 작업을 추적해요.'**
  String get repeatCounterDesc;

  /// No description provided for @repeatCounterUsage1.
  ///
  /// In ko, this message translates to:
  /// **'• \"6단마다 늘림\" 같은 반복 작업'**
  String get repeatCounterUsage1;

  /// No description provided for @repeatCounterUsage2.
  ///
  /// In ko, this message translates to:
  /// **'• \"4단마다 패턴 반복\" 추적'**
  String get repeatCounterUsage2;

  /// No description provided for @repeatCounterUsage3.
  ///
  /// In ko, this message translates to:
  /// **'• 규칙적인 무늬나 기법 세기'**
  String get repeatCounterUsage3;

  /// No description provided for @repeatCounterExample.
  ///
  /// In ko, this message translates to:
  /// **'\"6단마다 양쪽에서 1코씩 늘림 (8회 반복)\"'**
  String get repeatCounterExample;

  /// No description provided for @intervalCounter.
  ///
  /// In ko, this message translates to:
  /// **'인터벌 카운터 (Interval)'**
  String get intervalCounter;

  /// No description provided for @intervalCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'일정 간격마다 변화하는 작업을 추적해요.\n(예: 색상 변경)'**
  String get intervalCounterDesc;

  /// No description provided for @intervalCounterUsage1.
  ///
  /// In ko, this message translates to:
  /// **'• 색상을 주기적으로 바꿀 때'**
  String get intervalCounterUsage1;

  /// No description provided for @intervalCounterUsage2.
  ///
  /// In ko, this message translates to:
  /// **'• 스트라이프 패턴 만들기'**
  String get intervalCounterUsage2;

  /// No description provided for @intervalCounterUsage3.
  ///
  /// In ko, this message translates to:
  /// **'• 실 배열 순서 추적'**
  String get intervalCounterUsage3;

  /// No description provided for @intervalCounterExample.
  ///
  /// In ko, this message translates to:
  /// **'\"4단마다 색상 변경: 파란색 → 흰색 → 빨간색\n순서로\"'**
  String get intervalCounterExample;

  /// No description provided for @shapingCounter.
  ///
  /// In ko, this message translates to:
  /// **'쉐이핑 카운터 (Shaping)'**
  String get shapingCounter;

  /// No description provided for @shapingCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'늘림/줄임 작업의 진행 상황을 추적해요.'**
  String get shapingCounterDesc;

  /// No description provided for @shapingCounterUsage1.
  ///
  /// In ko, this message translates to:
  /// **'• 소매나 몸판의 늘림/줄임 작업'**
  String get shapingCounterUsage1;

  /// No description provided for @shapingCounterUsage2.
  ///
  /// In ko, this message translates to:
  /// **'• 라글란 소매의 사선 만들기'**
  String get shapingCounterUsage2;

  /// No description provided for @shapingCounterUsage3.
  ///
  /// In ko, this message translates to:
  /// **'• 목둘레나 어깨선 줄임'**
  String get shapingCounterUsage3;

  /// No description provided for @shapingCounterExample.
  ///
  /// In ko, this message translates to:
  /// **'\"양쪽에서 6회 늘림: 68코 → 80코\"'**
  String get shapingCounterExample;

  /// No description provided for @lengthCounter.
  ///
  /// In ko, this message translates to:
  /// **'길이 카운터 (Length)'**
  String get lengthCounter;

  /// No description provided for @lengthCounterDesc.
  ///
  /// In ko, this message translates to:
  /// **'목표 길이까지 필요한 단수를 추적합니다'**
  String get lengthCounterDesc;

  /// No description provided for @lengthCounterUsage1.
  ///
  /// In ko, this message translates to:
  /// **'• \"30cm까지 뜨기\" 같은 길이 기반 작업'**
  String get lengthCounterUsage1;

  /// No description provided for @lengthCounterUsage2.
  ///
  /// In ko, this message translates to:
  /// **'• 스카프나 담요의 원하는 길이 도달'**
  String get lengthCounterUsage2;

  /// No description provided for @lengthCounterUsage3.
  ///
  /// In ko, this message translates to:
  /// **'• 소매 길이나 몸통 길이 추적'**
  String get lengthCounterUsage3;

  /// No description provided for @lengthCounterExample.
  ///
  /// In ko, this message translates to:
  /// **'\"겉뜨기로 40cm까지 계속\"'**
  String get lengthCounterExample;

  /// No description provided for @sectionCounterLinkTitle.
  ///
  /// In ko, this message translates to:
  /// **'🔗 섹션 카운터 연동 기능'**
  String get sectionCounterLinkTitle;

  /// No description provided for @sectionCounterLinkDesc.
  ///
  /// In ko, this message translates to:
  /// **'섹션 카운터는 메인 카운터와 연동할 수 있어요. 연동하면 메인 카운터가 증가할 때 자동으로 함께 계산돼요.'**
  String get sectionCounterLinkDesc;

  /// No description provided for @tipLinkButton.
  ///
  /// In ko, this message translates to:
  /// **'💡 팁: 링크 버튼 '**
  String get tipLinkButton;

  /// No description provided for @tipLinkButtonDesc.
  ///
  /// In ko, this message translates to:
  /// **' 을 눌러서 연동을 켜거나 끌 수 있어요. 초록색이면 연동 중이에요.'**
  String get tipLinkButtonDesc;

  /// No description provided for @stitchCounterNote.
  ///
  /// In ko, this message translates to:
  /// **'참고: 코 카운터는 한 단 내에서 독립적으로 동작하므로 메인 카운터와 연동되지 않아요.'**
  String get stitchCounterNote;

  /// No description provided for @proTips.
  ///
  /// In ko, this message translates to:
  /// **'✨ 활용 팁'**
  String get proTips;

  /// No description provided for @useMemo.
  ///
  /// In ko, this message translates to:
  /// **'📝 메모를 활용하세요'**
  String get useMemo;

  /// No description provided for @useMemoDesc.
  ///
  /// In ko, this message translates to:
  /// **'각 파트마다 메모를 남길 수 있어요. \"이 구간에서 실수 많이 함\", \"다음엔 더 느슨하게\" 같은 메모를 남기면 도움이 돼요.'**
  String get useMemoDesc;

  /// No description provided for @useTags.
  ///
  /// In ko, this message translates to:
  /// **'🎨 태그로 분류하세요'**
  String get useTags;

  /// No description provided for @useTagsDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트에 태그를 추가해서 쉽게 찾을 수 있어요. \"진행중\", \"완료\", \"의류\", \"소품\" 같은 태그를 만들어보세요.'**
  String get useTagsDesc;

  /// No description provided for @takePhotos.
  ///
  /// In ko, this message translates to:
  /// **'📸 사진을 남기세요'**
  String get takePhotos;

  /// No description provided for @takePhotosDesc.
  ///
  /// In ko, this message translates to:
  /// **'완성된 작품이나 진행 중인 모습을 사진으로 남기면 나중에 다시 보는 재미가 있어요.'**
  String get takePhotosDesc;

  /// No description provided for @readyToStart.
  ///
  /// In ko, this message translates to:
  /// **'이제 시작할 준비가 되셨나요?'**
  String get readyToStart;

  /// No description provided for @startJourney.
  ///
  /// In ko, this message translates to:
  /// **'Yarnie와 함께 즐거운 뜨개질 여정을 시작해보세요!\n궁금한 점이 있으면 언제든 다시 확인하세요.'**
  String get startJourney;

  /// No description provided for @guideAgain.
  ///
  /// In ko, this message translates to:
  /// **'이 가이드는 홈 화면의 사용 가이드 카드 또는 마이 > 고객 지원에서 다시 볼 수 있어요.'**
  String get guideAgain;

  /// No description provided for @close.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// No description provided for @examplePrefix.
  ///
  /// In ko, this message translates to:
  /// **'예시: '**
  String get examplePrefix;

  /// No description provided for @knittingTip1.
  ///
  /// In ko, this message translates to:
  /// **'실 끝은 최소 10cm 남겨두면 마무리가 편해요'**
  String get knittingTip1;

  /// No description provided for @knittingTip2.
  ///
  /// In ko, this message translates to:
  /// **'게이지 샘플을 꼭 떠보세요. 프로젝트 성공의 비결이에요!'**
  String get knittingTip2;

  /// No description provided for @knittingTip3.
  ///
  /// In ko, this message translates to:
  /// **'한 코 한 코 천천히, 서두르지 마세요'**
  String get knittingTip3;

  /// No description provided for @knittingTip4.
  ///
  /// In ko, this message translates to:
  /// **'색 조합이 고민된다면 자연에서 영감을 받아보세요'**
  String get knittingTip4;

  /// No description provided for @knittingTip5.
  ///
  /// In ko, this message translates to:
  /// **'뜨개질 텐션이 너무 세면 손목이 아플 수 있어요. 편안하게!'**
  String get knittingTip5;

  /// No description provided for @knittingTip6.
  ///
  /// In ko, this message translates to:
  /// **'Yarnie의 섹션 카운터로 복잡한 패턴도 쉽게 추적할 수 있어요'**
  String get knittingTip6;

  /// No description provided for @knittingTip7.
  ///
  /// In ko, this message translates to:
  /// **'패턴을 읽을 때는 한 줄씩 체크하면서 진행하세요'**
  String get knittingTip7;

  /// No description provided for @knittingTip8.
  ///
  /// In ko, this message translates to:
  /// **'휴식을 자주 가지세요. 피로하면 실수가 늘어납니다'**
  String get knittingTip8;

  /// No description provided for @knittingTip9.
  ///
  /// In ko, this message translates to:
  /// **'바늘 사이즈가 맞는지 확인하세요. 작품의 완성도가 달라집니다'**
  String get knittingTip9;

  /// No description provided for @knittingTip10.
  ///
  /// In ko, this message translates to:
  /// **'실수를 두려워하지 마세요. 풀고 다시 뜨는 것도 연습입니다'**
  String get knittingTip10;

  /// No description provided for @welcomeUser.
  ///
  /// In ko, this message translates to:
  /// **'환영합니다! 🦎'**
  String get welcomeUser;

  /// No description provided for @helloUser.
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요! 🦎'**
  String get helloUser;

  /// No description provided for @enjoyKnitting.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 즐거운 뜨개질 하세요'**
  String get enjoyKnitting;

  /// No description provided for @startKnitting.
  ///
  /// In ko, this message translates to:
  /// **'뜨개질과 함께하는 즐거운 시간을 시작해보세요'**
  String get startKnitting;

  /// No description provided for @startFirstProject.
  ///
  /// In ko, this message translates to:
  /// **'첫 프로젝트를 시작해보세요!'**
  String get startFirstProject;

  /// No description provided for @startJourneyWithChameleon.
  ///
  /// In ko, this message translates to:
  /// **'카멜레온과 함께 뜨개질 여정을 시작해요\n한 코 한 코가 모여 멋진 작품이 됩니다'**
  String get startJourneyWithChameleon;

  /// No description provided for @createNewProject.
  ///
  /// In ko, this message translates to:
  /// **'새 프로젝트'**
  String get createNewProject;

  /// No description provided for @justNow.
  ///
  /// In ko, this message translates to:
  /// **'방금 전'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 전'**
  String minutesAgo(Object minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 전'**
  String hoursAgo(Object hours);

  /// No description provided for @daysAgo.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String daysAgo(Object days);

  /// No description provided for @weeksAgo.
  ///
  /// In ko, this message translates to:
  /// **'{weeks}주 전'**
  String weeksAgo(Object weeks);

  /// No description provided for @monthsAgo.
  ///
  /// In ko, this message translates to:
  /// **'{months}개월 전'**
  String monthsAgo(Object months);

  /// No description provided for @recentProjects.
  ///
  /// In ko, this message translates to:
  /// **'최근 작업 프로젝트'**
  String get recentProjects;

  /// No description provided for @continueWorking.
  ///
  /// In ko, this message translates to:
  /// **'이어하기'**
  String get continueWorking;

  /// No description provided for @firstTimeUsing.
  ///
  /// In ko, this message translates to:
  /// **'처음 사용하시나요?'**
  String get firstTimeUsing;

  /// No description provided for @yarnieBriefDesc.
  ///
  /// In ko, this message translates to:
  /// **'Yarnie는 프로젝트를 Part로 나누고, 각 Part마다 카운터로 진행 상황을 추적해요.'**
  String get yarnieBriefDesc;

  /// No description provided for @viewUserGuide.
  ///
  /// In ko, this message translates to:
  /// **'사용 가이드 보기'**
  String get viewUserGuide;

  /// No description provided for @knittingTips.
  ///
  /// In ko, this message translates to:
  /// **'뜨개질 팁'**
  String get knittingTips;

  /// No description provided for @knittingToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 뜨개질해볼까요?'**
  String get knittingToday;

  /// No description provided for @smallStart.
  ///
  /// In ko, this message translates to:
  /// **'작은 시작이 큰 작품을 만들어요\n지금 바로 첫 번째 코를 떠보세요!'**
  String get smallStart;

  /// No description provided for @notificationSettings.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationSettings;

  /// No description provided for @notificationSettingsSub.
  ///
  /// In ko, this message translates to:
  /// **'작업 리마인더, 배지 알림'**
  String get notificationSettingsSub;

  /// No description provided for @comingSoon.
  ///
  /// In ko, this message translates to:
  /// **'추후 제공될 기능입니다.'**
  String get comingSoon;

  /// No description provided for @darkMode.
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get darkMode;

  /// No description provided for @on.
  ///
  /// In ko, this message translates to:
  /// **'켜짐'**
  String get on;

  /// No description provided for @off.
  ///
  /// In ko, this message translates to:
  /// **'꺼짐'**
  String get off;

  /// No description provided for @customerSupport.
  ///
  /// In ko, this message translates to:
  /// **'고객 지원'**
  String get customerSupport;

  /// No description provided for @trash.
  ///
  /// In ko, this message translates to:
  /// **'휴지통'**
  String get trash;

  /// No description provided for @trashSub.
  ///
  /// In ko, this message translates to:
  /// **'삭제된 프로젝트 관리'**
  String get trashSub;

  /// No description provided for @userGuide.
  ///
  /// In ko, this message translates to:
  /// **'사용 가이드'**
  String get userGuide;

  /// No description provided for @userGuideSub.
  ///
  /// In ko, this message translates to:
  /// **'Yarnie 사용법 배우기'**
  String get userGuideSub;

  /// No description provided for @appInfo.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get appInfo;

  /// No description provided for @appVersion.
  ///
  /// In ko, this message translates to:
  /// **'버전 1.0.0'**
  String get appVersion;

  /// No description provided for @korean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @autoWithDeviceSetting.
  ///
  /// In ko, this message translates to:
  /// **'자동 (휴대폰 설정 따름)'**
  String get autoWithDeviceSetting;

  /// No description provided for @chameleonStory.
  ///
  /// In ko, this message translates to:
  /// **'카멜레온 이야기'**
  String get chameleonStory;

  /// No description provided for @chameleonStoryDesc.
  ///
  /// In ko, this message translates to:
  /// **'우리의 카멜레온 친구는 색을 변환하는 능력이 없어요. 하지만 뜨개질로 다양한 색과 무늬의 옷을 만들어 입으며 매일 새로운 모습으로 행복하게 살아가고 있답니다. 여러분도 카멜레온처럼 뜨개질과 함께 즐거운 시간을 보내세요!'**
  String get chameleonStoryDesc;

  /// No description provided for @sendFeedback.
  ///
  /// In ko, this message translates to:
  /// **'피드백 보내기'**
  String get sendFeedback;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관'**
  String get termsOfService;

  /// No description provided for @openSourceLicense.
  ///
  /// In ko, this message translates to:
  /// **'오픈소스 라이선스'**
  String get openSourceLicense;

  /// No description provided for @projects.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트'**
  String get projects;

  /// No description provided for @projectsCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개의 프로젝트'**
  String projectsCount(Object count);

  /// No description provided for @all.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get all;

  /// No description provided for @bigCard.
  ///
  /// In ko, this message translates to:
  /// **'큰 카드'**
  String get bigCard;

  /// No description provided for @smallCard.
  ///
  /// In ko, this message translates to:
  /// **'작은 카드'**
  String get smallCard;

  /// No description provided for @list.
  ///
  /// In ko, this message translates to:
  /// **'리스트'**
  String get list;

  /// No description provided for @dateDisplay.
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월 {day}일'**
  String dateDisplay(Object day, Object month, Object year);

  /// No description provided for @noProjectsYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 만든 프로젝트가 없어요.\n프로젝트를 만들어볼까요?'**
  String get noProjectsYet;

  /// No description provided for @createProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 만들기'**
  String get createProject;

  /// No description provided for @noMatchingProjects.
  ///
  /// In ko, this message translates to:
  /// **'해당하는 프로젝트가 없습니다'**
  String get noMatchingProjects;

  /// No description provided for @filterResetDesc.
  ///
  /// In ko, this message translates to:
  /// **'다른 태그를 선택하거나\n필터를 초기화해보세요'**
  String get filterResetDesc;

  /// No description provided for @resetFilter.
  ///
  /// In ko, this message translates to:
  /// **'필터 초기화'**
  String get resetFilter;

  /// No description provided for @copyProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 복사'**
  String get copyProject;

  /// No description provided for @assignTags.
  ///
  /// In ko, this message translates to:
  /// **'태그 지정'**
  String get assignTags;

  /// No description provided for @unclassified.
  ///
  /// In ko, this message translates to:
  /// **'미분류'**
  String get unclassified;

  /// No description provided for @sessionMemo.
  ///
  /// In ko, this message translates to:
  /// **'작업 메모'**
  String get sessionMemo;

  /// No description provided for @enterMemo.
  ///
  /// In ko, this message translates to:
  /// **'메모를 입력하세요...'**
  String get enterMemo;

  /// No description provided for @saveSessionConfirm.
  ///
  /// In ko, this message translates to:
  /// **'작업 시간 {time}을 저장하시겠습니까?'**
  String saveSessionConfirm(Object time);

  /// No description provided for @trashProjectCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}개의 프로젝트 · 30일 후 자동 삭제'**
  String trashProjectCount(Object count);

  /// No description provided for @loading.
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get loading;

  /// No description provided for @errorLoadingData.
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러올 수 없습니다'**
  String get errorLoadingData;

  /// No description provided for @availableAfterRestore.
  ///
  /// In ko, this message translates to:
  /// **'복원 후 이용할 수 있습니다.'**
  String get availableAfterRestore;

  /// No description provided for @errorOccurred.
  ///
  /// In ko, this message translates to:
  /// **'에러 발생: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @restore.
  ///
  /// In ko, this message translates to:
  /// **'복원하기'**
  String get restore;

  /// No description provided for @deleteForeverNow.
  ///
  /// In ko, this message translates to:
  /// **'지금 완전 삭제하기'**
  String get deleteForeverNow;

  /// No description provided for @restoreProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 복원'**
  String get restoreProject;

  /// No description provided for @restoreConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 프로젝트를 복원하시겠습니까?'**
  String get restoreConfirm;

  /// No description provided for @projectRestored.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트가 복원되었습니다.'**
  String get projectRestored;

  /// No description provided for @restoreFailed.
  ///
  /// In ko, this message translates to:
  /// **'복원 실패: {error}'**
  String restoreFailed(Object error);

  /// No description provided for @deleteForever.
  ///
  /// In ko, this message translates to:
  /// **'완전 삭제'**
  String get deleteForever;

  /// No description provided for @deleteForeverConfirm.
  ///
  /// In ko, this message translates to:
  /// **'이 프로젝트를 완전히 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'**
  String get deleteForeverConfirm;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @projectDeletedForever.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트가 완전히 삭제되었습니다.'**
  String get projectDeletedForever;

  /// No description provided for @deleteFailed.
  ///
  /// In ko, this message translates to:
  /// **'삭제 실패: {error}'**
  String deleteFailed(Object error);

  /// No description provided for @emptyTrash.
  ///
  /// In ko, this message translates to:
  /// **'휴지통이 비어있습니다'**
  String get emptyTrash;

  /// No description provided for @noDeletedProjects.
  ///
  /// In ko, this message translates to:
  /// **'삭제된 프로젝트가 없습니다'**
  String get noDeletedProjects;

  /// No description provided for @partMemo.
  ///
  /// In ko, this message translates to:
  /// **'{partName} - 메모'**
  String partMemo(Object partName);

  /// No description provided for @partMemoDesc.
  ///
  /// In ko, this message translates to:
  /// **'파트에 대한 메모를 추가하거나 수정하세요.'**
  String get partMemoDesc;

  /// No description provided for @newMemoHint.
  ///
  /// In ko, this message translates to:
  /// **'새 메모를 입력하세요...'**
  String get newMemoHint;

  /// No description provided for @addMemo.
  ///
  /// In ko, this message translates to:
  /// **'메모 추가'**
  String get addMemo;

  /// No description provided for @noMemos.
  ///
  /// In ko, this message translates to:
  /// **'등록된 메모가 없습니다.'**
  String get noMemos;

  /// No description provided for @unpin.
  ///
  /// In ko, this message translates to:
  /// **'상단 고정 해제'**
  String get unpin;

  /// No description provided for @pin.
  ///
  /// In ko, this message translates to:
  /// **'상단에 고정'**
  String get pin;

  /// No description provided for @edit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get edit;

  /// No description provided for @editMemo.
  ///
  /// In ko, this message translates to:
  /// **'메모 수정'**
  String get editMemo;

  /// No description provided for @editMainCount.
  ///
  /// In ko, this message translates to:
  /// **'메인카운트 값 편집'**
  String get editMainCount;

  /// No description provided for @editMainCountDesc.
  ///
  /// In ko, this message translates to:
  /// **'현재 카운트 값을 직접 수정하거나 초기화할 수 있습니다'**
  String get editMainCountDesc;

  /// No description provided for @currentCount.
  ///
  /// In ko, this message translates to:
  /// **'현재 카운트'**
  String get currentCount;

  /// No description provided for @resetToOne.
  ///
  /// In ko, this message translates to:
  /// **'1로 초기화'**
  String get resetToOne;

  /// No description provided for @rangeCounterLabel.
  ///
  /// In ko, this message translates to:
  /// **'범위 카운터'**
  String get rangeCounterLabel;

  /// No description provided for @editRangeCounter.
  ///
  /// In ko, this message translates to:
  /// **'범위 카운터 수정'**
  String get editRangeCounter;

  /// No description provided for @addRangeCounter.
  ///
  /// In ko, this message translates to:
  /// **'범위 카운터 추가'**
  String get addRangeCounter;

  /// No description provided for @rangeCounterDescSimple.
  ///
  /// In ko, this message translates to:
  /// **'특정 행 범위를 추적하는 카운터입니다.'**
  String get rangeCounterDescSimple;

  /// No description provided for @startRow.
  ///
  /// In ko, this message translates to:
  /// **'시작 행'**
  String get startRow;

  /// No description provided for @totalRows.
  ///
  /// In ko, this message translates to:
  /// **'총 행 수'**
  String get totalRows;

  /// No description provided for @rowsHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 50'**
  String get rowsHint;

  /// No description provided for @rowsHelper.
  ///
  /// In ko, this message translates to:
  /// **'시작 행부터 몇 행 동안 추적할지 입력하세요.'**
  String get rowsHelper;

  /// No description provided for @add.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get add;

  /// No description provided for @label.
  ///
  /// In ko, this message translates to:
  /// **'라벨'**
  String get label;

  /// No description provided for @labelHint.
  ///
  /// In ko, this message translates to:
  /// **'어떤 카운터인지 알아보기 쉽게 라벨을 입력해보세요'**
  String get labelHint;

  /// No description provided for @tagSelection.
  ///
  /// In ko, this message translates to:
  /// **'태그 선택'**
  String get tagSelection;

  /// No description provided for @complete.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get complete;

  /// No description provided for @searchTags.
  ///
  /// In ko, this message translates to:
  /// **'태그 검색...'**
  String get searchTags;

  /// No description provided for @addNewTag.
  ///
  /// In ko, this message translates to:
  /// **'새 태그 추가'**
  String get addNewTag;

  /// No description provided for @tagName.
  ///
  /// In ko, this message translates to:
  /// **'태그 이름'**
  String get tagName;

  /// No description provided for @editTag.
  ///
  /// In ko, this message translates to:
  /// **'태그 수정'**
  String get editTag;

  /// No description provided for @shapingCounterLabel.
  ///
  /// In ko, this message translates to:
  /// **'증감 카운터'**
  String get shapingCounterLabel;

  /// No description provided for @editShapingCounter.
  ///
  /// In ko, this message translates to:
  /// **'증감 카운터 수정'**
  String get editShapingCounter;

  /// No description provided for @addShapingCounter.
  ///
  /// In ko, this message translates to:
  /// **'증감 카운터 추가'**
  String get addShapingCounter;

  /// No description provided for @shapingCounterDescSimple.
  ///
  /// In ko, this message translates to:
  /// **'코를 늘리거나 줄이는 작업을 추적하는 카운터입니다.'**
  String get shapingCounterDescSimple;

  /// No description provided for @intervalRows.
  ///
  /// In ko, this message translates to:
  /// **'간격 (행)'**
  String get intervalRows;

  /// No description provided for @intervalHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 2'**
  String get intervalHint;

  /// No description provided for @totalTimes.
  ///
  /// In ko, this message translates to:
  /// **'총 횟수'**
  String get totalTimes;

  /// No description provided for @timesHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 10'**
  String get timesHint;

  /// No description provided for @stitchChange.
  ///
  /// In ko, this message translates to:
  /// **'코 수 변화 (회당)'**
  String get stitchChange;

  /// No description provided for @stitchChangeHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 2 또는 -2'**
  String get stitchChangeHint;

  /// No description provided for @stitchChangeHelper.
  ///
  /// In ko, this message translates to:
  /// **'양수는 코 늘림, 음수는 코 줄임입니다.'**
  String get stitchChangeHelper;

  /// No description provided for @intervalCounterLabel.
  ///
  /// In ko, this message translates to:
  /// **'간격 카운터'**
  String get intervalCounterLabel;

  /// No description provided for @editIntervalCounter.
  ///
  /// In ko, this message translates to:
  /// **'간격 카운터 수정'**
  String get editIntervalCounter;

  /// No description provided for @addIntervalCounter.
  ///
  /// In ko, this message translates to:
  /// **'간격 카운터 추가'**
  String get addIntervalCounter;

  /// No description provided for @intervalCounterDescSimple.
  ///
  /// In ko, this message translates to:
  /// **'일정한 간격으로 작업을 반복할 때 사용하는 카운터입니다.'**
  String get intervalCounterDescSimple;

  /// No description provided for @intervalTimesHelper.
  ///
  /// In ko, this message translates to:
  /// **'간격과 총 횟수를 입력하세요.'**
  String get intervalTimesHelper;

  /// No description provided for @colorOption.
  ///
  /// In ko, this message translates to:
  /// **'배색 옵션'**
  String get colorOption;

  /// No description provided for @colorOptionDesc.
  ///
  /// In ko, this message translates to:
  /// **'배색 추적이 필요한 경우 사용할 색상을 순서대로 선택하세요'**
  String get colorOptionDesc;

  /// No description provided for @editStitchCounter.
  ///
  /// In ko, this message translates to:
  /// **'스티치 카운터 수정'**
  String get editStitchCounter;

  /// No description provided for @editCounterInfo.
  ///
  /// In ko, this message translates to:
  /// **'카운터 정보를 수정합니다.'**
  String get editCounterInfo;

  /// No description provided for @currentValue.
  ///
  /// In ko, this message translates to:
  /// **'현재 값'**
  String get currentValue;

  /// No description provided for @countUnit.
  ///
  /// In ko, this message translates to:
  /// **'증감 단위'**
  String get countUnit;

  /// No description provided for @repeatCounterLabel.
  ///
  /// In ko, this message translates to:
  /// **'반복 카운터'**
  String get repeatCounterLabel;

  /// No description provided for @editRepeatCounter.
  ///
  /// In ko, this message translates to:
  /// **'반복 카운터 수정'**
  String get editRepeatCounter;

  /// No description provided for @addRepeatCounter.
  ///
  /// In ko, this message translates to:
  /// **'반복 카운터 추가'**
  String get addRepeatCounter;

  /// No description provided for @repeatCounterDescSimple.
  ///
  /// In ko, this message translates to:
  /// **'특정 패턴을 반복할 때 사용하는 카운터입니다.'**
  String get repeatCounterDescSimple;

  /// No description provided for @repeatUnit.
  ///
  /// In ko, this message translates to:
  /// **'반복 단위 (행)'**
  String get repeatUnit;

  /// No description provided for @repeatUnitHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 4'**
  String get repeatUnitHint;

  /// No description provided for @repeatTimes.
  ///
  /// In ko, this message translates to:
  /// **'반복 횟수'**
  String get repeatTimes;

  /// No description provided for @repeatHelper.
  ///
  /// In ko, this message translates to:
  /// **'패턴의 반복 단위와 횟수를 입력하세요.'**
  String get repeatHelper;

  /// No description provided for @deleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'을 삭제하시겠습니까?'**
  String get deleteConfirm;

  /// No description provided for @deleteDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트는 휴지통으로 이동되며,\n30일 후 자동으로 영구 삭제됩니다.'**
  String get deleteDesc;

  /// No description provided for @achieved.
  ///
  /// In ko, this message translates to:
  /// **'달성 완료 ✓'**
  String get achieved;

  /// No description provided for @remainingLength.
  ///
  /// In ko, this message translates to:
  /// **'남은 길이'**
  String get remainingLength;

  /// No description provided for @stitchIncrease.
  ///
  /// In ko, this message translates to:
  /// **'코 늘림'**
  String get stitchIncrease;

  /// No description provided for @stitchDecrease.
  ///
  /// In ko, this message translates to:
  /// **'코 줄임'**
  String get stitchDecrease;

  /// No description provided for @nextRow.
  ///
  /// In ko, this message translates to:
  /// **'다음:{row}행'**
  String nextRow(Object row);

  /// No description provided for @patternRows.
  ///
  /// In ko, this message translates to:
  /// **'{current}/{total}행 ({total}행 패턴)'**
  String patternRows(Object current, Object total);

  /// No description provided for @fromRow.
  ///
  /// In ko, this message translates to:
  /// **'{row}행부터'**
  String fromRow(Object row);

  /// No description provided for @stitch.
  ///
  /// In ko, this message translates to:
  /// **'코'**
  String get stitch;

  /// No description provided for @increaseBy.
  ///
  /// In ko, this message translates to:
  /// **'+{n}씩'**
  String increaseBy(Object n);

  /// No description provided for @manualInput.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력...'**
  String get manualInput;

  /// No description provided for @setIncreaseValue.
  ///
  /// In ko, this message translates to:
  /// **'증가값 설정'**
  String get setIncreaseValue;

  /// No description provided for @setIncreaseValueDesc.
  ///
  /// In ko, this message translates to:
  /// **'한 번에 증가시킬 코 수를 입력하세요.'**
  String get setIncreaseValueDesc;

  /// No description provided for @increaseValue.
  ///
  /// In ko, this message translates to:
  /// **'증가값'**
  String get increaseValue;

  /// No description provided for @increaseValueHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 6'**
  String get increaseValueHint;

  /// No description provided for @confirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get confirm;

  /// No description provided for @exitConfirm.
  ///
  /// In ko, this message translates to:
  /// **'한 번 더 누르면 종료됩니다.'**
  String get exitConfirm;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// No description provided for @selectCounterType.
  ///
  /// In ko, this message translates to:
  /// **'카운터 유형 선택'**
  String get selectCounterType;

  /// No description provided for @stitchCounter.
  ///
  /// In ko, this message translates to:
  /// **'스티치 카운터'**
  String get stitchCounter;

  /// No description provided for @independentCounter.
  ///
  /// In ko, this message translates to:
  /// **'독립적인 숫자 카운터'**
  String get independentCounter;

  /// No description provided for @sectionCounter.
  ///
  /// In ko, this message translates to:
  /// **'섹션 카운터'**
  String get sectionCounter;

  /// No description provided for @range.
  ///
  /// In ko, this message translates to:
  /// **'범위 (Range)'**
  String get range;

  /// No description provided for @repeat.
  ///
  /// In ko, this message translates to:
  /// **'반복 (Repeat)'**
  String get repeat;

  /// No description provided for @interval.
  ///
  /// In ko, this message translates to:
  /// **'간격 (Interval)'**
  String get interval;

  /// No description provided for @shaping.
  ///
  /// In ko, this message translates to:
  /// **'증감 (Shaping)'**
  String get shaping;

  /// No description provided for @length.
  ///
  /// In ko, this message translates to:
  /// **'길이 (Length)'**
  String get length;

  /// No description provided for @addLengthCounter.
  ///
  /// In ko, this message translates to:
  /// **'길이 카운터 추가'**
  String get addLengthCounter;

  /// No description provided for @editLengthCounter.
  ///
  /// In ko, this message translates to:
  /// **'길이 카운터 수정'**
  String get editLengthCounter;

  /// No description provided for @lengthCounterDescSimple.
  ///
  /// In ko, this message translates to:
  /// **'특정 길이에 도달할 때까지 추적하는 카운터입니다.'**
  String get lengthCounterDescSimple;

  /// No description provided for @targetLength.
  ///
  /// In ko, this message translates to:
  /// **'목표 길이'**
  String get targetLength;

  /// No description provided for @lengthHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 30.0'**
  String get lengthHint;

  /// No description provided for @lengthHelper.
  ///
  /// In ko, this message translates to:
  /// **'목표로 하는 길이를 입력하세요.'**
  String get lengthHelper;

  /// No description provided for @unit.
  ///
  /// In ko, this message translates to:
  /// **'단위'**
  String get unit;

  /// No description provided for @cm.
  ///
  /// In ko, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @inch.
  ///
  /// In ko, this message translates to:
  /// **'inch'**
  String get inch;

  /// No description provided for @countBySetting.
  ///
  /// In ko, this message translates to:
  /// **'Count By 설정'**
  String get countBySetting;

  /// No description provided for @lengthMeasurement.
  ///
  /// In ko, this message translates to:
  /// **'길이 측정'**
  String get lengthMeasurement;

  /// No description provided for @targetInfoLength.
  ///
  /// In ko, this message translates to:
  /// **'목표 {length}cm'**
  String targetInfoLength(Object length);

  /// No description provided for @editLengthCounterTitle.
  ///
  /// In ko, this message translates to:
  /// **'길이 측정 카운터 수정'**
  String get editLengthCounterTitle;

  /// No description provided for @addLengthCounterTitle.
  ///
  /// In ko, this message translates to:
  /// **'길이 측정 카운터 추가'**
  String get addLengthCounterTitle;

  /// No description provided for @startStitch.
  ///
  /// In ko, this message translates to:
  /// **'시작 단'**
  String get startStitch;

  /// No description provided for @targetLengthCm.
  ///
  /// In ko, this message translates to:
  /// **'목표 길이 (cm)'**
  String get targetLengthCm;

  /// No description provided for @targetLengthHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 25.0'**
  String get targetLengthHint;

  /// No description provided for @rowHeightCm.
  ///
  /// In ko, this message translates to:
  /// **'1단의 높이 (cm)'**
  String get rowHeightCm;

  /// No description provided for @rowHeightHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 0.33'**
  String get rowHeightHint;

  /// No description provided for @rowHeightDesc.
  ///
  /// In ko, this message translates to:
  /// **'뜨개질 샘플에서 1단의 높이를 측정하거나, 저장된 게이지 정보로부터 계산할 수 있어요'**
  String get rowHeightDesc;

  /// No description provided for @gaugeInputComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'게이지 입력 기능 준비 중'**
  String get gaugeInputComingSoon;

  /// No description provided for @goToGaugeInput.
  ///
  /// In ko, this message translates to:
  /// **'게이지 입력하러 가기'**
  String get goToGaugeInput;

  /// No description provided for @expectedRows.
  ///
  /// In ko, this message translates to:
  /// **'예상 필요 단수'**
  String get expectedRows;

  /// No description provided for @estimatedRowsDisplay.
  ///
  /// In ko, this message translates to:
  /// **'{rows}단'**
  String estimatedRowsDisplay(Object rows);

  /// No description provided for @changeTargetRow.
  ///
  /// In ko, this message translates to:
  /// **'목표 단수 변경'**
  String get changeTargetRow;

  /// No description provided for @removeTargetRow.
  ///
  /// In ko, this message translates to:
  /// **'목표 단수 해제'**
  String get removeTargetRow;

  /// No description provided for @editLogMemo.
  ///
  /// In ko, this message translates to:
  /// **'log {no} 메모 편집'**
  String editLogMemo(Object no);

  /// No description provided for @memoRemoved.
  ///
  /// In ko, this message translates to:
  /// **'메모가 제거되었습니다'**
  String get memoRemoved;

  /// No description provided for @memoSaved.
  ///
  /// In ko, this message translates to:
  /// **'메모가 저장되었습니다'**
  String get memoSaved;

  /// No description provided for @memoUpdateFailed.
  ///
  /// In ko, this message translates to:
  /// **'메모 업데이트 실패: {error}'**
  String memoUpdateFailed(Object error);

  /// No description provided for @labelRemoved.
  ///
  /// In ko, this message translates to:
  /// **'라벨이 제거되었습니다'**
  String get labelRemoved;

  /// No description provided for @labelChanged.
  ///
  /// In ko, this message translates to:
  /// **'라벨이 \"{label}\"로 변경되었습니다'**
  String labelChanged(Object label);

  /// No description provided for @labelUpdateFailed.
  ///
  /// In ko, this message translates to:
  /// **'라벨 업데이트 실패: {error}'**
  String labelUpdateFailed(Object error);

  /// No description provided for @more.
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get more;

  /// No description provided for @fold.
  ///
  /// In ko, this message translates to:
  /// **'접기'**
  String get fold;

  /// No description provided for @setTargetRow.
  ///
  /// In ko, this message translates to:
  /// **'목표 단수 설정'**
  String get setTargetRow;

  /// No description provided for @setTargetRowDesc.
  ///
  /// In ko, this message translates to:
  /// **'완료하고자 하는 총 단수를 입력하세요'**
  String get setTargetRowDesc;

  /// No description provided for @targetRow.
  ///
  /// In ko, this message translates to:
  /// **'목표 단수'**
  String get targetRow;

  /// No description provided for @manageParts.
  ///
  /// In ko, this message translates to:
  /// **'Part 관리'**
  String get manageParts;

  /// No description provided for @managePartsDesc.
  ///
  /// In ko, this message translates to:
  /// **'Part 이름을 길게 눌러 수정하거나, 왼쪽 아이콘을 드래그하여 순서를 변경하세요.'**
  String get managePartsDesc;

  /// No description provided for @noParts.
  ///
  /// In ko, this message translates to:
  /// **'등록된 Part가 없습니다.'**
  String get noParts;

  /// No description provided for @editName.
  ///
  /// In ko, this message translates to:
  /// **'이름 수정'**
  String get editName;

  /// No description provided for @deletePart.
  ///
  /// In ko, this message translates to:
  /// **'Part 삭제'**
  String get deletePart;

  /// No description provided for @deletePartConfirm.
  ///
  /// In ko, this message translates to:
  /// **'\'{name}\' Part를 삭제하시겠습니까?\n이 Part에 속한 모든 카운터, 세션 기록, 메모가 함께 삭제됩니다.'**
  String deletePartConfirm(Object name);

  /// No description provided for @duplicatePartName.
  ///
  /// In ko, this message translates to:
  /// **'이미 존재하는 파트 이름입니다.'**
  String get duplicatePartName;

  /// No description provided for @newPartName.
  ///
  /// In ko, this message translates to:
  /// **'새 Part 이름'**
  String get newPartName;

  /// No description provided for @rowHeightError.
  ///
  /// In ko, this message translates to:
  /// **'1단의 높이는 목표 길이보다 작아야 합니다.'**
  String get rowHeightError;

  /// No description provided for @projectInfo.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 정보'**
  String get projectInfo;

  /// No description provided for @projectDelete.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 삭제'**
  String get projectDelete;

  /// No description provided for @newPartTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 파트'**
  String get newPartTitle;

  /// No description provided for @addPartDesc.
  ///
  /// In ko, this message translates to:
  /// **'파트를 추가해주세요'**
  String get addPartDesc;

  /// No description provided for @newPartAdd.
  ///
  /// In ko, this message translates to:
  /// **'새 파트 추가'**
  String get newPartAdd;

  /// No description provided for @partNameHint.
  ///
  /// In ko, this message translates to:
  /// **'파트 이름 (예: 앞판, 소매)'**
  String get partNameHint;

  /// No description provided for @session.
  ///
  /// In ko, this message translates to:
  /// **'세션'**
  String get session;

  /// No description provided for @rowsRemaining.
  ///
  /// In ko, this message translates to:
  /// **'{count}줄 남음'**
  String rowsRemaining(Object count);

  /// No description provided for @editProject.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 수정'**
  String get editProject;

  /// No description provided for @newProject.
  ///
  /// In ko, this message translates to:
  /// **'새 프로젝트'**
  String get newProject;

  /// No description provided for @editProjectDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 정보를 수정해주세요'**
  String get editProjectDesc;

  /// No description provided for @newProjectDesc.
  ///
  /// In ko, this message translates to:
  /// **'새로운 프로젝트 정보를 입력해주세요'**
  String get newProjectDesc;

  /// No description provided for @projectName.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트명'**
  String get projectName;

  /// No description provided for @projectNameHint.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 이름을 입력하세요'**
  String get projectNameHint;

  /// No description provided for @needleType.
  ///
  /// In ko, this message translates to:
  /// **'바늘 종류'**
  String get needleType;

  /// No description provided for @knittingNeedle.
  ///
  /// In ko, this message translates to:
  /// **'대바늘'**
  String get knittingNeedle;

  /// No description provided for @crochetNeedle.
  ///
  /// In ko, this message translates to:
  /// **'코바늘'**
  String get crochetNeedle;

  /// No description provided for @needleTypeHint.
  ///
  /// In ko, this message translates to:
  /// **'바늘 종류를 선택하세요'**
  String get needleTypeHint;

  /// No description provided for @needleSize.
  ///
  /// In ko, this message translates to:
  /// **'바늘 사이즈'**
  String get needleSize;

  /// No description provided for @needleSizeHint.
  ///
  /// In ko, this message translates to:
  /// **'먼저 바늘 종류를 선택하세요'**
  String get needleSizeHint;

  /// No description provided for @lotNumberHint.
  ///
  /// In ko, this message translates to:
  /// **'예: A12345'**
  String get lotNumberHint;

  /// No description provided for @lotNumberDesc.
  ///
  /// In ko, this message translates to:
  /// **'실의 로트 번호를 입력하세요'**
  String get lotNumberDesc;

  /// No description provided for @memoHint.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트에 대한 메모를 작성하세요\n예: 실 종류, 색상, 패턴 정보 등'**
  String get memoHint;

  /// No description provided for @tagAdd.
  ///
  /// In ko, this message translates to:
  /// **'태그 추가'**
  String get tagAdd;

  /// No description provided for @gauge.
  ///
  /// In ko, this message translates to:
  /// **'게이지'**
  String get gauge;

  /// No description provided for @gaugeDesc.
  ///
  /// In ko, this message translates to:
  /// **'10cm x 10cm 안에 몇 코, 몇 단인가요?'**
  String get gaugeDesc;

  /// No description provided for @stitchesHint.
  ///
  /// In ko, this message translates to:
  /// **'코 수'**
  String get stitchesHint;

  /// No description provided for @stitchesUnit.
  ///
  /// In ko, this message translates to:
  /// **'코'**
  String get stitchesUnit;

  /// No description provided for @rowsHintGauge.
  ///
  /// In ko, this message translates to:
  /// **'단 수'**
  String get rowsHintGauge;

  /// No description provided for @rowsUnit.
  ///
  /// In ko, this message translates to:
  /// **'단'**
  String get rowsUnit;

  /// No description provided for @editComplete.
  ///
  /// In ko, this message translates to:
  /// **'수정 완료'**
  String get editComplete;

  /// No description provided for @addComplete.
  ///
  /// In ko, this message translates to:
  /// **'추가 완료'**
  String get addComplete;

  /// No description provided for @addImage.
  ///
  /// In ko, this message translates to:
  /// **'이미지 추가'**
  String get addImage;

  /// No description provided for @imageSourceDesc.
  ///
  /// In ko, this message translates to:
  /// **'사진을 촬영하거나 갤러리에서 선택하세요.'**
  String get imageSourceDesc;

  /// No description provided for @cameraShot.
  ///
  /// In ko, this message translates to:
  /// **'카메라로 촬영'**
  String get cameraShot;

  /// No description provided for @gallerySelect.
  ///
  /// In ko, this message translates to:
  /// **'갤러리에서 선택'**
  String get gallerySelect;

  /// No description provided for @projectImage.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 이미지'**
  String get projectImage;

  /// No description provided for @reset.
  ///
  /// In ko, this message translates to:
  /// **'초기화'**
  String get reset;

  /// No description provided for @change.
  ///
  /// In ko, this message translates to:
  /// **'변경'**
  String get change;

  /// No description provided for @memo.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get memo;

  /// No description provided for @tag.
  ///
  /// In ko, this message translates to:
  /// **'태그'**
  String get tag;

  /// No description provided for @paused.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get paused;

  /// No description provided for @start.
  ///
  /// In ko, this message translates to:
  /// **'시작'**
  String get start;

  /// No description provided for @projectInfoDesc.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트의 상세 정보를 확인하세요'**
  String get projectInfoDesc;

  /// No description provided for @lotNumberLabel.
  ///
  /// In ko, this message translates to:
  /// **'실 로트 번호'**
  String get lotNumberLabel;

  /// No description provided for @noTagsAssigned.
  ///
  /// In ko, this message translates to:
  /// **'지정된 태그가 없습니다.'**
  String get noTagsAssigned;

  /// No description provided for @noGaugeInfo.
  ///
  /// In ko, this message translates to:
  /// **'게이지 정보 없음'**
  String get noGaugeInfo;

  /// No description provided for @noMemoInfo.
  ///
  /// In ko, this message translates to:
  /// **'메모 없음'**
  String get noMemoInfo;

  /// No description provided for @createdAtLabel.
  ///
  /// In ko, this message translates to:
  /// **'생성일'**
  String get createdAtLabel;

  /// No description provided for @updatedAtLabel.
  ///
  /// In ko, this message translates to:
  /// **'최근 수정'**
  String get updatedAtLabel;

  /// No description provided for @gaugeStandard.
  ///
  /// In ko, this message translates to:
  /// **'(10cm x 10cm 기준)'**
  String get gaugeStandard;

  /// No description provided for @noCounters.
  ///
  /// In ko, this message translates to:
  /// **'카운터가 없습니다.'**
  String get noCounters;

  /// No description provided for @addCounterGuide.
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼을 눌러 추가해보세요.'**
  String get addCounterGuide;

  /// No description provided for @completeWithEmoji.
  ///
  /// In ko, this message translates to:
  /// **'{name} 완료! 🎉'**
  String completeWithEmoji(Object name);

  /// No description provided for @viewDetails.
  ///
  /// In ko, this message translates to:
  /// **'상세 보기'**
  String get viewDetails;

  /// No description provided for @editLabel.
  ///
  /// In ko, this message translates to:
  /// **'라벨 수정'**
  String get editLabel;

  /// No description provided for @selectLabel.
  ///
  /// In ko, this message translates to:
  /// **'라벨 선택'**
  String get selectLabel;

  /// No description provided for @manageLabels.
  ///
  /// In ko, this message translates to:
  /// **'라벨 관리'**
  String get manageLabels;

  /// No description provided for @addLabel.
  ///
  /// In ko, this message translates to:
  /// **'라벨 추가'**
  String get addLabel;

  /// No description provided for @activeSessionExists.
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 세션이 있습니다'**
  String get activeSessionExists;

  /// No description provided for @resume.
  ///
  /// In ko, this message translates to:
  /// **'이어하기'**
  String get resume;

  /// No description provided for @startNew.
  ///
  /// In ko, this message translates to:
  /// **'새로 시작'**
  String get startNew;

  /// No description provided for @activeSession.
  ///
  /// In ko, this message translates to:
  /// **'진행 중 세션'**
  String get activeSession;

  /// No description provided for @activeSessionQuestion.
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 세션이 있습니다. 이어서 하시겠습니까?'**
  String get activeSessionQuestion;

  /// No description provided for @dbDuplicateError.
  ///
  /// In ko, this message translates to:
  /// **'중복된 값이 존재합니다'**
  String get dbDuplicateError;

  /// No description provided for @dbForeignKeyError.
  ///
  /// In ko, this message translates to:
  /// **'참조하는 레코드가 존재하지 않습니다'**
  String get dbForeignKeyError;

  /// No description provided for @dbRequiredError.
  ///
  /// In ko, this message translates to:
  /// **'필수 값이 누락되었습니다'**
  String get dbRequiredError;

  /// No description provided for @dbIntegrityError.
  ///
  /// In ko, this message translates to:
  /// **'데이터 무결성 위반'**
  String get dbIntegrityError;

  /// No description provided for @dbConstraintError.
  ///
  /// In ko, this message translates to:
  /// **'데이터 제약 조건을 위반했습니다'**
  String get dbConstraintError;

  /// No description provided for @dbGeneralError.
  ///
  /// In ko, this message translates to:
  /// **'데이터베이스 오류가 발생했습니다'**
  String get dbGeneralError;

  /// No description provided for @dbRecordNotFoundError.
  ///
  /// In ko, this message translates to:
  /// **'기록을 찾을 수 없습니다'**
  String get dbRecordNotFoundError;

  /// No description provided for @defaultLabelSleeves.
  ///
  /// In ko, this message translates to:
  /// **'소매'**
  String get defaultLabelSleeves;

  /// No description provided for @defaultLabelBody.
  ///
  /// In ko, this message translates to:
  /// **'몸통'**
  String get defaultLabelBody;

  /// No description provided for @defaultLabelNeckline.
  ///
  /// In ko, this message translates to:
  /// **'목둘레'**
  String get defaultLabelNeckline;

  /// No description provided for @userGuideJourney.
  ///
  /// In ko, this message translates to:
  /// **'Yarnie와 함께하는 뜨개질 여정'**
  String get userGuideJourney;

  /// No description provided for @trashHeader.
  ///
  /// In ko, this message translates to:
  /// **'휴지통'**
  String get trashHeader;

  /// No description provided for @trashProjectCountInfo.
  ///
  /// In ko, this message translates to:
  /// **'{count}개의 프로젝트 · 30일 후 자동 삭제'**
  String trashProjectCountInfo(Object count);

  /// No description provided for @restoreProjectTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 복원'**
  String get restoreProjectTitle;

  /// No description provided for @restoreConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 프로젝트를 복원하시겠습니까?'**
  String get restoreConfirmMessage;

  /// No description provided for @projectRestoredMessage.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트가 복원되었습니다.'**
  String get projectRestoredMessage;

  /// No description provided for @deleteForeverTitle.
  ///
  /// In ko, this message translates to:
  /// **'완전 삭제'**
  String get deleteForeverTitle;

  /// No description provided for @deleteForeverConfirmMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 프로젝트를 완전히 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'**
  String get deleteForeverConfirmMessage;

  /// No description provided for @mainCounterTitleAlt.
  ///
  /// In ko, this message translates to:
  /// **'메인 카운터 (MainCounter)'**
  String get mainCounterTitleAlt;

  /// No description provided for @countByLabel.
  ///
  /// In ko, this message translates to:
  /// **'count by {value}'**
  String countByLabel(Object value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
