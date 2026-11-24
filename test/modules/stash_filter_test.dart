import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/modules/stash/stash_api.dart';

StashYarn _yarn(int id, String name, {String? brand, String? weight, String? tagIds}) => StashYarn(
      id: id,
      yarnName: name,
      brandName: brand,
      yarnWeight: weight,
      tagIds: tagIds,
      lengthUnit: 'm',
      weightUnit: 'g',
      createdAt: DateTime(2026, 1, id),
    );

void main() {
  late ProviderContainer container;

  // DB 스트림이 최신 등록순으로 내려주는 목록
  final yarns = [
    _yarn(4, 'merino', brand: 'Drops', weight: 'DK (11 wpi)', tagIds: '[1]'),
    _yarn(3, 'Alpaca', weight: 'Lace'),
    _yarn(2, 'cotton', brand: '', weight: 'DK (11 wpi)', tagIds: '[1,2]'),
    _yarn(1, 'Bamboo', brand: 'Adriafil', tagIds: '[2]'),
  ];

  StashNotifier notifier() => container.read(stashProvider.notifier);
  List<int> shownIds() => container.read(stashProvider).displayYarns.map((y) => y.id).toList();

  setUp(() async {
    container = ProviderContainer();
    await notifier().onEvent(StashUpdatedEvent(yarns));
  });

  tearDown(() => container.dispose());

  test('정렬: 최신순은 DB 순서, 이름순은 대소문자 무시, 브랜드순은 브랜드 없는 실(빈 문자열 포함)을 뒤로', () async {
    expect(shownIds(), [4, 3, 2, 1]);

    await notifier().onEvent(const ChangeSortOrder(StashSortOrder.name));
    expect(shownIds(), [3, 1, 2, 4]);

    await notifier().onEvent(const ChangeSortOrder(StashSortOrder.brand));
    expect(shownIds().take(2), [1, 4]);
    expect(shownIds().skip(2), unorderedEquals([3, 2]));
  });

  test('굵기 필터는 검색·태그와 함께 적용되고 null로 해제된다', () async {
    await notifier().onEvent(const FilterYarnWeight('DK (11 wpi)'));
    expect(shownIds(), [4, 2]);

    await notifier().onEvent(const SearchYarns('COT'));
    expect(shownIds(), [2]);

    await notifier().onEvent(const SearchYarns(''));
    await notifier().onEvent(const ToggleTagFilter(2));
    expect(shownIds(), [2]);

    await notifier().onEvent(const FilterYarnWeight(null));
    expect(shownIds(), [2, 1]);
  });

  test('"전체" 칩(ClearTagFilters)은 태그만, 필터 초기화(ClearFilters)는 전부 해제한다', () async {
    await notifier().onEvent(const ToggleTagFilter(1));
    await notifier().onEvent(const FilterYarnWeight('DK (11 wpi)'));
    await notifier().onEvent(const SearchYarns('mer'));
    expect(shownIds(), [4]);

    await notifier().onEvent(const ClearTagFilters());
    final state = container.read(stashProvider);
    expect(state.selectedTagIds, isEmpty);
    expect(state.yarnWeightFilter, 'DK (11 wpi)');
    expect(state.searchQuery, 'mer');
    expect(shownIds(), [4]);

    await notifier().onEvent(const ClearFilters());
    expect(container.read(stashProvider).hasActiveFilters, isFalse);
    expect(shownIds(), [4, 3, 2, 1]);
  });
}
