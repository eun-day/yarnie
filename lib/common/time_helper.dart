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

String mdHm(DateTime dt) {
  // 예: 11월 10일 오후 08:00
  final localDt = dt.toLocal();
  final amPm = localDt.hour < 12 ? '오전' : '오후';
  final hour = localDt.hour == 0 ? 12 : (localDt.hour > 12 ? localDt.hour - 12 : localDt.hour);
  return '${localDt.month}월 ${localDt.day}일 $amPm ${hour.toString().padLeft(2, '0')}:${localDt.minute.toString().padLeft(2, '0')}';
}

extension MilliSecondsExt on int {
  int toSec() => this ~/ 1000; // 몫 연산
}