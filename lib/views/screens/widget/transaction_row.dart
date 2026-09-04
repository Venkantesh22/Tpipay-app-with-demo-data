import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';

class TransactionRow extends StatelessWidget {
  final TransactionModel? transactionModel;
 const   TransactionRow({
    super.key,
   required this.transactionModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryColor.withValues(alpha: 0.12),
              child: SvgPicture.asset(
                transactionModel?.showIcon ?? "",
                height: 18,
                width: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactionModel?.serviceName ?? "",
                    style: Helper(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  sizedBoxHeight(height: 4),
                  Text(
                    "Mno: ${transactionModel?.number}",
                    style: Helper(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: greyText),
                  ),
                  sizedBoxHeight(height: 6),
                  Text(
                    "TXN # ${transactionModel?.txnid}",
                    style: Helper(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: greyText),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      transactionModel?.isAddORMinus ?? "",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          color: transactionModel?.amountStatusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.6),
                    ),
                    Text(
                      transactionModel?.amountFormat ?? "0.0",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          color: transactionModel?.amountStatusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.6),
                    ),
                  ],
                ),
                Text(
                  transactionModel?.statusText ?? "",
                  style: Helper(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: transactionModel?.statusColor),
                ),
                sizedBoxHeight(height: 6),
                Text(
                  transactionModel?.dateFormat ??
                      DateFormatters().dateTime.format(DateTime.now()),
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 11, fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
