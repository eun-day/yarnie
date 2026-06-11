import 'package:yarnie/l10n/app_localizations.dart';

String fmt(Duration d) {
  final h = d.inHours.toString().padLeft(2, '0');
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

String ymdHm(DateTime dt) {
  // 예: 2025-09-08 14:32
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

String mdHm(DateTime dt, AppLocalizations l10n) {
  // 예: 2025년 11월 10일 오후 08:00
  final localDt = dt.toLocal();
  final amPm = localDt.hour < 12 ? l10n.am : l10n.pm;
  final hour = localDt.hour == 0
      ? 12
      : (localDt.hour > 12 ? localDt.hour - 12 : localDt.hour);

  if (l10n.localeName == 'ko') {
    return '${localDt.year}년 ${localDt.month}월 ${localDt.day}일 $amPm ${hour.toString().padLeft(2, '0')}:${localDt.minute.toString().padLeft(2, '0')}';
  }

  if (l10n.localeName == 'ja') {
    return '${localDt.year}年 ${localDt.month}月 ${localDt.day}日 $amPm ${hour.toString().padLeft(2, '0')}:${localDt.minute.toString().padLeft(2, '0')}';
  }

  return '${l10n.dateDisplay(localDt.day, localDt.month, localDt.year)} $amPm ${hour.toString().padLeft(2, '0')}:${localDt.minute.toString().padLeft(2, '0')}';
}

String formatDateDisplay(DateTime date, AppLocalizations l10n) {
  final local = date.toLocal();
  if (l10n.localeName == 'ko') {
    final y = local.year;
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y년 $m월 $d일';
  }
  if (l10n.localeName == 'ja') {
    final y = local.year;
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y年$m月$d日';
  }
  return l10n.dateDisplay(local.day, local.month, local.year);
}

extension MilliSecondsExt on int {
  int toSec() => this ~/ 1000; // 몫 연산
}
