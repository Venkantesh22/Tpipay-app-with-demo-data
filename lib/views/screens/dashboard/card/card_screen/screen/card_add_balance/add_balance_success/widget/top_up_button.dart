import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';

class TopTupSuccessAndFailsButton extends StatelessWidget {
  final String firstButtonName;
  final Function()? firstOnTap;
  final String secondButtonName;
  final Function()? secondOnTap;
  const TopTupSuccessAndFailsButton({
    super.key,
    required this.firstButtonName,
    this.firstOnTap,
    required this.secondButtonName,
    this.secondOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 28),
        CustomButton(
          height: 54,
          radius: 12,
          onTap: firstOnTap,
          child: Text(
            firstButtonName,
            style: Helper(context).textTheme.displayLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: white,
                ),
          ),
        ),
        SizedBox(height: 12),
        CustomButton(
          height: 54,
          radius: 12,
          borderColor: black,
          type: ButtonType.secondary,
          onTap: secondOnTap,
          child: Text(
            secondButtonName,
            style: Helper(context).textTheme.displayLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: purpleLight,
                ),
          ),
        ),
      ],
    );
  }
}
