import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/button/back_buttton.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class DthRechargeScreen extends StatefulWidget {
  const DthRechargeScreen({super.key});

  @override
  State<DthRechargeScreen> createState() => _DthRechargeScreenState();
}

class _DthRechargeScreenState extends State<DthRechargeScreen> {
  final TextEditingController dthSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: const BoxDecoration(
              color: Color(0xFF355355),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Row(
                  children: [
                    const CustomBackButton(
                      color: white,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: AppTextFieldWithHeading(
                        borderColor: white,
                        bgColor: const Color(0xFF577072),
                        preFixWidget: Icon(Icons.search, color: greyText5),
                        borderRadius: 100,
                        controller: dthSearchController,
                        hindText: "Search DTH Service Provider",
                        hintStyle: Helper(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: greyText5),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
