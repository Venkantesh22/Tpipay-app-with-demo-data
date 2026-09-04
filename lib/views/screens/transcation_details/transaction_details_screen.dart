import 'package:flutter/material.dart';
import 'package:lekra/data/models/transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/transcation_details/create_dispute_screen/create_dispute_screen.dart';
import 'package:lekra/views/screens/transcation_details/transcation_details_screen/components/row_transaction_details.dart';
import 'package:lekra/views/screens/transcation_details/transcation_details_screen/transaction_top_section.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final TransactionModel? transactionModel;
  const TransactionDetailsScreen({super.key, required this.transactionModel});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: black,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              navigate(context: context, page: const CreateDisputeScreen());
            },
            child: const CircleAvatar(
              backgroundColor: black,
              radius: 14,
              child: Icon(
                Icons.question_mark_sharp,
                color: white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            Center(
              child: TransactionTopSection(widget: widget),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: grey, width: 2),
                    top: BorderSide(color: grey, width: 2),
                    right: BorderSide(color: grey, width: 2),
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.transactionModel?.isYesBankTrans ?? false)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomImage(
                              path: Assets.imagesYesBankLogo,
                              width: 77,
                              height: 19,
                            ),
                            Expanded(
                              child: Text(
                                widget.transactionModel?.provider ?? "",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.start,
                                style: Helper(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  (widget.transactionModel?.isYesBankTrans ?? false)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Divider(
                            color: grey,
                          ),
                        )
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Transaction Details",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.start,
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.5, vertical: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Total Balance:  ${widget.transactionModel?.totalBalanceFormat}",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                            style:
                                Helper(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  (widget.transactionModel?.isYesBankTrans ?? false)
                      ? const SizedBox(
                          height: 12,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Divider(
                            color: grey,
                          ),
                        ),
                  const RowOFTransactionDetails(
                    label: "UPI Transaction ID",
                    value: "285219460485",
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  RowOFTransactionDetails(
                    label:
                        "${(widget.transactionModel?.isYesBankTrans ?? false) ? "To" : "From"} : ${widget.transactionModel?.user ?? ""}",
                    value: "Phone : ${widget.transactionModel?.number ?? ""}",
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
