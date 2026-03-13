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
  /// **'+ 새 파트'**
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
  /// **'특정 길이에 도달할 때까지 작업을 추적해요.'**
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
  /// **'새 프로젝트 시작하기'**
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
  /// **'메모를 입력하세요'**
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
