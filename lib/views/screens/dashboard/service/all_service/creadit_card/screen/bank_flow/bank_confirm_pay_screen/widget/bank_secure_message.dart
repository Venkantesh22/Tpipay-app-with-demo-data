import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lekra/services/custom_text.dart';

class BankSecureMessage extends StatelessWidget {
  const BankSecureMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user_rounded,
          size: 16.sp,
          color: const Color(0xFF20A865),
        ),

        SizedBox(width: 6.w),

        CustomText(
          'Your transaction is 100% secure',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF20A865),
              ),
        ),
      ],
    );
  }
}