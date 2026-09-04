import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/wallet/add%20money/components/price_container.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Money",
          style: Helper(context).textTheme.bodyMedium?.copyWith(
              fontSize: 17, fontWeight: FontWeight.w700, color: white),
        ),
      ),
      body: GetBuilder<WalletController>(builder: (walletController) {
        return Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              sizedBoxHeight(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 10),
                          blurRadius: 15,
                          spreadRadius: -3,
                          color: black.withValues(alpha: 0.1)),
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: -4,
                          color: black.withValues(alpha: 0.1))
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter Amount",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    sizedBoxHeight(height: 26),
                    AppTextFieldWithHeading(
                      controller: walletController.addMoneyController,
                      hindText: "0",
                      hintStyle: Helper(context).textTheme.titleSmall?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: grey),
                      prefixText: "₹",
                      prefixStyle:
                          Helper(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: greyText,
                              ),
                    ),
                    sizedBoxHeight(height: 20),
                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final price = priceContainerModelList[index];
                          return GestureDetector(
                            onTap: () {
                              walletController.setPrice(price.price);
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: PriceContainer(
                              price: price.price,
                              isSelect: selectedIndex == index,
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: priceContainerModelList.length,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    CustomButton(
                      onTap: () {},
                      height: 48,
                      radius: 8,
                      color: secondaryColor,
                      title: "Add Money",
                      textStyle: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: white),
                    ),
                    const SizedBox(
                      height: 38,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
