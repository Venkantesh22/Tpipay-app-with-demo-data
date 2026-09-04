import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/widget/card_mini_statements_list_section.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/widget/card_mini_statements_filter_section.dart';
import 'package:lekra/views/screens/dashboard/card/card_screen/screen/card_mini_statements/widget/card_mini_statements_top_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class CardMimiStatementsScreen extends StatefulWidget {
  const CardMimiStatementsScreen({super.key});

  @override
  State<CardMimiStatementsScreen> createState() =>
      _CardMimiStatementsScreenState();
}

class _CardMimiStatementsScreenState extends State<CardMimiStatementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardController = Get.find<CardController>();
      cardController
          .fetchPrepaidCardMiniStatement(context: context)
          .then((value) {
        if (value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);
        } else {
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
        cardController.fetchPrepaidCardBalanceInquiry(context: context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: "Mini Statement"),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardMiniStatementsTopSection(),
            SizedBox(
              height: 33,
            ),
            // CardTransHistoryFilterSection(),
            CardMiniStatementsListSection(),
          ],
        ),
      ),
    );
  }
}
