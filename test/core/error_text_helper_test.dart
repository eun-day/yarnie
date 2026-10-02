import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/common/error_text_helper.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/l10n/app_localizations.dart';

void main() {
  test('DB 예외는 영문 기술 메시지 대신 번역된 문구로 바꾸고, 그 외 오류는 원문을 쓴다', () {
    final ko = lookupAppLocalizations(const Locale('ko'));
    final en = lookupAppLocalizations(const Locale('en'));

    expect(ko.errorText(UniqueConstraintException('Create Part: Duplicate value exists')), ko.dbDuplicateError);
    expect(en.errorText(ForeignKeyConstraintException('x')), en.dbForeignKeyError);
    expect(en.errorText(DataIntegrityException('x')), en.dbIntegrityError);
    expect(en.errorText(RecordNotFoundException('Part(ID: 1) not found')), en.dbRecordNotFoundError);
    expect(en.errorText(DatabaseException('x')), en.dbGeneralError);
    expect(en.errorText(const FormatException('bad')), 'FormatException: bad');
  });
}
