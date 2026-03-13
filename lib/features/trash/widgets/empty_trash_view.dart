import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyTrashView extends StatelessWidget {
  const EmptyTrashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: const Color(0xFFECECF0).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/trash_empty.svg',
            width: 64,
            height: 64,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '휴지통이 비어있습니다',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Color(0xFF0A0A0A),
            letterSpacing: -0.44,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Text(
          '삭제된 프로젝트가 없습니다',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFF717182),
            letterSpacing: -0.15,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
