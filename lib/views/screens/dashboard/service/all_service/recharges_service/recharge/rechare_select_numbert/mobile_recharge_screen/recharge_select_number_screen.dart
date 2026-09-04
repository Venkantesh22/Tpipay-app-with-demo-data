import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/data/models/recharge_model/recharge_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/recharges_service/recharge/rechare_select_numbert/mobile_recharge_screen/components/recharge_plan_container.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/recharges_service/recharge/rechare_select_numbert/mobile_recharge_screen/components/recharge_plan_heading.dart';
import 'package:lekra/views/screens/dashboard/service/all_service/recharges_service/recharge/rechare_select_numbert/mobile_recharge_screen/components/recharge_select_number_top_section.dart';

class RechargeSelectNumberScreen extends StatefulWidget {
  final bool isMobile;
  const RechargeSelectNumberScreen({
    super.key,
    this.isMobile = false,
  });

  @override
  State<RechargeSelectNumberScreen> createState() =>
      _RechargeSelectNumberScreenState();
}

class _RechargeSelectNumberScreenState
    extends State<RechargeSelectNumberScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rechargeController = Get.find<RechargeController>();
      rechargeController.amountController.clear();
      rechargeController.mobileNumberController.clear();
      rechargeController.setRechargePackageDataModel(
          rechargePackageDataModel: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorLight,
      appBar: AppBar(
        backgroundColor: greyText3,
        title: Text(
          Get.find<AuthController>().selectServiceModel?.serviceName ?? "",
          style: Helper(context).textTheme.titleSmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: white,
              ),
        ),
      ),
      body: GetBuilder<RechargeController>(builder: (rechargeController) {
        final isLoading = rechargeController.isLoading;

        return Column(
          children: [
            const RechargeSelectNumberTopSection(),
            SizedBox(
              height: 70,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final plan = isLoading
                      ? RechargeModel()
                      : rechargeController.rechargeList[index];
                  return RechargePlanHeading(
                    rechargeModel: plan,
                    onTap: () {
                      rechargeController.setRechargeModel(value: plan);
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount:
                    isLoading ? 4 : rechargeController.rechargeList.length,
              ),
            ),
            sizedBoxHeight(height: 10),
            Expanded(
              child: Builder(builder: (context) {
                final packages =
                    rechargeController.searchRechargePackageDataModelList;
                if (isLoading) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemBuilder: (_, idx) => CustomShimmer(
                      isLoading: isLoading,
                      child: RechargePlanContainer(
                        rechargePackageDataModel: RechargePackageDataModel(),
                      ),
                    ),
                    separatorBuilder: (_, __) => sizedBoxHeight(height: 30),
                    itemCount: 4,
                  );
                }
                if (rechargeController.mobileNumberController.text.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.call_end_outlined, size: 56, color: grey),
                        sizedBoxHeight(height: 8),
                        Text(
                          widget.isMobile
                              ? 'Enter Mobile number'
                              : 'Enter DTH number',
                          style: Helper(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: grey),
                        ),
                      ],
                    ),
                  );
                }

                if (packages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 56, color: grey),
                        sizedBoxHeight(height: 8),
                        Text(
                          'No plans found',
                          style: Helper(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemBuilder: (context, index) {
                    final plan = packages[index];
                    return RechargePlanContainer(
                      rechargePackageDataModel: plan,
                    );
                  },
                  separatorBuilder: (_, __) => sizedBoxHeight(height: 30),
                  itemCount: packages.length,
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
