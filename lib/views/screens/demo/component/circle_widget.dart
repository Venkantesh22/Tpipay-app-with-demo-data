import 'package:flutter/material.dart';
import 'package:lekra/services/theme.dart';

class CircleWidget extends StatelessWidget {
  final bool isSelect;

  const CircleWidget({
    super.key,
    required this.isSelect,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 12,
      width: isSelect ? 34 : 12,
      decoration: BoxDecoration(
        color: isSelect ? black : greyLight,
        borderRadius: BorderRadius.circular(50),
      ),
      curve: Curves.easeInOut,
    );
  }
}