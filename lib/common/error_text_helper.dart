import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/l10n/app_localizations.dart';

extension ErrorTextHelper on AppLocalizations {
  /// 오류 안내에 넣을 문구. DB 예외는 영문 기술 메시지 대신 번역된 문구로 바꾼다
  String errorText(Object error) => switch (error) {
        UniqueConstraintException() => dbDuplicateError,
        ForeignKeyConstraintException() => dbForeignKeyError,
        DataIntegrityException() => dbIntegrityError,
        RecordNotFoundException() => dbRecordNotFoundError,
        DatabaseException() => dbGeneralError,
        _ => error.toString(),
      };
}
