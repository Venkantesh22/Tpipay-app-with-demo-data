import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CardFormHeadingText extends StatelessWidget {
  final String heading;
  const CardFormHeadingText({
    super.key,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: Helper(context).textTheme.displayLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: purpleLight,
          letterSpacing: 0.6),
    );
  }
}
