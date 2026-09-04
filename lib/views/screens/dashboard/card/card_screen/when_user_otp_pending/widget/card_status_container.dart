import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CardStatusScreenContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  const CardStatusScreenContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: white2),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 2,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.05),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(
                icon,
                color: primaryColor,
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
