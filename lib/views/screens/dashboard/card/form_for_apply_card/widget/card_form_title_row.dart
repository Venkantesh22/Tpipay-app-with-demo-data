import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CardFormTitleRow extends StatelessWidget {
  final String icon;
  final String title;

  const CardFormTitleRow({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 20,
          colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: Helper(context).textTheme.displayLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
