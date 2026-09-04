import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/data/models/prepaid_card/prepaid_card_mini_statement_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/widget/card_mini_statements_container.dart';

class CardMiniStatementsListSection extends StatelessWidget {
  const CardMiniStatementsListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(builder: (cardController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Activity",
            style: Helper(context).textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: greyText2,
                ),
          ),
          SizedBox(
            height: 16,
          ),
 cardController.prepaidCardMiniStatementModelList.isNotEmpty ?
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final _prepaidCardTransactionModel = cardController.isLoading
                    ? PrepaidCardMiniStatementModel()
                    : cardController.prepaidCardMiniStatementModelList[index];
                return CustomShimmer(
                  isLoading: cardController.isLoading,
                  child: CardMiniStatementsContainer(
                    prepaidCardMiniStatementModel: _prepaidCardTransactionModel,
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 6),
              itemCount: cardController.isLoading
                  ? 4
                  : cardController.prepaidCardMiniStatementModelList.length) : Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(child: Text("No mini Statements found"),),
                  )         
        ],
      );
    });
  }
}
