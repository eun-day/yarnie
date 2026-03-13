import 'package:flutter/material.dart';

class AppStrings {
  // Common
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String auto = 'auto';

  // Preferences Sheet
  static const String preferencesTitle = 'preferencesTitle';
  static const String preferencesSubtitle = 'preferencesSubtitle';
  static const String language = 'language';
  static const String lengthUnit = 'lengthUnit';
  static const String dataManage = 'dataManage';
  static const String sessionSetting = 'sessionSetting';
  static const String touchFeedback = 'touchFeedback';

  static const String languageCurrentKorean = 'languageCurrentKorean';
  static const String languageSub = 'languageSub';

  static const String lengthCm = 'lengthCm';
  static const String lengthInch = 'lengthInch';
  static const String lengthSub = 'lengthSub';

  static const String autoBackup = 'autoBackup';
  static const String autoBackupSub = 'autoBackupSub';
  static const String exportData = 'exportData';
  static const String exportDataSub = 'exportDataSub';
  static const String importData = 'importData';
  static const String importDataSub = 'importDataSub';

  static const String screenAwake = 'screenAwake';
  static const String screenAwakeSub = 'screenAwakeSub';

  static const String touchFeedbackSub = 'touchFeedbackSub';
  static const String vibrate = 'vibrate';
  static const String sound = 'sound';
  static const String both = 'both';
  static const String none = 'none';

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      save: 'Save',
      cancel: 'Cancel',
      auto: 'Auto',
      preferencesTitle: 'Preferences',
      preferencesSubtitle: 'Configure your app environment',
      language: 'Language',
      lengthUnit: 'Length unit',
      dataManage: 'Data management',
      sessionSetting: 'Session settings',
      touchFeedback: 'Touch feedback',
      languageCurrentKorean: 'Auto (Current: Korean)',
      languageSub: 'Selecting Auto follows the device language settings',
      lengthCm: 'Centimeter (cm)',
      lengthInch: 'Inch (inch)',
      lengthSub: 'Applied to hook size, length measurement, etc.',
      autoBackup: 'Auto backup',
      autoBackupSub: 'Automatically backup data every day',
      exportData: 'Export data',
      exportDataSub: 'Save all projects as a JSON file',
      importData: 'Import data',
      importDataSub: 'Restore from a backup file',
      screenAwake: 'Keep screen on',
      screenAwakeSub: 'Screen won\'t turn off while working',
      touchFeedbackSub:
          'You can receive feedback when pressing counter buttons',
      vibrate: 'Vibrate',
      sound: 'Sound',
      both: 'Both',
      none: 'None',
      '마이': 'My',
      '언어, 단위, 백업': 'Language, Unit, Backup',
      '설정': 'Settings',
    },
    'ko': {
      save: '저장',
      cancel: '취소',
      auto: '자동',
      preferencesTitle: '환경 설정',
      preferencesSubtitle: '앱 사용 환경을 설정하세요',
      language: '언어',
      lengthUnit: '길이 단위',
      dataManage: '데이터 관리',
      sessionSetting: '작업 중 설정',
      touchFeedback: '터치 피드백',
      languageCurrentKorean: '자동 (현재: 한국어)',
      languageSub: '자동을 선택하면 휴대폰 언어 설정을 따릅니다',
      lengthCm: '센티미터 (cm)',
      lengthInch: '인치 (inch)',
      lengthSub: '바늘 사이즈, 길이 측정 등에 적용됩니다',
      autoBackup: '자동 백업',
      autoBackupSub: '매일 자동으로 데이터 백업',
      exportData: '데이터 내보내기',
      exportDataSub: '모든 프로젝트를 JSON 파일로 저장',
      importData: '데이터 가져오기',
      importDataSub: '백업 파일에서 복원하기',
      screenAwake: '화면 꺼짐 방지',
      screenAwakeSub: '작업 중 화면이 꺼지지 않음',
      touchFeedbackSub: '카운터 버튼을 누를 때 피드백을 받을 수 있어요',
      vibrate: '진동',
      sound: '소리',
      both: '둘 다',
      none: '없음',
      '마이': '마이',
      '언어, 단위, 백업': '언어, 단위, 백업',
      '설정': '설정',
    },
  };

  static String tr(BuildContext context, String key) {
    // Determine the current locale from the top-level app wrapper
    final locale = Localizations.localeOf(context).languageCode;
    // Default to 'en' if not 'ko'
    final mapKey = locale == 'ko' ? 'ko' : 'en';

    return _localizedValues[mapKey]?[key] ?? key;
  }
}
