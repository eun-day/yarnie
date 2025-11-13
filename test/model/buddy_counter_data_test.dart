import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/model/buddy_counter_data.dart';

void main() {
  group('StitchCounterData', () {
    test('fromStitchCounter로 객체 생성', () {
      // Given
      final stitchCounter = StitchCounter(
        id: 1,
        partId: 10,
        name: 'Stitch Count',
        currentValue: 50,
        countBy: 2,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      // When
      final data = StitchCounterData.fromStitchCounter(stitchCounter);

      // Then
      expect(data.id, 1);
      expect(data.partId, 10);
      expect(data.name, 'Stitch Count');
      expect(data.currentValue, 50);
      expect(data.countBy, 2);
    });

    test('copyWith로 값 변경', () {
      // Given
      final data = StitchCounterData(
        id: 1,
        partId: 10,
        name: 'Test',
        currentValue: 10,
        countBy: 1,
      );

      // When
      final updated = data.copyWith(currentValue: 20, countBy: 2);

      // Then
      expect(updated.id, 1);
      expect(updated.currentValue, 20);
      expect(updated.countBy, 2);
      expect(updated.name, 'Test'); // 변경되지 않은 값 유지
    });

    test('equality 비교', () {
      // Given
      final data1 = StitchCounterData(
        id: 1,
        partId: 10,
        name: 'Test',
        currentValue: 10,
        countBy: 1,
      );
      final data2 = StitchCounterData(
        id: 1,
        partId: 10,
        name: 'Test',
        currentValue: 10,
        countBy: 1,
      );
      final data3 = StitchCounterData(
        id: 2,
        partId: 10,
        name: 'Test',
        currentValue: 10,
        countBy: 1,
      );

      // Then
      expect(data1, equals(data2));
      expect(data1, isNot(equals(data3)));
    });
  });

  group('SectionCounterData', () {
    test('fromSectionCounter로 객체 생성', () {
      // Given
      final sectionCounter = SectionCounter(
        id: 1,
        partId: 10,
        name: 'Section 1',
        specJson: '{"startRow":10,"rowsTotal":20}',
        linkState: LinkState.linked,
        frozenMainAt: null,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      final spec = {'startRow': 10, 'rowsTotal': 20};

      // When
      final data = SectionCounterData.fromSectionCounter(sectionCounter, spec);

      // Then
      expect(data.id, 1);
      expect(data.partId, 10);
      expect(data.name, 'Section 1');
      expect(data.linkState, LinkState.linked);
      expect(data.isLinked, true);
    });

    test('calculateProgress - linked 상태', () {
      // Given
      final data = SectionCounterData(
        id: 1,
        partId: 10,
        name: 'Section 1',
        spec: {'startRow': 10, 'rowsTotal': 20},
        linkState: LinkState.linked,
        frozenMainAt: null,
      );

      // When & Then
      expect(data.calculateProgress(10), 0); // 시작점
      expect(data.calculateProgress(15), 5); // 중간
      expect(data.calculateProgress(30), 20); // 끝점
      expect(data.calculateProgress(35), 20); // 범위 초과 (clamp)
      expect(data.calculateProgress(5), 0); // 시작 전 (clamp)
    });

    test('calculateProgress - unlinked 상태', () {
      // Given
      final data = SectionCounterData(
        id: 1,
        partId: 10,
        name: 'Section 1',
        spec: {'startRow': 10, 'rowsTotal': 20},
        linkState: LinkState.unlinked,
        frozenMainAt: 15,
      );

      // When & Then
      // unlinked 상태에서는 frozenMainAt 값 사용
      expect(data.calculateProgress(100), 5); // mainCounterValue 무시
      expect(data.calculateProgress(0), 5); // mainCounterValue 무시
    });

    test('calculateProgressPercent', () {
      // Given
      final data = SectionCounterData(
        id: 1,
        partId: 10,
        name: 'Section 1',
        spec: {'startRow': 10, 'rowsTotal': 20},
        linkState: LinkState.linked,
        frozenMainAt: null,
      );

      // When & Then
      expect(data.calculateProgressPercent(10), 0.0); // 0%
      expect(data.calculateProgressPercent(20), 0.5); // 50%
      expect(data.calculateProgressPercent(30), 1.0); // 100%
    });

    test('calculateProgressPercent - rowsTotal이 0일 때', () {
      // Given
      final data = SectionCounterData(
        id: 1,
        partId: 10,
        name: 'Section 1',
        spec: {'startRow': 10, 'rowsTotal': 0},
        linkState: LinkState.linked,
        frozenMainAt: null,
      );

      // When & Then
      expect(data.calculateProgressPercent(20), null);
    });

    test('isLinked 헬퍼', () {
      // Given
      final linked = SectionCounterData(
        id: 1,
        partId: 10,
        name: 'Test',
        spec: {},
        linkState: LinkState.linked,
      );
      final unlinked = SectionCounterData(
        id: 2,
        partId: 10,
        name: 'Test',
        spec: {},
        linkState: LinkState.unlinked,
        frozenMainAt: 10,
      );

      // Then
      expect(linked.isLinked, true);
      expect(unlinked.isLinked, false);
    });
  });

  group('BuddyCounterData sealed class', () {
    test('StitchCounterData는 BuddyCounterData의 서브타입', () {
      // Given
      final stitchData = StitchCounterData(
        id: 1,
        partId: 10,
        name: 'Stitch',
        currentValue: 10,
        countBy: 1,
      );

      // Then
      expect(stitchData, isA<BuddyCounterData>());
    });

    test('SectionCounterData는 BuddyCounterData의 서브타입', () {
      // Given
      final sectionData = SectionCounterData(
        id: 1,
        partId: 10,
        name: 'Section',
        spec: {},
        linkState: LinkState.linked,
      );

      // Then
      expect(sectionData, isA<BuddyCounterData>());
    });

    test('sealed class 패턴 매칭', () {
      // Given
      final List<BuddyCounterData> counters = [
        StitchCounterData(
          id: 1,
          partId: 10,
          name: 'Stitch',
          currentValue: 10,
          countBy: 1,
        ),
        SectionCounterData(
          id: 2,
          partId: 10,
          name: 'Section',
          spec: {},
          linkState: LinkState.linked,
        ),
      ];

      // When & Then
      for (final counter in counters) {
        switch (counter) {
          case StitchCounterData():
            expect(counter.currentValue, 10);
          case SectionCounterData():
            expect(counter.linkState, LinkState.linked);
        }
      }
    });
  });
}
