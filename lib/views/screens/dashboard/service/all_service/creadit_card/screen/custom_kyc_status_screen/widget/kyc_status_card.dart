import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/controllers/card_money_controller/custom_kyc_controller.dart';
import 'package:lekra/services/constants.dart';

import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class KycStatusCard extends StatelessWidget {
  final KycStatus status;

  const KycStatusCard({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isVerified =
        status == KycStatus.verified;

    final bool isRejected =
        status == KycStatus.rejected;

    final Color statusColor = isVerified
        ? Colors.green
        : isRejected
            ? Colors.red
            : Colors.orange;

    final String statusText = isVerified
        ? 'Verified'
        : isRejected
            ? 'Rejected'
            : 'Pending';

    final IconData statusIcon = isVerified
        ? Icons.verified_user_rounded
        : isRejected
            ? Icons.person_off_outlined
            : Icons.person_outline_rounded;

    final String description = isVerified
        ? 'Your KYC has been verified successfully.'
        : isRejected
            ? 'Your KYC has been rejected.'
            : 'Your KYC is under review.\n'
                'We will notify you once it’s verified.';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius:
            BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE6EAF2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Container(
            width: 62.w,
            height: 62.w,
            decoration: BoxDecoration(
              color: primaryColor.withValues(
                alpha: 0.08,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: primaryColor,
              size: 31.r,
            ),
          ),

          sizedBoxWidth(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                CustomText(
                  'KYC Status',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight:
                        FontWeight.w700,
                    color: black,
                  ),
                ),

                sizedBoxHeight(height: 5),

                Container(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 9.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(5.r),
                  ),
                  child: CustomText(
                    statusText,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight:
                          FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),

                sizedBoxHeight(height: 6),

                CustomText(
                  description,
                  style: TextStyle(
                    fontSize: 10.sp,
                    height: 1.5,
                    color: greyDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}