import 'package:flutter/material.dart';
import 'package:lekra/data/models/prepaid_card/prepaid_card_mini_statement_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CardMiniStatementsContainer extends StatelessWidget {
  final PrepaidCardMiniStatementModel? prepaidCardMiniStatementModel;
  const CardMiniStatementsContainer({
    super.key,
    required this.prepaidCardMiniStatementModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 6),
              blurRadius: 2,
              spreadRadius: 2,
              color: black.withValues(alpha: 0.05),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prepaidCardMiniStatementModel?.description ?? "",
                style: Helper(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2.5),
              Text(
                prepaidCardMiniStatementModel?.formatDate ?? "",
                style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3F4A3E)),
              ),
            ],
          ),
          Text(
            "${(prepaidCardMiniStatementModel?.isDebit ?? false) ? "-" : "+"}${prepaidCardMiniStatementModel?.formatAmount ?? ""}",
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: (prepaidCardMiniStatementModel?.isDebit ?? false)
                      ? red
                      : primaryColor,
                ),
          ),
        ],
      ),
    );
  }
}
