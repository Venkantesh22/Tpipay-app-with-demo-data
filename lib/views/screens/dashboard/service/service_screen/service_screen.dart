import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/data/models/service_model/recharge_badge_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/service/service_screen/components/recharge_container.dart';
import 'package:lekra/views/screens/dashboard/service/service_screen/components/top_section.dart'
    show TopSectionService;

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().setServiceModel(serviceModel: null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBgColor,
      body: SingleChildScrollView(
        child: GetBuilder<AuthController>(builder: (authController) {
          final isLoading = authController.isLoading;
          final listLength = authController.rechargeBadgeList.length;

          final itemCount = isLoading ? 2 : (listLength + 1);

          return Column(
            children: [
              const TopSectionService(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Recharge & Bills",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount,
                      separatorBuilder: (_, __) => sizedBoxHeight(height: 24),
                      itemBuilder: (context, index) {
                        if (isLoading) {
                          return CustomShimmer(
                            isLoading: true,
                            child: RechargeContainer(
                              rechargeBadgeModel: RechargeBadgeModel(),
                            ),
                          );
                        }

                        if (index == 0) {
                          return CustomShimmer(
                            isLoading: false,
                            child: RechargeContainer(
                              rechargeBadgeModel: RechargeBadgeModel(
                                title: "Suggested For You",
                                data: authController.suggestedForYouList,
                              ),
                            ),
                          );
                        }

                        final rechargeBadgeModel =
                            authController.rechargeBadgeList[index - 1];

                        return CustomShimmer(
                          isLoading: false,
                          child: RechargeContainer(
                            rechargeBadgeModel: rechargeBadgeModel,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
