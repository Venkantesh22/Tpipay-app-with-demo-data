import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/transcation_history/transaction_history_screen.dart';

class OptionContainer extends StatelessWidget {
  final OptionModel optionModel;
  const OptionContainer({
    super.key,
    required this.optionModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
// RIGHT — this passes a function that will be called when tapped
      onTap: () => optionModel.onTap?.call(context),
      child: Container(
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 11),
        decoration: BoxDecoration(
          color: contactUsBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              optionModel.label,
              style: Helper(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: primaryColor,
                  ),
            ),
            const CircleAvatar(
              radius: 15,
              backgroundColor: primaryColor,
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: white,
                  size: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OptionModel {
  final String label;
  final Function(BuildContext context)? onTap;

  OptionModel({required this.label, required this.onTap});
}

List<OptionModel> optionModelList = [
  OptionModel(
      label: "All Transaction",
      onTap: (BuildContext context) => navigate(
          context: context,
          page: TransactionHistoryScreen(
            fromDateValue: DateTime(2024, 1, 1),
            todateValue: getDateTime(),
          ))),
  OptionModel(
      label: "Yes Bank Merchant Collection",
      onTap: (BuildContext context) => navigate(
          context: context,
          page: TransactionHistoryScreen(
            // isYesBankTransaction: true,
            fromDateValue: DateTime(2024, 1, 1),
            todateValue: getDateTime(),
          ))),
];
