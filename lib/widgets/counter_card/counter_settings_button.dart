import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CounterSettingsButton extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CounterSettingsButton({
    super.key,
    this.onEdit,
    this.onDelete,
  });

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    
    // 메뉴 너비 고정
    const double menuWidth = 120.0;
    
    // 버튼의 Global 좌표 및 사이즈
    final Offset buttonTopLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;
    
    // 메뉴 위치 계산 (버튼 아래 4px, 우측 정렬)
    // 우측 정렬을 위해 메뉴의 왼쪽 좌표는 (버튼 오른쪽 끝 좌표 - 메뉴 너비)가 되어야 함
    final double menuLeft = buttonTopLeft.dx + buttonSize.width - menuWidth;
    final double menuTop = buttonTopLeft.dy + buttonSize.height + 4.0;
    
    final RelativeRect position = RelativeRect.fromLTRB(
      menuLeft,
      menuTop,
      overlay.size.width - (menuLeft + menuWidth), // Right padding
      overlay.size.height - (menuTop + 150), // Bottom padding (approx menu height)
    );

    showMenu<String>(
      context: context,
      position: position,
      constraints: const BoxConstraints.tightFor(width: menuWidth),
      elevation: 3,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.2),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          width: 0.52,
        ),
      ),
      items: [
        _buildMenuItem(
          value: 'edit',
          icon: Icons.edit_outlined,
          text: '수정',
        ),
        _buildMenuItem(
          value: 'delete',
          text: '삭제',
          textColor: const Color(0xFFD4183D),
          isDestructive: true,
        ),
      ],
    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 'edit':
          onEdit?.call();
          break;
        case 'delete':
          onDelete?.call();
          break;
      }
    });
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    IconData? icon,
    required String text,
    Color textColor = Theme.of(context).colorScheme.onSurface,
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 8),
            ] else if (isDestructive) ...[
              // No icon for delete, just text
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
                letterSpacing: -0.15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMenu(context),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        color: Colors.transparent, // Hit test 영역 확보
        child: SvgPicture.asset(
          'assets/icons/settings.svg',
          width: 28,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}