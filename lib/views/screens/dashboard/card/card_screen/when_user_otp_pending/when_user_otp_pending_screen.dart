import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/card_controller.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/auth_screens/otp_verification_screen.dart';

class WhenUserOtpPendingScreen extends StatelessWidget {
  final String? applyDec;
  const WhenUserOtpPendingScreen({super.key, this.applyDec});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          GetBuilder<CardController>(builder: (cardController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                isLoading: cardController.isLoadingForGenerateOTPForPrepaidCard,
                height: 64,
                radius: 16,
                color: Color(0xFF006B2A),
                onTap: () async {
                  
                  await Get.find<PermissionController>()
                      .requestLocationPermissionAndFetch(context);
                  cardController
                      .generateOTPForPrepaidCard(
                          number: cardController
                                  .prepaidDetailsModel?.mobileNumber ??
                              "")
                      .then((value) {
                    if (!context.mounted) return;
                    if (value.isSuccess) {

                      log("check --1 ");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPVerification(
                            phone: cardController
                                    .prepaidDetailsModel?.mobileNumber ??
                                "",
                            isForPrepaidCardApplyForm: true,
                          ),
                        ),
                      );
                      
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    } else {
                      showToast(
                          message: value.message, typeCheck: value.isSuccess);
                    }
                  });
                },
                child: Text(
                  "Complete OTP Verification",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.titleSmall?.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w700, color: white),
                ),
              ),
            ),
          ],
        );
      }),
      body: GetBuilder<CardController>(builder: (cardController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              SizedBox(height: 30),
              CustomImage(
                path: Assets.imagesCardStatusPending,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      "OTP Verification Pending",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      cardController.prepaidCardUserStatusModel?.userDetails
                              ?.statusDesc ??
                          "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(width: 1, color: white2),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 2,
                        spreadRadius: 0,
                        color: black.withValues(alpha: 0.05),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card Reference No",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      cardController.prepaidCardUserStatusModel?.cardDetails
                              ?.card?.first.cardRefNo ??
                          "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 1, color: white2),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 2,
                            spreadRadius: 0,
                            color: black.withValues(alpha: 0.05),
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CARD TYPE",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                          style: Helper(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: greyDark),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            SvgPicture.asset(
                              Assets.svgsCard,
                              colorFilter: ColorFilter.mode(
                                  primaryColor, BlendMode.srcIn),
                            ),
                            SizedBox(width: 8),
                            Text(
                              cardController.prepaidCardUserStatusModel
                                      ?.cardDetails?.card?.first.cardType ??
                                  "",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: Helper(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1, color: white2),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 2,
                              spreadRadius: 0,
                              color: black.withValues(alpha: 0.05),
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: Helper(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: greyDark),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              SvgPicture.asset(
                                Assets.svgsCard,
                                colorFilter: ColorFilter.mode(
                                    primaryColor, BlendMode.srcIn),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cardController.prepaidCardUserStatusModel
                                          ?.userDetails?.status ??
                                      "",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  style: Helper(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: grey,
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.start,
                        "To finalize your prepaid card setup, please complete the One-Time Password verification. This step is required to activate your digital ledger.",
                        style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: greyText2),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        );
      }),
    );
  }
}
