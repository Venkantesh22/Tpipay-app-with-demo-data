import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/shimmer.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      String mobile = authController.userModel?.mobile ?? "";
      String last4 =
          mobile.length >= 4 ? mobile.substring(mobile.length - 4) : mobile;

      return Column(
        children: [
          Container(
            // height: MediaQuery.of(context).size.height * 0.24,
            padding:
                const EdgeInsets.only(left: 35, right: 30, top: 30, bottom: 50),
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesCard),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Available Balance",
                          style: Helper(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: white),
                        ),
                        CustomShimmer(
                          isLoading: authController.isLoading,
                          child: Text(
                            authController.userModel?.userBalanceFormat ??
                                "111",
                            overflow: TextOverflow.ellipsis,
                            style: Helper(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontSize: 26,
                                    color: white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const CustomImage(
                      color: Colors.white,
                      path: Assets.imagesTpipayWithLogo,
                      width: 96,
                      height: 45,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Card Number",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.start,
                            style: Helper(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: white),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "**** **** **** $last4",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.start,
                            style: Helper(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: white),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Valid From",
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: white),
                        ),
                        Text(
                          "12/28",
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: white),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "View Card Details",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: primaryColor),
                  ),
                ),
              ),
              Container(
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                  color: greyLight,
                  width: 2,
                ))),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Virtual Card",
                    overflow: TextOverflow.clip,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
