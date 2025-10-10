import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_db.dart';

/// 앱 전체에서 공유하는 단일 DB 인스턴스
final appDb = AppDb();

/// AppDb Provider (테스트에서 오버라이드 가능)
final appDbProvider = Provider<AppDb>((ref) => appDb);
