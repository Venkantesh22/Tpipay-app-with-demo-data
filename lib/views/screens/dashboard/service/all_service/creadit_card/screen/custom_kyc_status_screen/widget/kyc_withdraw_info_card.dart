import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/custom_text.dart';
import 'package:lekra/services/theme.dart';

class KycWithdrawInfoCard extends StatelessWidget {
  const KycWithdrawInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFD5E3FF),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: primaryColor,
              size: 18.r,
            ),
          ),

          sizedBoxWidth(width: 10),

          Expanded(
            child: CustomText(
              'Only verified customers can withdraw money.',
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.5,
                color: const Color(0xFF27366F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}