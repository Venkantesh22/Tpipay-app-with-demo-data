import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CardBalaceInquTopSection extends StatelessWidget {
  const CardBalaceInquTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 12),
          SvgPicture.asset(
            Assets.svgsCheckMarkInCirlce3,
            height: 62,
            width: 62,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16),
          Text(
            "Balance fetched successfully",
            style: Helper(context).textTheme.displayLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: blueDark,
                ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
