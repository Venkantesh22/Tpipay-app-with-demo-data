import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/kyc_form/kyc_form_screen.dart';

class TopSectionService extends StatelessWidget {
  const TopSectionService({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesServiceTopBg),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          sizedBoxHeight(
            height: 70,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Credit Card Top up & Bank A/c Transfer",
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    (Get.find<AuthController>().userModel?.isKYCDone ?? false)
                        ? CustomText(
                            "KYC Done",
                            style: Helper(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: white),
                          )
                        : Column(
                            children: [
                              CustomText(
                                "Get full KYC\nDone",
                                style: Helper(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: white),
                              ),
                              sizedBoxHeight(
                                height: 18,
                              ),
                              SizedBox(
                                width: 140.w,
                                child: CustomButton(
                                  radius: 30.r,
                                  onTap: () {
                                    navigate(
                                        context: context,
                                        page: const KycFormScreen());
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                          "Upgrade Now",
                                          style: Helper(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: white),
                                        ),
                                        sizedBoxWidth(
                                          width: 5,
                                        ),
                                        SvgPicture.asset(
                                          Assets.svgsArrowInCircle,
                                          height: 14.h,
                                          width: 14.w,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
