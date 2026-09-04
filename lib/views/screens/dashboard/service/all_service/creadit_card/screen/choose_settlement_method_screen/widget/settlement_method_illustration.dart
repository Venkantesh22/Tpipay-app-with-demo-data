import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/theme.dart';

class SettlementMethodIllustration extends StatelessWidget {
  const SettlementMethodIllustration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 230.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Soft background glow
          Container(
            width: 260.w,
            height: 190.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              gradient: RadialGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.10),
                  primaryColor.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Bank building
          Positioned(
            bottom: 32.h,
            right: 54.w,
            child: Container(
              width: 105.w,
              height: 92.h,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.account_balance_rounded,
                    size: 65.sp,
                    color: primaryColor.withValues(alpha: 0.35),
                  ),
                ],
              ),
            ),
          ),

          // Mobile phone
          Positioned(
            bottom: 30.h,
            left: 68.w,
            child: Container(
              width: 48.w,
              height: 88.h,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 27.sp,
                  color: primaryColor.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),

          // Security shield
          Positioned(
            bottom: 74.h,
            left: 132.w,
            child: Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: primaryColorLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_user_outlined,
                size: 24.sp,
                color: primaryColor.withValues(alpha: 0.55),
              ),
            ),
          ),

          // Bottom soft line
          Positioned(
            bottom: 20.h,
            left: 40.w,
            right: 40.w,
            child: Container(
              height: 2.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: primaryColor.withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}