import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/data/models/service_model/recharge_badge_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/service/service_screen/components/service_helper.dart';
import 'package:lekra/views/screens/dashboard/service/service_screen/components/single_recharge_widget.dart';

class RechargeContainer extends StatelessWidget {
  final RechargeBadgeModel rechargeBadgeModel;
  const RechargeContainer({
    super.key,
    required this.rechargeBadgeModel,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 28,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 8),
              blurRadius: 9,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.25),
            ),
            BoxShadow(
              offset: const Offset(-4, 0),
              blurRadius: 9,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.25),
            ),
          ],
          border: Border.all(
            width: 2,
            color: secondaryColor.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rechargeBadgeModel.title ?? "",
              style: Helper(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 12,
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: authController.isLoading
                  ? 4
                  : rechargeBadgeModel.data?.length,
              itemBuilder: (context, index) {
                final serviceModel = authController.isLoading
                    ? ServiceModel()
                    : rechargeBadgeModel.data?[index];
                return GestureDetector(
                  onTap: () {
                    if (authController.isLoading) return;

                    authController.setServiceModel(serviceModel: serviceModel);

                    ServiceHelper.handleNavigation(
                        context, authController,);
                  },
                  child: CustomShimmer(
                      isLoading: authController.isLoading,
                      child: SingleRechargeWidget(
                        serviceModel: serviceModel,
                      )),
                );
              },
            )
          ],
        ),
      );
    });
  }
}
