import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/transcation_details/transaction_details_screen.dart';

class TransactionTopSection extends StatelessWidget {
  const TransactionTopSection({
    super.key,
    required this.widget,
  });

  final TransactionDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomImage(
          path: widget.transactionModel?.providerIcon ?? "",
          height: 50,
          width: 50,
          radius: 50,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 27,
        ),
        Text(
          (widget.transactionModel?.isYesBankTrans ?? false)
              ? widget.transactionModel?.user ?? ""
              : widget.transactionModel?.provider ?? "",
          style: Helper(context).textTheme.titleSmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          widget.transactionModel?.amountFormat ?? "",
          style: Helper(context).textTheme.titleSmall?.copyWith(
                fontSize: 20,
                color: widget.transactionModel?.amountStatusColor,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 1),
              borderRadius: BorderRadius.circular(37)),
          child: Text(
            "Opening Balance: ${widget.transactionModel?.openingBalanceFormat}",
            style: Helper(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        const SizedBox(
          height: 27,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.transactionModel?.status == TransactionStatus.SUCCESS
                ? const CircleAvatar(
                    radius: 16,
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.check,
                      color: white,
                    ))
                : CircleAvatar(
                    radius: 16,
                    backgroundColor: primaryColor.withValues(alpha: 0.12),
                    child: SvgPicture.asset(
                      widget.transactionModel?.showIcon ?? "",
                      height: 16,
                      width: 16,
                    ),
                  ),
            const SizedBox(
              width: 8,
            ),
            Text(
              widget.transactionModel?.statusText ?? "",
              style: Helper(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: Divider(
            color: greyLight,
          ),
        ),
        Text(
          DateFormatters().dateTime.format(
                widget.transactionModel?.createdAt ?? getDateTime(),
              ),
          style: Helper(context).textTheme.bodySmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
