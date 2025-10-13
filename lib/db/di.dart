import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_db.dart';

/// 앱 전체에서 공유하는 단일 DB 인스턴스
final appDb = AppDb();

/// Riverpod용 AppDb 프로바이더
final appDbProvider = Provider<AppDb>((ref) => appDb);
