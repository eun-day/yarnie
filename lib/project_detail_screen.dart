import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yarnie/db/app_db.dart';
import 'package:yarnie/db/di.dart';
import 'package:yarnie/widgets/add_buddy_counter_menu.dart';
import 'package:yarnie/widgets/add_interval_counter_sheet.dart';
import 'package:yarnie/widgets/add_length_counter_sheet.dart';
import 'package:yarnie/widgets/add_range_counter_sheet.dart';
import 'package:yarnie/widgets/add_repeat_counter_sheet.dart';
import 'package:yarnie/widgets/add_shaping_counter_sheet.dart';
import 'package:yarnie/widgets/edit_stitch_counter_sheet.dart';
import 'package:yarnie/widgets/counter_card/interval_counter_card.dart';
import 'package:yarnie/widgets/counter_card/length_counter_card.dart';
import 'package:yarnie/widgets/counter_card/range_counter_card.dart';
import 'package:yarnie/widgets/counter_card/repeat_counter_card.dart';
import 'package:yarnie/widgets/counter_card/shaping_counter_card.dart';
import 'package:yarnie/widgets/counter_card/stitch_counter_card.dart';
import 'package:yarnie/widgets/counter_edit_bottom_sheet.dart';
import 'package:yarnie/widgets/main_counter_settings_button.dart';
import 'package:yarnie/widgets/target_setting_dialog.dart';
// import 'package:yarnie/stopwatch_panel.dart'; // 기존 패널 미사용
// import 'package:yarnie/counter_panel.dart';   // 기존 패널 미사용
// import 'package:yarnie/widget/project_info_section.dart';

class ProjectDetailScreen extends ConsumerStatefulWidget {
  final int projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends ConsumerState<ProjectDetailScreen> {
  // 현재 선택된 파트 ID (null이면 로딩 중이거나 파트가 없음)
  int? _selectedPartId;
  StreamSubscription<MainCounter?>? _mainCounterSub;
  int? _prevMainValue;

  @override
  void dispose() {
    _mainCounterSub?.cancel();
    super.dispose();
  }

  void _listenToMainCounter(int partId) {
    _mainCounterSub?.cancel();
    _prevMainValue = null; // Reset for new part

    _mainCounterSub = (appDb.select(appDb.mainCounters)
          ..where((t) => t.partId.equals(partId)))
        .watchSingleOrNull()
        .listen((mainCounter) {
      if (mainCounter == null) return;
      final current = mainCounter.currentValue;

      if (_prevMainValue != null && current != _prevMainValue) {
        _checkCompletions(partId, _prevMainValue!, current);
      }
      _prevMainValue = current;
    });
  }

  Future<void> _checkCompletions(int partId, int oldVal, int newVal) async {
    final counters = await appDb.getPartSectionCounters(partId);
    
    for (final counter in counters) {
      // Only check linked counters
      if (counter.linkState != LinkState.linked) continue;

      Map<String, dynamic> spec = {};
      try {
        spec = jsonDecode(counter.specJson);
      } catch (_) {}
      final type = spec['type']?.toString().toLowerCase();

      bool wasCompleted = false;
      bool isCompleted = false;

      // Logic must match _buildCard exactly
      // We also need 'runs' for accurate check
      final runs = await appDb.getSectionRuns(counter.id);
      if (runs.isEmpty) continue;

      if (type == 'range') {
        final run = runs.first;
        final end = run.startRow + run.rowsTotal - 1;
        wasCompleted = oldVal >= end;
        isCompleted = newVal >= end;
      } else if (type == 'repeat') {
        // Repeat completion: all runs passed
        final lastRun = runs.last;
        // End of last run
        wasCompleted = oldVal >= (lastRun.startRow + lastRun.rowsTotal);
        isCompleted = newVal >= (lastRun.startRow + lastRun.rowsTotal);
      } else if (type == 'interval') {
        // Interval completion: completedCount >= runs.length
        int count(int val) {
          int c = 0;
          for (final r in runs) {
            if (val >= r.startRow + r.rowsTotal) {
              c++;
            } else if (val >= r.startRow) {
              break;
            }
          }
          return c;
        }
        wasCompleted = count(oldVal) >= runs.length;
        isCompleted = count(newVal) >= runs.length;
      } else if (type == 'shaping') {
        // Shaping completion: shapingCompleted >= runs.length
        // Logic same as interval
        int count(int val) {
          int c = 0;
          for (final r in runs) {
            // Shaping action usually at end of interval
            if (val >= r.startRow + r.rowsTotal) {
              c++;
            } else {
              break;
            }
          }
          return c;
        }
        wasCompleted = count(oldVal) >= runs.length;
        isCompleted = count(newVal) >= runs.length;
      } else if (type == 'length') {
        final runL = runs.first;
        final targetLength = spec['targetLength'] as double? ?? 0.0;
        final rowHeight = spec['rowHeight'] as double? ?? 0.1;
        
        bool check(int val) {
          final rowsDone = (val - runL.startRow + 1).clamp(0, runL.rowsTotal);
          final rowsLeft = runL.rowsTotal - rowsDone;
          final remainingLen = (rowsLeft * rowHeight).clamp(0.0, targetLength);
          final progressL = runL.rowsTotal > 0 ? rowsDone / runL.rowsTotal : 0.0;
          return progressL >= 1.0 || remainingLen <= 0;
        }
        wasCompleted = check(oldVal);
        isCompleted = check(newVal);
      }

      if (!wasCompleted && isCompleted) {
        if (mounted) {
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🎉 ${counter.name} 완료!'),
              backgroundColor: const Color(0xFF6FB96F),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectAsync = appDb.watchProject(widget.projectId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<Project>(
          stream: projectAsync,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final project = snapshot.data!;
            
            return Column(
              children: [
                // 1. Custom Header
                _buildHeader(context, project),
                
                // 2. Part Tabs
                _buildPartTabs(context, project),
                
                // 3. Integrated Content View
                Expanded(
                  child: _selectedPartId == null
                      ? const Center(child: Text('파트를 선택하거나 생성해주세요.'))
                      : _buildIntegratedContentView(context, _selectedPartId!),
                ),
              ],
            );
          },
        ),
      ),
      // FAB for adding counters
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierColor: Colors.transparent, // or Colors.black54 if dimming desired
            builder: (context) {
              return Stack(
                children: [
                  Positioned(
                    bottom: 80, // Above FAB
                    right: 16,
                    child: AddBuddyCounterMenu(
                      onStitchSelected: () async {
                        Navigator.pop(context);
                        if (_selectedPartId == null) return;
                        
                        try {
                          await appDb.createStitchCounter(
                            partId: _selectedPartId!,
                            name: '스티치 카운터', // Default name
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('생성 실패: $e')));
                          }
                        }
                      },
                      onRangeSelected: () async {
                        Navigator.pop(context);
                        if (_selectedPartId == null) return;
                        
                        final mainCounter = await appDb.getMainCounter(_selectedPartId!);
                        if (context.mounted) {
                           showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddRangeCounterSheet(
                              partId: _selectedPartId!,
                              initialStartRow: mainCounter?.currentValue ?? 1,
                            ),
                          );
                        }
                      },
                      onRepeatSelected: () async {
                        Navigator.pop(context);
                        if (_selectedPartId == null) return;

                        final mainCounter = await appDb.getMainCounter(_selectedPartId!);
                        if (context.mounted) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddRepeatCounterSheet(
                              partId: _selectedPartId!,
                              initialStartRow: mainCounter?.currentValue ?? 1,
                            ),
                          );
                        }
                      },
                      onIntervalSelected: () async {
                        Navigator.pop(context);
                        if (_selectedPartId == null) return;

                        final mainCounter = await appDb.getMainCounter(_selectedPartId!);
                        if (context.mounted) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddIntervalCounterSheet(
                              partId: _selectedPartId!,
                              initialStartRow: mainCounter?.currentValue ?? 1,
                            ),
                          );
                        }
                      },
                      onShapingSelected: () async {
                        Navigator.pop(context);
                        if (_selectedPartId == null) return;

                        final mainCounter = await appDb.getMainCounter(_selectedPartId!);
                        if (context.mounted) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddShapingCounterSheet(
                              partId: _selectedPartId!,
                              initialStartRow: mainCounter?.currentValue ?? 1,
                            ),
                          );
                        }
                      },
                      onLengthSelected: () async {
                        Navigator.pop(context);
                        if (_selectedPartId == null) return;

                        final mainCounter = await appDb.getMainCounter(_selectedPartId!);
                        if (context.mounted) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddLengthCounterSheet(
                              partId: _selectedPartId!,
                              initialStartRow: mainCounter?.currentValue ?? 1,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: const Color(0xFF637069),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Project project) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x0D000000), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF0A0A0A)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                project.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0A0A0A),
                  letterSpacing: -0.31,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Memo Button
              GestureDetector(
                onTap: () {
                  // TODO: Open Part Memo
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.description_outlined, size: 24, color: Color(0xFF717182)),
                    ),
                    Positioned(
                      right: -2,
                      top: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xFF637069),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '2', // TODO: Real memo count
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // More Button
              GestureDetector(
                onTap: () {
                    // TODO: Project Info / Delete Popup
                },
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: const Icon(Icons.more_vert, color: Color(0xFF0A0A0A)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartTabs(BuildContext context, Project project) {
    return StreamBuilder<List<Part>>(
      stream: appDb.watchProjectParts(project.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox(height: 60, child: Center(child: Icon(Icons.error)));
        }

        final parts = snapshot.data ?? [];

        // 초기 선택 로직
        // 1. 현재 선택된 파트가 없고
        // 2. 파트 목록이 있을 때
        if (_selectedPartId == null && parts.isNotEmpty) {
          // DB의 currentPartId가 유효한지 확인
          final savedPartId = project.currentPartId;
          final isValidSaved = savedPartId != null && parts.any((p) => p.id == savedPartId);
          
          final initialPartId = isValidSaved ? savedPartId : parts.first.id;

          // 빌드 후 상태 업데이트
          Future.microtask(() {
            if (mounted && _selectedPartId == null) {
              setState(() {
                _selectedPartId = initialPartId;
                _listenToMainCounter(initialPartId);
              });
              // 만약 저장된 파트와 다르면(예: 첫 로드 또는 유효하지 않은 ID), DB 업데이트
              if (savedPartId != initialPartId) {
                appDb.updateProjectCurrentPart(projectId: project.id, partId: initialPartId);
              }
            }
          });
        } else if (parts.isEmpty && _selectedPartId != null) {
           Future.microtask(() {
            if (mounted && _selectedPartId != null) {
              setState(() {
                _selectedPartId = null;
              });
            }
          });
        }

        return Container(
          height: 60,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0x1A000000), width: 0.5)),
          ),
          child: Row(
            children: [
              // New Part Button (Fixed)
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 8, top: 12, bottom: 12),
                child: GestureDetector(
                  onTap: () => _showAddPartDialog(context, project.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF637069),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Row(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '새 파트',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.31,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Reorderable Part List
              Expanded(
                child: parts.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('파트를 추가해주세요', style: TextStyle(color: Colors.grey)),
                      )
                    : ReorderableListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                        // 헤더가 없으므로 첫 아이템 패딩 제거됨, Row 간격으로 조정
                        proxyDecorator: (child, index, animation) {
                          return Material(
                            color: Colors.transparent,
                            child: child,
                          );
                        },
                        onReorder: (oldIndex, newIndex) async {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = parts.removeAt(oldIndex);
                          parts.insert(newIndex, item);
                          
                          // DB 업데이트 (순서 변경)
                          final partIds = parts.map((e) => e.id).toList();
                          await appDb.reorderParts(projectId: project.id, partIds: partIds);
                        },
                        itemCount: parts.length,
                        itemBuilder: (context, index) {
                          final part = parts[index];
                          final isSelected = part.id == _selectedPartId;
                          return GestureDetector(
                            key: ValueKey(part.id), // 필수
                            onTap: () {
                              setState(() {
                                _selectedPartId = part.id;
                                _listenToMainCounter(part.id);
                              });
                              // 파트 변경 시 DB에 현재 파트 저장
                              appDb.updateProjectCurrentPart(projectId: project.id, partId: part.id);
                            },
                            // 롱프레스로 드래그 시작
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF6FB96F) : const Color(0xFFECEEF2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                part.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF030213),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.31,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddPartDialog(BuildContext context, int projectId) async {
    final textController = TextEditingController();
    String? errorText;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('새 파트 추가'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: '파트 이름 (예: 앞판, 소매)',
                      errorText: errorText,
                    ),
                    autofocus: true,
                    onChanged: (_) {
                      if (errorText != null) {
                        setState(() {
                          errorText = null;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () async {
                    final name = textController.text.trim();
                    if (name.isNotEmpty) {
                      // 중복 체크
                      final exists = await appDb.isPartNameExists(projectId: projectId, name: name);
                      if (exists) {
                        setState(() {
                          errorText = '이미 존재하는 파트 이름입니다.';
                        });
                        return;
                      }

                      try {
                        final newPartId = await appDb.createPart(projectId: projectId, name: name);
                        if (context.mounted) {
                          Navigator.pop(context);
                          // 새로 생성된 파트를 자동 선택 및 저장
                          setState(() {
                            _selectedPartId = newPartId;
                            _listenToMainCounter(newPartId);
                          });
                          appDb.updateProjectCurrentPart(projectId: projectId, partId: newPartId);
                        }
                      } catch (e) {
                         if (context.mounted) {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('파트 생성 실패: $e')),
                           );
                         }
                      }
                    }
                  },
                  child: const Text('추가'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIntegratedContentView(BuildContext context, int partId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Session Panel (Stopwatch)
          _buildSessionPanel(),
          const SizedBox(height: 16),

          // 2. Main Counter
          _buildMainCounter(),
          const SizedBox(height: 16),

          // 3. Buddy Counters (Grid/List)
          _buildBuddyCounters(),
          
          // 하단 여백 확보 (FAB 가림 방지)
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildSessionPanel() {
    return SessionPanelWidget(partId: _selectedPartId!);
  }

  Widget _buildMainCounter() {
    return MainCounterWidget(partId: _selectedPartId!);
  }

  Widget _buildBuddyCounters() {
    return BuddyCounterListWidget(partId: _selectedPartId!);
  }
}

class BuddyCounterListWidget extends StatefulWidget {
  final int partId;
  const BuddyCounterListWidget({super.key, required this.partId});

  @override
  State<BuddyCounterListWidget> createState() => _BuddyCounterListWidgetState();
}

class _BuddyCounterListWidgetState extends State<BuddyCounterListWidget> {
  List<StitchCounter> _stitchCounters = [];
  List<SectionCounter> _sectionCounters = [];
  String? _buddyCounterOrder;
  StreamSubscription? _stitchSub;
  StreamSubscription? _sectionSub;
  StreamSubscription? _partSub;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant BuddyCounterListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.partId != widget.partId) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _stitchSub = (appDb.select(appDb.stitchCounters)..where((t) => t.partId.equals(widget.partId))).watch().listen((data) {
      setState(() {
        _stitchCounters = data;
      });
    });

    _sectionSub = (appDb.select(appDb.sectionCounters)..where((t) => t.partId.equals(widget.partId))).watch().listen((data) {
      setState(() {
        _sectionCounters = data;
      });
    });

    _partSub = (appDb.select(appDb.parts)..where((t) => t.id.equals(widget.partId))).watchSingleOrNull().listen((part) {
      setState(() {
        _buddyCounterOrder = part?.buddyCounterOrder;
      });
    });
  }

  void _unsubscribe() {
    _stitchSub?.cancel();
    _sectionSub?.cancel();
    _partSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var allItems = [
      ..._stitchCounters.map((c) => _BuddyItem.stitch(c)),
      ..._sectionCounters.map((c) => _BuddyItem.section(c)),
    ];

    if (_buddyCounterOrder != null) {
      try {
        final List order = jsonDecode(_buddyCounterOrder!);
        final Map<String, int> orderMap = {};
        for (int i = 0; i < order.length; i++) {
          final item = order[i];
          final key = "${item['type']}_${item['id']}";
          orderMap[key] = i;
        }

        allItems.sort((a, b) {
          final keyA = a.isStitch ? "stitch_${a.stitch!.id}" : "section_${a.section!.id}";
          final keyB = b.isStitch ? "stitch_${b.stitch!.id}" : "section_${b.section!.id}";
          
          final orderA = orderMap[keyA] ?? 999;
          final orderB = orderMap[keyB] ?? 999;
          
          return orderA.compareTo(orderB);
        });
      } catch (_) {
        // Fallback to default order if JSON is invalid
      }
    }

    if (allItems.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            '카운터가 없습니다.\n+ 버튼을 눌러 추가해보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 173 / 160,
      ),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        if (item.isStitch) {
          final counter = item.stitch!;
          return StitchCounterCard(
            label: counter.name,
            currentValue: counter.currentValue,
            countBy: counter.countBy,
            onIncrement: () {
              appDb.updateStitchCounter(
                counterId: counter.id,
                currentValue: counter.currentValue + counter.countBy,
              );
            },
            onDecrement: () {
              if (counter.currentValue > 0) {
                final newValue = counter.currentValue - counter.countBy;
                appDb.updateStitchCounter(
                  counterId: counter.id,
                  currentValue: newValue < 0 ? 0 : newValue,
                );
              }
            },
            onCountByChanged: (value) {
              appDb.updateStitchCounter(
                counterId: counter.id,
                countBy: value,
              );
            },
            onEdit: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => EditStitchCounterSheet(counter: counter),
              );
            },
            onDelete: () async {
              final part = await appDb.getPart(counter.partId);
              if (part != null && part.buddyCounterOrder != null) {
                final List order = jsonDecode(part.buddyCounterOrder!);
                order.removeWhere((item) => item['type'] == 'stitch' && item['id'] == counter.id);
                await appDb.deleteStitchCounter(
                  counterId: counter.id,
                  partId: counter.partId,
                  newOrderJson: jsonEncode(order),
                );
              }
            },
          );
        } else {
          return SectionCounterCardWrapper(counter: item.section!);
        }
      },
    );
  }
}

class _BuddyItem {
  final StitchCounter? stitch;
  final SectionCounter? section;

  _BuddyItem.stitch(this.stitch) : section = null;
  _BuddyItem.section(this.section) : stitch = null;

  bool get isStitch => stitch != null;
}

class SectionCounterCardWrapper extends ConsumerWidget {
  final SectionCounter counter;
  const SectionCounterCardWrapper({super.key, required this.counter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // StreamBuilder to watch runs
    return StreamBuilder<List<SectionRun>>(
      stream: (appDb.select(appDb.sectionRuns)
            ..where((t) => t.sectionCounterId.equals(counter.id))
            ..orderBy([(t) => OrderingTerm.asc(t.ord)]))
          .watch(),
      builder: (context, runsSnapshot) {
        if (runsSnapshot.hasError) {
          return SizedBox(height: 160, child: Center(child: Text('Error: ${runsSnapshot.error}')));
        }
        if (!runsSnapshot.hasData) {
          return const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()));
        }

        final runs = runsSnapshot.data!;

        // Nested StreamBuilder to watch MainCounter
        return StreamBuilder<MainCounter?>(
          stream: (appDb.select(appDb.mainCounters)
                ..where((t) => t.partId.equals(counter.partId)))
              .watchSingleOrNull(),
          builder: (context, mainSnapshot) {
            final mainCounterVal = mainSnapshot.data?.currentValue ?? 1;
            return _buildCard(context, counter, runs, mainCounterVal);
          },
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, SectionCounter counter, List<SectionRun> runs, int currentMainValue) {
    Map<String, dynamic> spec = {};
    try {
      spec = jsonDecode(counter.specJson);
    } catch (_) {}
    
    final type = spec['type']?.toString().toLowerCase();
    
    // 1. Determine effective value for calculation based on LinkState
    final effectiveValue = counter.linkState == LinkState.linked
        ? currentMainValue
        : (counter.frozenMainAt ?? currentMainValue);

    // 2. Helper to wrap with opacity
    Widget wrapOpacity(Widget child, int startRow) {
      // Use REAL currentMainValue for active check, not frozen value
      final isActive = currentMainValue >= startRow;
      return Opacity(
        opacity: isActive ? 1.0 : 0.5,
        child: child,
      );
    }

    final unlinkedColor = const Color(0xFFF8F9FA);
    final completedColor = const Color(0xFFF0FDF4);
    
    switch (type) {
      case 'range':
        if (runs.isEmpty) return const Text('No Data');
        final run = runs.first;
        final isCompleted = effectiveValue >= (run.startRow + run.rowsTotal - 1);
        final backgroundColor = isCompleted ? completedColor : (counter.linkState == LinkState.linked ? null : unlinkedColor);

        return wrapOpacity(
          RangeCounterCard(
            label: counter.name,
            currentMainValue: effectiveValue,
            startRow: run.startRow,
            endRow: run.startRow + run.rowsTotal - 1,
            totalRows: run.rowsTotal,
            isLinked: counter.linkState == LinkState.linked,
            backgroundColor: backgroundColor,
            isCompleted: isCompleted,
            onLinkTap: () {
              if (counter.linkState == LinkState.linked) {
                appDb.unlinkSectionCounter(counterId: counter.id, currentMainValue: currentMainValue);
              } else {
                appDb.relinkSectionCounter(counter.id);
              }
            },
            onEdit: () {
               showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddRangeCounterSheet(
                  partId: counter.partId,
                  initialStartRow: run.startRow,
                  existingCounter: counter,
                ),
              );
            },
            onDelete: () async {
              final part = await appDb.getPart(counter.partId);
              if (part != null && part.buddyCounterOrder != null) {
                final List order = jsonDecode(part.buddyCounterOrder!);
                order.removeWhere((item) => item['type'] == 'section' && item['id'] == counter.id);
                await appDb.deleteSectionCounter(
                  counterId: counter.id,
                  partId: counter.partId,
                  newOrderJson: jsonEncode(order),
                );
              }
            },
          ),
          run.startRow,
        );
      
      case 'repeat':
        final rowsPerRepeat = spec['rowsPerRepeat'] as int? ?? 4;
        final startRow = spec['startRow'] as int? ?? 1;

        // Calculate repeat progress using effectiveValue
        int currentRunIndex = 0;
        int currentRowInPattern = 0;
        
        bool found = false;
        for (int i = 0; i < runs.length; i++) {
          final r = runs[i];
          final end = r.startRow + r.rowsTotal;
          if (effectiveValue < r.startRow) {
            if (i == 0) {
               currentRunIndex = 0;
               currentRowInPattern = 0;
               found = true;
            }
            break;
          } else if (effectiveValue < end) {
            currentRunIndex = i;
            currentRowInPattern = effectiveValue - r.startRow + 1;
            found = true;
            break;
          }
        }
        
        if (!found && runs.isNotEmpty) {
           currentRunIndex = runs.length; 
           currentRowInPattern = runs.last.rowsTotal;
        }

        final isCompleted = currentRunIndex >= runs.length;
        final backgroundColor = isCompleted ? completedColor : (counter.linkState == LinkState.linked ? null : unlinkedColor);

        return wrapOpacity(
          RepeatCounterCard(
            label: counter.name,
            currentRepeatCount: currentRunIndex,
            maxRepeatCount: runs.length,
            currentRowInPattern: currentRowInPattern,
            rowsPerRepeat: rowsPerRepeat,
            startRow: startRow,
            isLinked: counter.linkState == LinkState.linked,
            backgroundColor: backgroundColor,
            isCompleted: isCompleted,
            onLinkTap: () {
              if (counter.linkState == LinkState.linked) {
                appDb.unlinkSectionCounter(counterId: counter.id, currentMainValue: currentMainValue);
              } else {
                appDb.relinkSectionCounter(counter.id);
              }
            },
            onEdit: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddRepeatCounterSheet(
                  partId: counter.partId,
                  initialStartRow: startRow,
                  existingCounter: counter,
                ),
              );
            },
            onDelete: () async {
              final part = await appDb.getPart(counter.partId);
              if (part != null && part.buddyCounterOrder != null) {
                final List order = jsonDecode(part.buddyCounterOrder!);
                order.removeWhere((item) => item['type'] == 'section' && item['id'] == counter.id);
                await appDb.deleteSectionCounter(
                  counterId: counter.id,
                  partId: counter.partId,
                  newOrderJson: jsonEncode(order),
                );
              }
            },
          ),
          startRow,
        );

      case 'interval':
        final intervalRows = spec['intervalRows'] as int? ?? 1;
        final startRowInt = spec['startRow'] as int? ?? 1;
        
        int completedCount = 0;
        for (final r in runs) {
           if (effectiveValue >= r.startRow + r.rowsTotal) {
             completedCount++;
           } else if (effectiveValue >= r.startRow) {
             break;
           }
        }

        final isCompleted = completedCount >= runs.length;
        final backgroundColor = isCompleted ? completedColor : (counter.linkState == LinkState.linked ? null : unlinkedColor);

        return wrapOpacity(
          IntervalCounterCard(
            label: counter.name,
            intervalRows: intervalRows,
            currentCount: completedCount,
            totalCount: runs.length,
            startRow: startRowInt,
            isLinked: counter.linkState == LinkState.linked,
            backgroundColor: backgroundColor,
            isCompleted: isCompleted,
            onLinkTap: () {
              if (counter.linkState == LinkState.linked) {
                appDb.unlinkSectionCounter(counterId: counter.id, currentMainValue: currentMainValue);
              } else {
                appDb.relinkSectionCounter(counter.id);
              }
            },
            onEdit: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddIntervalCounterSheet(
                  partId: counter.partId,
                  initialStartRow: startRowInt,
                  existingCounter: counter,
                ),
              );
            },
            onDelete: () async {
              final part = await appDb.getPart(counter.partId);
              if (part != null && part.buddyCounterOrder != null) {
                final List order = jsonDecode(part.buddyCounterOrder!);
                order.removeWhere((item) => item['type'] == 'section' && item['id'] == counter.id);
                await appDb.deleteSectionCounter(
                  counterId: counter.id,
                  partId: counter.partId,
                  newOrderJson: jsonEncode(order),
                );
              }
            },
          ),
          startRowInt,
        );

      case 'shaping':
        final amount = spec['amount'] as int? ?? 0;
        final intervalRowsShaping = spec['intervalRows'] as int? ?? 1;
        final startRowShaping = spec['startRow'] as int? ?? 1;

        int shapingCompleted = 0;
        int nextActionRow = startRowShaping + intervalRowsShaping; 
        
        for (int i = 0; i < runs.length; i++) {
           final r = runs[i];
           final actionRow = r.startRow + r.rowsTotal; 
           
           if (effectiveValue >= actionRow) {
             shapingCompleted++;
           } else {
             nextActionRow = actionRow;
             break;
           }
        }
        
        if (shapingCompleted >= runs.length) {
           nextActionRow = 0; 
        }

        final isCompleted = shapingCompleted >= runs.length;
        final backgroundColor = isCompleted ? completedColor : (counter.linkState == LinkState.linked ? null : unlinkedColor);

        return wrapOpacity(
          ShapingCounterCard(
            label: counter.name,
            amount: amount,
            nextActionRow: nextActionRow,
            intervalRows: intervalRowsShaping,
            currentCount: shapingCompleted,
            totalCount: runs.length,
            startRow: startRowShaping,
            isLinked: counter.linkState == LinkState.linked,
            backgroundColor: backgroundColor,
            isCompleted: isCompleted,
            onLinkTap: () {
              if (counter.linkState == LinkState.linked) {
                appDb.unlinkSectionCounter(counterId: counter.id, currentMainValue: currentMainValue);
              } else {
                appDb.relinkSectionCounter(counter.id);
              }
            },
            onEdit: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddShapingCounterSheet(
                  partId: counter.partId,
                  initialStartRow: startRowShaping,
                  existingCounter: counter,
                ),
              );
            },
            onDelete: () async {
              final part = await appDb.getPart(counter.partId);
              if (part != null && part.buddyCounterOrder != null) {
                final List order = jsonDecode(part.buddyCounterOrder!);
                order.removeWhere((item) => item['type'] == 'section' && item['id'] == counter.id);
                await appDb.deleteSectionCounter(
                  counterId: counter.id,
                  partId: counter.partId,
                  newOrderJson: jsonEncode(order),
                );
              }
            },
          ),
          startRowShaping,
        );

      case 'length':
        if (runs.isEmpty) return const Text('No Data');
        final runL = runs.first;
        
        final targetLength = spec['targetLength'] as double? ?? 0.0;
        final rowHeight = spec['rowHeight'] as double? ?? 0.1;
        
        final rowsDone = (effectiveValue - runL.startRow + 1).clamp(0, runL.rowsTotal);
        final rowsLeft = runL.rowsTotal - rowsDone;
        final remainingLen = (rowsLeft * rowHeight).clamp(0.0, targetLength);
        
        final progressL = runL.rowsTotal > 0 ? rowsDone / runL.rowsTotal : 0.0;

        final isCompleted = progressL >= 1.0 || remainingLen <= 0;
        final backgroundColor = isCompleted ? completedColor : (counter.linkState == LinkState.linked ? null : unlinkedColor);

        return wrapOpacity(
          LengthCounterCard(
            label: counter.name,
            remainingLength: remainingLen,
            startRow: runL.startRow,
            endRow: runL.startRow + runL.rowsTotal - 1,
            currentProgress: progressL,
            isLinked: counter.linkState == LinkState.linked,
            backgroundColor: backgroundColor,
            isCompleted: isCompleted,
            onLinkTap: () {
              if (counter.linkState == LinkState.linked) {
                appDb.unlinkSectionCounter(counterId: counter.id, currentMainValue: currentMainValue);
              } else {
                appDb.relinkSectionCounter(counter.id);
              }
            },
            onEdit: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddLengthCounterSheet(
                  partId: counter.partId,
                  initialStartRow: runL.startRow,
                  existingCounter: counter,
                ),
              );
            },
            onDelete: () async {
              final part = await appDb.getPart(counter.partId);
              if (part != null && part.buddyCounterOrder != null) {
                final List order = jsonDecode(part.buddyCounterOrder!);
                order.removeWhere((item) => item['type'] == 'section' && item['id'] == counter.id);
                await appDb.deleteSectionCounter(
                  counterId: counter.id,
                  partId: counter.partId,
                  newOrderJson: jsonEncode(order),
                );
              }
            },
          ),
          runL.startRow,
        );

      default:
        return const SizedBox(height: 160, child: Center(child: Text('Unknown Type')));
    }
  }
}


class SessionPanelWidget extends StatefulWidget {
  final int partId;
  const SessionPanelWidget({super.key, required this.partId});

  @override
  State<SessionPanelWidget> createState() => _SessionPanelWidgetState();
}

class _SessionPanelWidgetState extends State<SessionPanelWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _elapsed = Duration.zero;
  Session? _session;
  SessionSegment? _currentSegment;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => _updateTimer());
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _updateTimer() {
    if (_session == null) return;
    
    final baseDuration = Duration(seconds: _session!.totalDurationSeconds);
    if (_session!.status == SessionStatus2.running && _currentSegment != null) {
      final now = DateTime.now().toUtc();
      final segmentDuration = now.difference(_currentSegment!.startedAt);
      setState(() {
        _elapsed = baseDuration + segmentDuration;
      });
    } else {
      if (_elapsed != baseDuration) {
        setState(() {
           _elapsed = baseDuration;
        });
      }
    }
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60); // Optional seconds
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}'; // 분:초
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Session?>(
      stream: (appDb.select(appDb.sessions)..where((t) => t.partId.equals(widget.partId))).watchSingleOrNull(),
      builder: (context, snapshot) {
        // snapshot.data가 null이면 세션 없음, 있으면 세션 있음
        _session = snapshot.data; 
        
        final session = _session;
        final isRunning = session?.status == SessionStatus2.running;

        // Session 로드 시 Segment도 같이 조회 (Running 상태일 때만 의미 있음)
        if (session != null && isRunning) {
          return StreamBuilder<SessionSegment?>(
            stream: (appDb.select(appDb.sessionSegments)
                      ..where((t) => t.sessionId.equals(session.id))
                      ..where((t) => t.endedAt.isNull())
                      ..limit(1))
                    .watchSingleOrNull(),
            builder: (context, segSnapshot) {
              _currentSegment = segSnapshot.data;
              if (!_ticker.isActive) _ticker.start();
              return _buildContent(session, true);
            },
          );
        } else {
           _currentSegment = null;
           _ticker.stop();
           if (session != null) {
              _elapsed = Duration(seconds: session.totalDurationSeconds);
           } else {
              _elapsed = Duration.zero;
           }
           return _buildContent(session, false);
        }
      },
    );
  }

  Widget _buildContent(Session? session, bool isRunning) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x1A000000), width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF717182)),
              const SizedBox(width: 8),
              const Text(
                '세션',
                style: TextStyle(
                  fontSize: 12, 
                  color: Color(0xFF717182),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDuration(_elapsed),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0A0A0A),
                  letterSpacing: -0.45,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _handleToggleSession,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isRunning ? const Color(0xFFECEEF2) : const Color(0xFF637069),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isRunning ? Icons.pause : Icons.play_arrow, 
                    size: 14, 
                    color: isRunning ? const Color(0xFF030213) : Colors.white
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isRunning ? '일시정지' : (session == null ? '시작' : '이어하기'),
                    style: TextStyle(
                      color: isRunning ? const Color(0xFF030213) : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleToggleSession() async {
    final partId = widget.partId;
    
    // MainCounter 값을 알아야 함
    final mainCounter = await appDb.getMainCounter(partId);
    final currentMainValue = mainCounter?.currentValue ?? 0;

    if (_session == null) {
      // Start New Session
      await appDb.createSession(partId: partId, currentMainValue: currentMainValue);
    } else {
      if (_session!.status == SessionStatus2.running) {
        // Pause
        if (_currentSegment != null) {
          await appDb.pausePartSession(
            sessionId: _session!.id,
            currentSegmentId: _currentSegment!.id,
            currentMainValue: currentMainValue,
            segmentStartedAt: _currentSegment!.startedAt,
          );
        }
      } else {
        // Resume
        await appDb.resumePartSession(
          sessionId: _session!.id, 
          partId: partId, 
          currentMainValue: currentMainValue
        );
      }
    }
  }
}


class MainCounterWidget extends StatelessWidget {
  final int partId;
  const MainCounterWidget({super.key, required this.partId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MainCounter?>(
      stream: (appDb.select(appDb.mainCounters)..where((t) => t.partId.equals(partId))).watchSingleOrNull(),
      builder: (context, snapshot) {
        final mainCounter = snapshot.data;
        final currentValue = mainCounter?.currentValue ?? 1;
        final targetValue = mainCounter?.targetValue;
        final hasTarget = targetValue != null;
        
        final remaining = hasTarget ? targetValue - currentValue : 0;
        final progress = hasTarget ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

        return Container(
          height: 160,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: const Color(0x1A000000), width: 0.5), // Removed border as per design screenshot usually full bleed or specific
          ),
          child: Stack(
            children: [
              // Buttons (Left/Right split)
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: const Color(0xFFC0D2A4), // Decrement Button Default
                      child: InkWell(
                        splashColor: const Color(0xFF7D8D6A), // Splashing color
                        highlightColor: const Color(0xFFAABF93), // Active (Pressed) state color
                        onTap: () {
                          if (currentValue > 1) {
                            appDb.updateMainCounter(partId: partId, newValue: currentValue - 1);
                          }
                        },
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(Icons.remove, size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: const Color(0xFF6FB96F), // Increment Button Default
                      child: InkWell(
                        splashColor: const Color(0xFF4C8A4C), // Splashing color
                        highlightColor: const Color(0xFF63A763), // Active (Pressed) state color
                        onTap: () {
                          appDb.updateMainCounter(partId: partId, newValue: currentValue + 1);
                        },
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(Icons.add, size: 40, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Center Circle Display
              Center(
                child: GestureDetector(
                  onLongPress: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CounterEditBottomSheet(
                        initialValue: currentValue,
                        onSave: (newValue) {
                          appDb.updateMainCounter(partId: partId, newValue: newValue);
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF3F4F6), width: 3.67),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(0, 10),
                          blurRadius: 15,
                          spreadRadius: -3,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$currentValue',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0A0A0A),
                            letterSpacing: 0.37,
                            height: 1.1,
                          ),
                        ),
                        if (hasTarget)
                          Text(
                            '/ $targetValue', 
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF717182),
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Remaining Label (Top Center)
              if (hasTarget && remaining > 0)
                Positioned(
                  top: 7.28,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      height: 14,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$remaining줄 남음',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 9.2,
                              fontWeight: FontWeight.w400,
                              height: 1.2, 
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Settings Button (Top Right)
              Positioned(
                top: 12,
                right: 12,
                child: MainCounterSettingsButton(
                  onChangeTarget: () {
                    showDialog(
                      context: context,
                      builder: (context) => TargetSettingDialog(
                        initialValue: targetValue ?? 100,
                        onSave: (newValue) {
                          appDb.updateMainCounterTarget(partId: partId, newTargetValue: newValue);
                        },
                      ),
                    );
                  },
                  onRemoveTarget: () {
                    appDb.updateMainCounterTarget(partId: partId, newTargetValue: null);
                  },
                ),
              ),

              // Progress Bar (Bottom)
              if (hasTarget)
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 4,
                    color: const Color.fromRGBO(0, 0, 0, 0.1),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress, 
                      child: Container(color: Colors.white.withValues(alpha: 0.8)), 
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
