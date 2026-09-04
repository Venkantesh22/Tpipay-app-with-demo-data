import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class WalletProfileCardWidget extends StatelessWidget {
  const WalletProfileCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Positioned(
        top: 110,
        left: 50,
        right: 50,
        child: Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 10),
                  blurRadius: 15,
                  spreadRadius: -3,
                  color: black.withValues(alpha: 0.10)),
              BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 6,
                  spreadRadius: -4,
                  color: black.withValues(alpha: 0.10))
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomImage(
                        path: authController.userModel?.profilePhoto ?? "",
                        isProfile: true,
                        height: 64,
                        width: 64,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Text(
                          authController.userModel?.fullName ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Helper(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Balance",
                            style: Helper(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            authController.userModel?.userBalanceFormat ?? "",
                            style: Helper(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontSize: 25, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Tap to add money to wallet",
                            style: Helper(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const Positioned(
                right: 0,
                top: 50,
                child: CustomImage(
                  path: Assets.imagesCoin,
                  height: 93,
                  width: 131,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
