import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddBuddyCounterMenu extends StatelessWidget {
  final VoidCallback? onStitchSelected;
  final VoidCallback? onRangeSelected;
  final VoidCallback? onRepeatSelected;
  final VoidCallback? onIntervalSelected;
  final VoidCallback? onShapingSelected;
  final VoidCallback? onLengthSelected;

  const AddBuddyCounterMenu({
    super.key,
    this.onStitchSelected,
    this.onRangeSelected,
    this.onRepeatSelected,
    this.onIntervalSelected,
    this.onShapingSelected,
    this.onLengthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, 
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Text(
                '카운터 유형 선택',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: -0.15,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
            
            // Stitch Counter
            InkWell(
              onTap: onStitchSelected,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/counter_stitch.svg', width: 14, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurfaceVariant, BlendMode.srcIn)),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '스티치 카운터',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: -0.15,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '독립적인 숫자 카운터',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),

            // Section Header
            Padding(
              padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Text(
                '섹션 카운터',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // Items
            _buildItem('assets/icons/counter_range.svg', '범위 (Range)', onRangeSelected),
            _buildItem('assets/icons/counter_repeat.svg', '반복 (Repeat)', onRepeatSelected),
            _buildItem('assets/icons/counter_interval.svg', '간격 (Interval)', onIntervalSelected),
            _buildItem('assets/icons/counter_shaping.svg', '증감 (Shaping)', onShapingSelected),
            _buildItem('assets/icons/counter_length.svg', '길이 (Length)', onLengthSelected),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String iconPath, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
             Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: SvgPicture.asset(iconPath, width: 14, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurfaceVariant, BlendMode.srcIn)),
             ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: -0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
