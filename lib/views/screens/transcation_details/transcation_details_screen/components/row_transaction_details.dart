
import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';

class RowOFTransactionDetails extends StatelessWidget {
  final String label;
  final String value;
  const RowOFTransactionDetails({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Helper(context).textTheme.bodySmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          value,
          style: Helper(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
        )
      ],
    );
  }
}
