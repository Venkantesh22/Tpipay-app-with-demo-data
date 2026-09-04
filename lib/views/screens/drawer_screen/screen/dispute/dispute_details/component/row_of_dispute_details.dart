import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';

class RowOfDisputeDetails extends StatelessWidget {
  final String label;
  final String value;
  const RowOfDisputeDetails({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text(
              label,
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              " :- ",
              style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        Text(
          value,
          style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
        )
      ],
    );
  }
}
