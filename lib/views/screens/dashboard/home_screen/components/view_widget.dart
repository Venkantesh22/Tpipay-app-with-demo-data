import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class ViewAllWidget extends StatelessWidget {
  final Function()? onPressed;
   const ViewAllWidget({
    super.key,
     required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
      ),
      iconAlignment: IconAlignment.end,
      label: Text(
        "View All",
        style: Helper(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: primaryColor,
            ),
      ),
    );
  }
}
