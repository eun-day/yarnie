// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get auto => '자동';

  @override
  String get preferencesTitle => '환경 설정';

  @override
  String get preferencesSubtitle => '앱 사용 환경을 설정하세요';

  @override
  String get language => '언어';

  @override
  String get lengthUnit => '길이 단위';

  @override
  String get dataManage => '데이터 관리';

  @override
  String get sessionSetting => '작업 중 설정';

  @override
  String get touchFeedback => '터치 피드백';

  @override
  String get languageCurrentKorean => '자동 (현재: 한국어)';

  @override
  String get languageSub => '자동을 선택하면 휴대폰 언어 설정을 따릅니다';

  @override
  String get lengthCm => '센티미터 (cm)';

  @override
  String get lengthInch => '인치 (inch)';

  @override
  String get lengthSub => '바늘 사이즈, 길이 측정 등에 적용됩니다';

  @override
  String get autoBackup => '자동 백업';

  @override
  String get autoBackupSub => '매일 자동으로 데이터 백업';

  @override
  String get exportData => '데이터 내보내기';

  @override
  String get exportDataSub => '모든 프로젝트를 JSON 파일로 저장';

  @override
  String get importData => '데이터 가져오기';

  @override
  String get importDataSub => '백업 파일에서 복원하기';

  @override
  String get screenAwake => '화면 꺼짐 방지';

  @override
  String get screenAwakeSub => '작업 중 화면이 꺼지지 않음';

  @override
  String get touchFeedbackSub => '카운터 버튼을 누를 때 피드백을 받을 수 있어요';

  @override
  String get vibrate => '진동';

  @override
  String get sound => '소리';

  @override
  String get both => '둘 다';

  @override
  String get none => '없음';

  @override
  String get my => '마이';

  @override
  String get mySubtitle => '언어, 단위, 백업';

  @override
  String get settings => '설정';

  @override
  String get welcome => 'Yarnie에 오신 것을 환영해요!';

  @override
  String get welcomeDesc =>
      'Yarnie는 뜨개질 프로젝트를 체계적으로 관리하고\n진행 상황을 쉽게 추적할 수 있도록 도와드려요';

  @override
  String get tabsConfigTitle => '📱 3개의 탭으로 구성되어 있어요';

  @override
  String get homeTab => '홈 탭';

  @override
  String get homeTabDesc =>
      '진행 중인 작업을 빠르게 확인하고 이어서 작업할 수 있어요. 활동 기록과 배지도 여기서 확인해요.';

  @override
  String get projectsTab => '프로젝트 탭';

  @override
  String get projectsTabDesc =>
      '모든 프로젝트를 관리하는 곳이에요. 대형 갤러리, 소형 갤러리, 리스트 보기로 전환할 수 있고, 최근 작업순, 최신순, 오래된순, 이름순으로 정렬할 수 있어요.';

  @override
  String get myTab => '마이 탭';

  @override
  String get myTabDesc => '태그 관리, 휴지통, 설정 등 부가 기능을 사용할 수 있어요.';

  @override
  String get tagFiltering => '태그 필터링';

  @override
  String get tagFilteringDesc =>
      '프로젝트 탭에서 태그를 선택하면 해당 태그가 붙은 프로젝트만 볼 수 있어요. 여러 개의 태그를 동시에 선택하면 모든 태그를 가진 프로젝트만 표시돼요.';

  @override
  String get createProjectTitle => '🎯 프로젝트 만들기';

  @override
  String get createProjectDesc =>
      '프로젝트는 하나의 완성된 작품을 의미해요. 예를 들어 \"겨울 스웨터\", \"아기 담요\", \"양말\" 같은 거예요.';

  @override
  String get createProjectGuide1 => '프로젝트 탭에서 ';

  @override
  String get createProjectGuide2 => '+ 새 프로젝트';

  @override
  String get createProjectGuide3 => ' 버튼을 눌러요';

  @override
  String get createProjectGuide4 => '프로젝트 이름, 바늘 정보, 사진 등을 입력해요';

  @override
  String get createProjectGuide5 => '태그를 추가해서 분류할 수 있어요 (선택사항)';

  @override
  String get splitPartTitle => '🧩 Part로 나누기';

  @override
  String get splitPartDesc =>
      '프로젝트는 여러 Part로 나눌 수 있어요. 각 Part는 독립적으로 작업을 진행할 수 있어요.';

  @override
  String get sweaterExample => '예시: 스웨터 프로젝트';

  @override
  String get frontPanel => '앞판';

  @override
  String get backPanel => '뒷판';

  @override
  String get leftSleeve => '왼쪽 소매';

  @override
  String get rightSleeve => '오른쪽 소매';

  @override
  String get neckline => '목둘레';

  @override
  String get addPartMethod => 'Part 추가 방법';

  @override
  String get addPartMethodDesc => '프로젝트 상세 화면에서 왼쪽 상단의';

  @override
  String get newPart => '+ 새 파트';

  @override
  String get addPartMethodSuffix => '\n버튼을 누르면 새로운 Part를 추가할 수 있어요.';

  @override
  String get counterSystemTitle => '🔢 카운터 시스템';

  @override
  String get counterSystemDesc =>
      '각 Part는 카운터로 진행 상황을 추적해요.\nMainCounter 1개와 여러 개의 BuddyCounter를 가질 수 있어요.';

  @override
  String get mainCounterTitle => '메인 카운터 (MainCounter)';

  @override
  String get mainCounterDesc => '단수를 세는 기본 카운터예요. 한 번 탭하면 1단씩 증가해요.';

  @override
  String get tip => '💡 팁:';

  @override
  String get mainCounterTip =>
      ' 목표 단수를 설정하면 진행률을 확인할 수 있어요. 예를 들어 100단을 목표로 설정하면 현재 몇 %까지 진행했는지 알 수 있어요.';

  @override
  String get buddyCounterTitle => '보조 카운터 (BuddyCounter)';

  @override
  String get buddyCounterDesc =>
      '메인 카운터와 함께 사용하는 보조 카운터예요. 코 카운터와 섹션 카운터가 있어요.';

  @override
  String get stitchCounterTitle => '코 카운터 (Stitch Counter)';

  @override
  String get stitchCounterDesc =>
      '한 단 내에서 코 수를 세는 독립적인 카운터예요. 메인 카운터와 연동되지 않아요.';

  @override
  String get whenToUse => '언제 사용하나요?';

  @override
  String get stitchCounterUsage1 => '• 복잡한 패턴에서 현재 어느 코까지 작업했는지 추적';

  @override
  String get stitchCounterUsage2 => '• 늘림/줄임 작업할 때 정확한 코 수 확인';

  @override
  String get stitchCounterUsage3 => '• 케이블이나 레이스 패턴의 반복 구간 세기';

  @override
  String get sectionCounterTitle => '섹션 카운터 (Section Counter)';

  @override
  String get sectionCounterDesc =>
      '메인 카운터와 연동되어 특정 구간이나 패턴을 추적하는 카운터예요. 5가지 유형이 있어요.';

  @override
  String get mainCounterLink => '🔗 메인 카운터 연동';

  @override
  String get mainCounterLinkDesc =>
      '링크 버튼을 켜면 메인 카운터가 증가할 때 자동으로 함께 계산돼요. 섹션 카운터는 항상 메인 카운터와 연동되어야 작동해요.';

  @override
  String get sectionCounterTypes => '섹션 카운터 5가지 유형';

  @override
  String get rangeCounter => '범위 카운터 (Range)';

  @override
  String get rangeCounterDesc => '특정 구간(시작행~목표행)의 작업을 추적해요.';

  @override
  String get rangeCounterUsage1 => '• \"20~40단까지 겉뜨기\" 같은 구간 작업';

  @override
  String get rangeCounterUsage2 => '• 패턴이 바뀌는 특정 구간 표시';

  @override
  String get rangeCounterUsage3 => '• 여러 색상을 사용하는 구간 관리';

  @override
  String get rangeCounterExample => '\"앞판 20~40단: 케이블 패턴\"';

  @override
  String get repeatCounter => '반복 카운터 (Repeat)';

  @override
  String get repeatCounterDesc => '몇 단마다 반복되는 작업을 추적해요.';

  @override
  String get repeatCounterUsage1 => '• \"6단마다 늘림\" 같은 반복 작업';

  @override
  String get repeatCounterUsage2 => '• \"4단마다 패턴 반복\" 추적';

  @override
  String get repeatCounterUsage3 => '• 규칙적인 무늬나 기법 세기';

  @override
  String get repeatCounterExample => '\"6단마다 양쪽에서 1코씩 늘림 (8회 반복)\"';

  @override
  String get intervalCounter => '인터벌 카운터 (Interval)';

  @override
  String get intervalCounterDesc => '일정 간격마다 변화하는 작업을 추적해요.\n(예: 색상 변경)';

  @override
  String get intervalCounterUsage1 => '• 색상을 주기적으로 바꿀 때';

  @override
  String get intervalCounterUsage2 => '• 스트라이프 패턴 만들기';

  @override
  String get intervalCounterUsage3 => '• 실 배열 순서 추적';

  @override
  String get intervalCounterExample => '\"4단마다 색상 변경: 파란색 → 흰색 → 빨간색\n순서로\"';

  @override
  String get shapingCounter => '쉐이핑 카운터 (Shaping)';

  @override
  String get shapingCounterDesc => '늘림/줄임 작업의 진행 상황을 추적해요.';

  @override
  String get shapingCounterUsage1 => '• 소매나 몸판의 늘림/줄임 작업';

  @override
  String get shapingCounterUsage2 => '• 라글란 소매의 사선 만들기';

  @override
  String get shapingCounterUsage3 => '• 목둘레나 어깨선 줄임';

  @override
  String get shapingCounterExample => '\"양쪽에서 6회 늘림: 68코 → 80코\"';

  @override
  String get lengthCounter => '길이 카운터 (Length)';

  @override
  String get lengthCounterDesc => '특정 길이에 도달할 때까지 작업을 추적해요.';

  @override
  String get lengthCounterUsage1 => '• \"30cm까지 뜨기\" 같은 길이 기반 작업';

  @override
  String get lengthCounterUsage2 => '• 스카프나 담요의 원하는 길이 도달';

  @override
  String get lengthCounterUsage3 => '• 소매 길이나 몸통 길이 추적';

  @override
  String get lengthCounterExample => '\"겉뜨기로 40cm까지 계속\"';

  @override
  String get sectionCounterLinkTitle => '🔗 섹션 카운터 연동 기능';

  @override
  String get sectionCounterLinkDesc =>
      '섹션 카운터는 메인 카운터와 연동할 수 있어요. 연동하면 메인 카운터가 증가할 때 자동으로 함께 계산돼요.';

  @override
  String get tipLinkButton => '💡 팁: 링크 버튼 ';

  @override
  String get tipLinkButtonDesc => ' 을 눌러서 연동을 켜거나 끌 수 있어요. 초록색이면 연동 중이에요.';

  @override
  String get stitchCounterNote =>
      '참고: 코 카운터는 한 단 내에서 독립적으로 동작하므로 메인 카운터와 연동되지 않아요.';

  @override
  String get proTips => '✨ 활용 팁';

  @override
  String get useMemo => '📝 메모를 활용하세요';

  @override
  String get useMemoDesc =>
      '각 파트마다 메모를 남길 수 있어요. \"이 구간에서 실수 많이 함\", \"다음엔 더 느슨하게\" 같은 메모를 남기면 도움이 돼요.';

  @override
  String get useTags => '🎨 태그로 분류하세요';

  @override
  String get useTagsDesc =>
      '프로젝트에 태그를 추가해서 쉽게 찾을 수 있어요. \"진행중\", \"완료\", \"의류\", \"소품\" 같은 태그를 만들어보세요.';

  @override
  String get takePhotos => '📸 사진을 남기세요';

  @override
  String get takePhotosDesc => '완성된 작품이나 진행 중인 모습을 사진으로 남기면 나중에 다시 보는 재미가 있어요.';

  @override
  String get readyToStart => '이제 시작할 준비가 되셨나요?';

  @override
  String get startJourney =>
      'Yarnie와 함께 즐거운 뜨개질 여정을 시작해보세요!\n궁금한 점이 있으면 언제든 다시 확인하세요.';

  @override
  String get guideAgain => '이 가이드는 홈 화면의 사용 가이드 카드 또는 마이 > 고객 지원에서 다시 볼 수 있어요.';

  @override
  String get close => '닫기';

  @override
  String get examplePrefix => '예시: ';

  @override
  String get knittingTip1 => '실 끝은 최소 10cm 남겨두면 마무리가 편해요';

  @override
  String get knittingTip2 => '게이지 샘플을 꼭 떠보세요. 프로젝트 성공의 비결이에요!';

  @override
  String get knittingTip3 => '한 코 한 코 천천히, 서두르지 마세요';

  @override
  String get knittingTip4 => '색 조합이 고민된다면 자연에서 영감을 받아보세요';

  @override
  String get knittingTip5 => '뜨개질 텐션이 너무 세면 손목이 아플 수 있어요. 편안하게!';

  @override
  String get knittingTip6 => 'Yarnie의 섹션 카운터로 복잡한 패턴도 쉽게 추적할 수 있어요';

  @override
  String get knittingTip7 => '패턴을 읽을 때는 한 줄씩 체크하면서 진행하세요';

  @override
  String get knittingTip8 => '휴식을 자주 가지세요. 피로하면 실수가 늘어납니다';

  @override
  String get knittingTip9 => '바늘 사이즈가 맞는지 확인하세요. 작품의 완성도가 달라집니다';

  @override
  String get knittingTip10 => '실수를 두려워하지 마세요. 풀고 다시 뜨는 것도 연습입니다';

  @override
  String get welcomeUser => '환영합니다! 🦎';

  @override
  String get helloUser => '안녕하세요! 🦎';

  @override
  String get enjoyKnitting => '오늘도 즐거운 뜨개질 하세요';

  @override
  String get startKnitting => '뜨개질과 함께하는 즐거운 시간을 시작해보세요';

  @override
  String get startFirstProject => '첫 프로젝트를 시작해보세요!';

  @override
  String get startJourneyWithChameleon =>
      '카멜레온과 함께 뜨개질 여정을 시작해요\n한 코 한 코가 모여 멋진 작품이 됩니다';

  @override
  String get createNewProject => '새 프로젝트 시작하기';

  @override
  String get justNow => '방금 전';

  @override
  String minutesAgo(Object minutes) {
    return '$minutes분 전';
  }

  @override
  String hoursAgo(Object hours) {
    return '$hours시간 전';
  }

  @override
  String daysAgo(Object days) {
    return '$days일 전';
  }

  @override
  String weeksAgo(Object weeks) {
    return '$weeks주 전';
  }

  @override
  String monthsAgo(Object months) {
    return '$months개월 전';
  }

  @override
  String get recentProjects => '최근 작업 프로젝트';

  @override
  String get continueWorking => '이어하기';

  @override
  String get firstTimeUsing => '처음 사용하시나요?';

  @override
  String get yarnieBriefDesc =>
      'Yarnie는 프로젝트를 Part로 나누고, 각 Part마다 카운터로 진행 상황을 추적해요.';

  @override
  String get viewUserGuide => '사용 가이드 보기';

  @override
  String get knittingTips => '뜨개질 팁';

  @override
  String get knittingToday => '오늘도 뜨개질해볼까요?';

  @override
  String get smallStart => '작은 시작이 큰 작품을 만들어요\n지금 바로 첫 번째 코를 떠보세요!';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get notificationSettingsSub => '작업 리마인더, 배지 알림';

  @override
  String get comingSoon => '추후 제공될 기능입니다.';

  @override
  String get darkMode => '다크 모드';

  @override
  String get on => '켜짐';

  @override
  String get off => '꺼짐';

  @override
  String get customerSupport => '고객 지원';

  @override
  String get trash => '휴지통';

  @override
  String get trashSub => '삭제된 프로젝트 관리';

  @override
  String get userGuide => '사용 가이드';

  @override
  String get userGuideSub => 'Yarnie 사용법 배우기';

  @override
  String get appInfo => '앱 정보';

  @override
  String get appVersion => '버전 1.0.0';

  @override
  String get korean => '한국어';

  @override
  String get autoWithDeviceSetting => '자동 (휴대폰 설정 따름)';

  @override
  String get chameleonStory => '카멜레온 이야기';

  @override
  String get chameleonStoryDesc =>
      '우리의 카멜레온 친구는 색을 변환하는 능력이 없어요. 하지만 뜨개질로 다양한 색과 무늬의 옷을 만들어 입으며 매일 새로운 모습으로 행복하게 살아가고 있답니다. 여러분도 카멜레온처럼 뜨개질과 함께 즐거운 시간을 보내세요!';

  @override
  String get sendFeedback => '피드백 보내기';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get termsOfService => '서비스 이용약관';

  @override
  String get openSourceLicense => '오픈소스 라이선스';

  @override
  String get projects => '프로젝트';

  @override
  String projectsCount(Object count) {
    return '$count개의 프로젝트';
  }

  @override
  String get all => '전체';

  @override
  String get bigCard => '큰 카드';

  @override
  String get smallCard => '작은 카드';

  @override
  String get list => '리스트';

  @override
  String dateDisplay(Object day, Object month, Object year) {
    return '$year년 $month월 $day일';
  }

  @override
  String get noProjectsYet => '아직 만든 프로젝트가 없어요.\n프로젝트를 만들어볼까요?';

  @override
  String get createProject => '프로젝트 만들기';

  @override
  String get noMatchingProjects => '해당하는 프로젝트가 없습니다';

  @override
  String get filterResetDesc => '다른 태그를 선택하거나\n필터를 초기화해보세요';

  @override
  String get resetFilter => '필터 초기화';

  @override
  String get copyProject => '프로젝트 복사';

  @override
  String get assignTags => '태그 지정';

  @override
  String get unclassified => '미분류';

  @override
  String get sessionMemo => '작업 메모';

  @override
  String get enterMemo => '메모를 입력하세요';

  @override
  String saveSessionConfirm(Object time) {
    return '작업 시간 $time을 저장하시겠습니까?';
  }

  @override
  String trashProjectCount(Object count) {
    return '$count개의 프로젝트 · 30일 후 자동 삭제';
  }

  @override
  String get loading => '로딩 중...';

  @override
  String get errorLoadingData => '데이터를 불러올 수 없습니다';

  @override
  String get availableAfterRestore => '복원 후 이용할 수 있습니다.';

  @override
  String errorOccurred(Object error) {
    return '에러 발생: $error';
  }

  @override
  String get restore => '복원하기';

  @override
  String get deleteForeverNow => '지금 완전 삭제하기';

  @override
  String get restoreProject => '프로젝트 복원';

  @override
  String get restoreConfirm => '이 프로젝트를 복원하시겠습니까?';

  @override
  String get projectRestored => '프로젝트가 복원되었습니다.';

  @override
  String restoreFailed(Object error) {
    return '복원 실패: $error';
  }

  @override
  String get deleteForever => '완전 삭제';

  @override
  String get deleteForeverConfirm => '이 프로젝트를 완전히 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get delete => '삭제';

  @override
  String get projectDeletedForever => '프로젝트가 완전히 삭제되었습니다.';

  @override
  String deleteFailed(Object error) {
    return '삭제 실패: $error';
  }

  @override
  String get emptyTrash => '휴지통이 비어있습니다';

  @override
  String get noDeletedProjects => '삭제된 프로젝트가 없습니다';
}
