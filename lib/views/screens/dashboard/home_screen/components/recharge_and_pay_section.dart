import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/view_widget.dart';
import 'package:lekra/views/screens/dashboard/service/service_screen/components/service_helper.dart';
import 'package:lekra/views/screens/dashboard/service/service_screen/components/single_recharge_widget.dart';

class RechargeAndPaySection extends StatelessWidget {
  const RechargeAndPaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Recharge & Pay Bills",
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              authController.suggestedForYouList.isNotEmpty
                  ? ViewAllWidget(
                      onPressed: () {
                        Get.find<DashBoardController>().dashPage = 2;
                        navigate(
                            context: context, page: const DashboardScreen());
                      },
                    )
                  : SizedBox(),
            ],
          ),
          sizedBoxHeight(height: 16),

          /// --- LIST SECTION ---
          SizedBox(
            height: 100,
            child: Builder(builder: (_) {
              if (authController.rechargeBadgeList.isEmpty) {
                return const SizedBox();
              }

              return ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(
                  width: 20,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: authController.isLoading
                    ? 4
                    : authController.suggestedForYouList.length,
                itemBuilder: (context, index) {
                  final service = authController.suggestedForYouList[index];

                  return GestureDetector(
                    onTap: () {
                      if (authController.isLoading) return;

                      authController.setServiceModel(serviceModel: service);

                      ServiceHelper.handleNavigation(
                        context,
                        authController,
                      );
                    },
                    child: CustomShimmer(
                        isLoading: authController.isLoading,
                        child: SingleRechargeWidget(serviceModel: service)),
                  );
                },
              );
            }),
          )
        ],
      );
    });
  }
}
