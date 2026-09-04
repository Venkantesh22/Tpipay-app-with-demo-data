import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/main_card_screen/widget/row_of_card_management_section.dart';

class CardManagementSection extends StatelessWidget {
  const CardManagementSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          "Card Management",
          style: Helper(context).textTheme.displayLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 8),
        RowOFCardManagementSection()
      ],
    );
  }
}
